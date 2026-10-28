#!/usr/bin/env python3
"""Crea una copia de un WAD/PK3/PK7 con menos monstruos estándar de Doom.

Formatos de mapas: Doom binario, Doom en formato Hexen y UDMF de Doom.
Fuentes de los formatos: UZDoom specs/udmf.txt y src/doomdata.h; los
DoomEdNums estándar están en Chocolate Doom src/doom/info.c.
El original nunca se modifica. No ejecuta scripts del mapa.
"""

from __future__ import annotations

import argparse
import copy
from dataclasses import dataclass, field
from decimal import Decimal, InvalidOperation, ROUND_HALF_UP
import hashlib
import io
import os
from pathlib import Path, PurePosixPath
import random
import re
import shutil
import struct
import subprocess
import tempfile
import zipfile


MONSTERS = frozenset({7, 9, 16, 58, 64, 65, 66, 67, 68, 69, 71, 72, 84,
                      3001, 3002, 3003, 3004, 3005, 3006})
BOSS_TYPES = frozenset({7, 16, 67, 68, 72, 3003})
BOSS_MAPS = {"E1M8": {3003}, "E2M8": {16}, "E3M8": {7},
             "E4M6": {16}, "E4M8": {7}, "MAP07": {67, 68}}
PACKAGES = {".wad", ".pk3", ".ipk3", ".zip", ".pk7", ".7z"}
SEVEN_MAGIC = b"7z\xbc\xaf\x27\x1c"


class MapError(ValueError):
    pass


@dataclass
class Options:
    percent: Decimal
    seed: int = 0
    extra_types: frozenset[int] = frozenset()


@dataclass
class MapResult:
    container: str
    name: str
    format: str
    monsters: int = 0
    protected: int = 0
    removed: int = 0
    note: str = ""


@dataclass
class Results:
    maps: list[MapResult] = field(default_factory=list)


def boss_metadata(data: bytes) -> bool:
    # Custom boss actions may operate outside the stock boss maps.
    return bool(re.search(rb"\b(?:bossaction\w*|specialaction)\b", data, re.I))


def is_protected(kind: int, map_name: str, custom_bosses: bool) -> bool:
    return (kind == 72 or kind in BOSS_MAPS.get(map_name.upper(), set())
            or (custom_bosses and kind in BOSS_TYPES))


def choose(candidates: list[int], opts: Options, context: str) -> set[int]:
    count = int((len(candidates) * opts.percent / 100).quantize(
        Decimal("1"), rounding=ROUND_HALF_UP))
    seed = hashlib.sha256(f"{opts.seed}\0{context}".encode()).digest()
    return set(random.Random(seed).sample(candidates, count))


def thin_binary(data: bytes, hexen: bool, name: str, context: str,
                opts: Options, custom_bosses: bool) -> tuple[bytes, MapResult]:
    size = 20 if hexen else 10
    if len(data) % size:
        raise MapError(f"{context}/{name}: THINGS no tiene registros de {size} bytes")
    result = MapResult(context, name, "Hexen (Doom)" if hexen else "Doom")
    candidates = []
    for index, pos in enumerate(range(0, len(data), size)):
        kind = struct.unpack_from("<H", data, pos + (10 if hexen else 6))[0]
        if kind not in MONSTERS | opts.extra_types:
            continue
        result.monsters += 1
        if hexen:
            tid = struct.unpack_from("<H", data, pos)[0]
            flags = struct.unpack_from("<H", data, pos + 12)[0]
            scripted = tid != 0 or any(data[pos + 14:pos + 20]) or bool(flags & 0x10)
            friendly = bool(flags & 0x2000)
        else:
            flags = struct.unpack_from("<H", data, pos + 8)[0]
            scripted = False
            friendly = bool(flags & 0x80)  # MBF friendly thing flag
        if scripted or friendly or is_protected(kind, name, custom_bosses):
            result.protected += 1
        else:
            candidates.append(index)
    deleted = choose(candidates, opts, f"{context}/{name}")
    result.removed = len(deleted)
    if not deleted:
        return data, result
    return b"".join(data[p:p + size] for i, p in enumerate(range(0, len(data), size))
                    if i not in deleted), result


# Tokenize before locating blocks, so 'thing { ... }' inside a quoted string
# or a comment is never mistaken for an actor. Keep byte offsets unchanged.
TOKEN = re.compile(
    r'(?P<skip>\s+|//[^\n]*|/\*.*?\*/)|'
    r'(?P<string>"(?:\\.|[^"\\])*")|'
    r'(?P<word>[A-Za-z_][A-Za-z_0-9]*)|'
    r'(?P<number>[+-]?(?:0[xX][0-9a-fA-F]+|(?:\d+(?:\.\d*)?|\.\d+)(?:[eE][+-]?\d+)?))|'
    r'(?P<symbol>[{}=;])|(?P<bad>.)', re.S)


def integer(value: str) -> int:
    sign = -1 if value.startswith("-") else 1
    raw = value.lstrip("+-")
    if raw.lower().startswith("0x"):
        return sign * int(raw, 16)
    if len(raw) > 1 and raw.startswith("0") and raw.isdigit():
        return sign * int(raw, 8)
    return int(value, 10)


def thin_udmf(data: bytes, name: str, context: str, opts: Options,
              custom_bosses: bool) -> tuple[bytes, MapResult]:
    text = data.decode("latin-1")  # 1 byte == 1 character, including UTF-8 comments
    tokens = []
    for m in TOKEN.finditer(text, 3 if data.startswith(b"\xef\xbb\xbf") else 0):
        if m.lastgroup == "bad":
            raise MapError(f"{context}/{name}: sintaxis UDMF inválida cerca del byte {m.start()}")
        if m.lastgroup != "skip":
            tokens.append((m.group(), m.start(), m.end()))
    namespace = None
    things = []
    i = 0
    while i < len(tokens):
        key, start, _ = tokens[i]
        if i + 1 >= len(tokens):
            raise MapError(f"{context}/{name}: declaración UDMF incompleta")
        if tokens[i + 1][0] == "=":
            if i + 3 >= len(tokens) or tokens[i + 3][0] != ";":
                raise MapError(f"{context}/{name}: asignación UDMF inválida")
            if key.lower() == "namespace":
                namespace = tokens[i + 2][0].strip('"').lower()
            i += 4
            continue
        if tokens[i + 1][0] != "{":
            raise MapError(f"{context}/{name}: bloque UDMF inválido")
        begin = i
        i += 2
        props = {}
        while i < len(tokens) and tokens[i][0] != "}":
            if i + 3 >= len(tokens) or tokens[i + 1][0] != "=" or tokens[i + 3][0] != ";":
                raise MapError(f"{context}/{name}: propiedad UDMF inválida")
            props[tokens[i][0].lower()] = tokens[i + 2][0]
            i += 4
        if i == len(tokens):
            raise MapError(f"{context}/{name}: bloque UDMF sin cierre")
        if key.lower() == "thing":
            things.append((tokens[begin][1], tokens[i][2], props))
        i += 1
    result = MapResult(context, name, "UDMF")
    if namespace not in {"doom", "zdoom", "zdoomtranslated", "eternity", "vavoom"}:
        result.note = f"sin modificar: namespace {namespace!r} no identificado como Doom"
        return data, result
    candidates = []
    for index, (_, _, props) in enumerate(things):
        try:
            kind = integer(props.get("type", "0"))
            tagged = any(integer(props.get(k, "0")) for k in
                         ("id", "tid", "special", "arg0", "arg1", "arg2", "arg3", "arg4"))
        except ValueError as exc:
            raise MapError(f"{context}/{name}: type/id/special/arg debe ser entero") from exc
        if kind not in MONSTERS | opts.extra_types:
            continue
        result.monsters += 1
        friendly = props.get("friend", props.get("friendly", "false")).lower() == "true"
        dormant = props.get("dormant", "false").lower() == "true"
        if tagged or friendly or dormant or is_protected(kind, name, custom_bosses):
            result.protected += 1
        else:
            candidates.append(index)
    deleted = choose(candidates, opts, f"{context}/{name}")
    result.removed = len(deleted)
    if not deleted:
        return data, result
    parts = []
    cursor = 0
    for index, (start, end, _) in enumerate(things):
        if index in deleted:
            parts.append(data[cursor:start])
            cursor = end
    parts.append(data[cursor:])
    return b"".join(parts), result


def read_wad(data: bytes) -> tuple[bytes, list[tuple[bytes, bytes]]]:
    if len(data) < 12 or data[:4] not in (b"IWAD", b"PWAD"):
        raise MapError("cabecera WAD inválida")
    count, directory = struct.unpack_from("<ii", data, 4)
    if count < 0 or directory < 0 or directory + count * 16 > len(data):
        raise MapError("directorio WAD fuera del archivo")
    lumps = []
    for i in range(count):
        pos, size, name = struct.unpack_from("<ii8s", data, directory + i * 16)
        if pos < 0 or size < 0 or pos + size > len(data):
            raise MapError(f"lump WAD {i} fuera del archivo")
        lumps.append((name, data[pos:pos + size]))
    return data[:4], lumps


def write_wad(magic: bytes, lumps: list[tuple[bytes, bytes]]) -> bytes:
    out = io.BytesIO()
    out.write(b"\0" * 12)
    entries = []
    for name, payload in lumps:
        entries.append((out.tell(), len(payload), name))
        out.write(payload)
    directory = out.tell()
    for entry in entries:
        out.write(struct.pack("<ii8s", *entry))
    out.seek(0)
    out.write(struct.pack("<4sii", magic, len(lumps), directory))
    return out.getvalue()


def rewrite_wad(data: bytes, context: str, opts: Options, results: Results,
                inherited_bosses: bool) -> bytes:
    magic, lumps = read_wad(data)
    names = [n.rstrip(b"\0").decode("ascii", "replace").upper() for n, _ in lumps]
    bosses = inherited_bosses or any(boss_metadata(payload) for name, payload in lumps
                                   if name.rstrip(b"\0").upper() in
                                   (b"MAPINFO", b"ZMAPINFO", b"UMAPINFO"))
    starts = [i for i in range(len(lumps) - 1)
              if names[i + 1] == "TEXTMAP" or
              names[i + 1:i + 5] == ["THINGS", "LINEDEFS", "SIDEDEFS", "VERTEXES"]]
    changed = False
    for ordinal, start in enumerate(starts):
        end = starts[ordinal + 1] if ordinal + 1 < len(starts) else len(lumps)
        index = start + 1
        name = names[start]
        payload = lumps[index][1]
        # Repeated map names still get different, reproducible random samples.
        ctx = f"{context}#{ordinal}"
        if names[index] == "TEXTMAP":
            if "ENDMAP" not in names[index + 1:end]:
                raise MapError(f"{context}/{name}: falta ENDMAP")
            new, stat = thin_udmf(payload, name, ctx, opts, bosses)
        else:
            new, stat = thin_binary(payload, "BEHAVIOR" in names[index + 1:end],
                                    name, ctx, opts, bosses)
        results.maps.append(stat)
        if new != payload:
            changed = True
            lumps[index] = (lumps[index][0], new)
    return write_wad(magic, lumps) if changed else data


def safe_member(name: str) -> str:
    p = PurePosixPath(name.replace("\\", "/"))
    if (p.is_absolute() or ".." in p.parts or not p.parts or
            re.match(r"^[A-Za-z]:", str(p)) or any(c in name for c in "\r\n\0")):
        raise MapError(f"ruta de paquete no admitida: {name!r}")
    return str(p)


def rewrite_zip(data: bytes, context: str, opts: Options, results: Results,
                inherited_bosses: bool, depth: int) -> bytes:
    changed = False
    out = io.BytesIO()
    with zipfile.ZipFile(io.BytesIO(data)) as zin, zipfile.ZipFile(out, "w") as zout:
        infos = zin.infolist()
        bosses = inherited_bosses or any(
            boss_metadata(zin.read(info)) for info in infos
            if PurePosixPath(info.filename).name.lower() in
            {"mapinfo", "zmapinfo", "umapinfo"})
        zout.comment = zin.comment
        for info in infos:
            payload = zin.read(info)
            new = payload
            if Path(info.filename).suffix.lower() in PACKAGES:
                new = rewrite_blob(payload, f"{context}!{info.filename}", opts,
                                   results, bosses, depth + 1)
            changed |= new != payload
            zout.writestr(copy.copy(info), new)
    return out.getvalue() if changed else data


def seven_run(args: list[str], cwd: Path | None = None) -> bytes:
    exe = shutil.which("7z") or shutil.which("7zz")
    if not exe:
        raise MapError("para PK7/7Z hace falta 7z o 7zz")
    proc = subprocess.run([exe, *args], cwd=cwd, stdin=subprocess.DEVNULL,
                          capture_output=True, timeout=60)
    if proc.returncode != 0:
        raise MapError("7z: " + (proc.stderr or proc.stdout).decode(errors="replace")[-1000:])
    return proc.stdout


def rewrite_seven(data: bytes, context: str, opts: Options, results: Results,
                  inherited_bosses: bool, depth: int) -> bytes:
    # Never let 7z extract paths: each member is read to stdout and written by us.
    with tempfile.TemporaryDirectory(prefix="doom-monsters-") as td:
        root = Path(td)
        archive = root / "input.7z"
        archive.write_bytes(data)
        listing = seven_run(["l", "-slt", "-ba", str(archive)]).decode("utf-8-sig")
        records = []
        for block in re.split(r"\r?\n\s*\r?\n", listing.strip()):
            item = dict(line.split(" = ", 1) for line in block.splitlines() if " = " in line)
            if "Path" not in item:
                continue
            name = safe_member(item["Path"])
            if name.startswith(("@", "-")) or item.get("Encrypted") == "+":
                raise MapError("miembro 7z cifrado o nombre no admitido")
            if item.get("Symbolic Link") or item.get("Hard Link"):
                raise MapError("enlaces dentro de PK7/7Z no admitidos")
            directory = item.get("Folder") == "+" or item.get("Attributes", "").startswith("D")
            payload = b"" if directory else seven_run(
                ["x", "-so", "-bd", "-y", "-spd", str(archive), "--", item["Path"]])
            if not directory and len(payload) != int(item.get("Size", "-1")):
                raise MapError(f"tamaño 7z inesperado: {name}")
            records.append((name, payload, directory))
        bosses = inherited_bosses or any(boss_metadata(payload) for name, payload, _ in records
                                         if PurePosixPath(name).name.lower() in
                                         {"mapinfo", "zmapinfo", "umapinfo"})
        stage = root / "contents"
        stage.mkdir()
        changed = False
        for name, payload, directory in records:
            target = stage / name
            if directory:
                target.mkdir(parents=True, exist_ok=True)
                continue
            new = rewrite_blob(payload, f"{context}!{name}", opts, results, bosses, depth + 1) \
                if Path(name).suffix.lower() in PACKAGES else payload
            changed |= new != payload
            target.parent.mkdir(parents=True, exist_ok=True)
            target.write_bytes(new)
        if not changed:
            return data
        output = root / "output.7z"
        seven_run(["a", "-t7z", "-mx=3", "-bd", "-y", str(output), "."], cwd=stage)
        seven_run(["t", "-bd", str(output)])
        return output.read_bytes()


def rewrite_blob(data: bytes, context: str, opts: Options, results: Results,
                 inherited_bosses: bool = False, depth: int = 0) -> bytes:
    if depth > 8:
        raise MapError("más de 8 niveles de paquetes anidados")
    if data[:4] in (b"IWAD", b"PWAD"):
        return rewrite_wad(data, context, opts, results, inherited_bosses)
    if data.startswith(SEVEN_MAGIC):
        return rewrite_seven(data, context, opts, results, inherited_bosses, depth)
    if zipfile.is_zipfile(io.BytesIO(data)):
        return rewrite_zip(data, context, opts, results, inherited_bosses, depth)
    raise MapError(f"{context}: formato no reconocido (WAD, ZIP/PK3 o 7Z/PK7)")


def percentage(value: str) -> Decimal:
    try:
        p = Decimal(value.replace(",", "."))
    except InvalidOperation as exc:
        raise argparse.ArgumentTypeError("porcentaje inválido") from exc
    if not p.is_finite() or not 0 <= p <= 100:
        raise argparse.ArgumentTypeError("el porcentaje debe estar entre 0 y 100")
    return abs(p) if not p else p


def percent_label(p: Decimal) -> str:
    label = format(p, "f")
    return label.rstrip("0").rstrip(".") if "." in label else label


def publish(output: Path, data: bytes) -> None:
    # Validate/transform everything before reserving the destination. O_EXCL
    # avoids overwriting an existing file (including a symlink) in a race.
    fd, temp_name = tempfile.mkstemp(prefix=".doom-monsters-", dir=output.parent)
    temp = Path(temp_name)
    reserved = None
    try:
        with os.fdopen(fd, "wb") as stream:
            stream.write(data)
            stream.flush()
            os.fsync(stream.fileno())
        fd = os.open(output, os.O_WRONLY | os.O_CREAT | os.O_EXCL, 0o666)
        reserved = os.fstat(fd)
        os.close(fd)
        os.replace(temp, output)
        reserved = None
    finally:
        temp.unlink(missing_ok=True)
        if reserved is not None and output.exists():
            now = output.stat()
            if (now.st_dev, now.st_ino) == (reserved.st_dev, reserved.st_ino):
                output.unlink()


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__.split("\n")[0],
        epilog="El porcentaje se aplica por mapa a monstruos elegibles; se protegen "
               "jefes que activan salidas, aliados y actores con ID/acciones. "
               "No interpreta ACS, ZScript ni DEHACKED. No sobrescribe archivos.")
    parser.add_argument("-p", "--percentage", type=percentage, required=True,
                        help="porcentaje a QUITAR, de 0 a 100 (admite decimales)")
    parser.add_argument("-m", "--map", dest="source", type=Path, required=True,
                        help="ruta del WAD, PK3/ZIP/IPK3 o PK7/7Z de Doom")
    parser.add_argument("-o", "--output", type=Path, help="salida alternativa; debe ser nueva")
    parser.add_argument("--seed", type=int, default=0,
                        help="semilla reproducible (predeterminada: 0)")
    parser.add_argument("--extra-monster-type", type=int, action="append", default=[],
                        help="DoomEdNum de monstruo adicional; se puede repetir")
    parser.add_argument("--dry-run", action="store_true", help="muestra recuentos sin crear archivo")
    args = parser.parse_args(argv)
    source = args.source.expanduser().absolute()
    label = percent_label(args.percentage)
    try:
        if not source.is_file():
            raise MapError(f"no existe el archivo: {source}")
        output = args.output.expanduser().absolute() if args.output else \
            source.with_name(f"{source.stem}_{label}perc{source.suffix}")
        if output.resolve() == source.resolve():
            raise MapError("la salida no puede ser el archivo de entrada")
        if not args.dry_run and os.path.lexists(output):
            raise MapError(f"la salida ya existe: {output}")
        if any(t <= 0 or t > 65535 for t in args.extra_monster_type):
            raise MapError("DoomEdNum adicional fuera del intervalo 1..65535")
        opts = Options(args.percentage, args.seed, frozenset(args.extra_monster_type))
        results = Results()
        new = rewrite_blob(source.read_bytes(), "archivo", opts, results)
        if not results.maps:
            raise MapError("no se encontraron mapas dentro del archivo")
        for stat in results.maps:
            eligible = stat.monsters - stat.protected
            print(f"{stat.container}/{stat.name} [{stat.format}]: "
                  f"{stat.monsters} monstruos, {stat.protected} protegidos; "
                  f"quitar {stat.removed}/{eligible} elegibles"
                  + (f"; {stat.note}" if stat.note else ""))
        if args.dry_run:
            print(f"Simulación: {sum(s.removed for s in results.maps)} monstruos menos; sin escribir.")
        else:
            publish(output, new)
            print(f"Creado: {output}")
        return 0
    except (MapError, OSError, zipfile.BadZipFile, RuntimeError, subprocess.TimeoutExpired,
            struct.error, OverflowError) as exc:
        parser.exit(2, f"Error: {exc}\n")


if __name__ == "__main__":
    raise SystemExit(main())
