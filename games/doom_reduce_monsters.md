# Reducir monstruos de Doom

```sh
~/src/scripts/games/doom_reduce_monsters.py -p 50 -m "/ruta/completa/mapa.wad"
```

Crea `/ruta/completa/mapa_50perc.wad`. El original queda intacto y una salida
existente nunca se sobrescribe. `-p` indica el porcentaje **a quitar**, no el que
queda; admite valores de 0 a 100 y decimales (`12.5` → `_12.5perc`).

También acepta PK3/ZIP/IPK3 y PK7/7Z con WAD anidados, conservando el formato del
paquete y los recursos no editados. Para PK7/7Z necesita `7z` o `7zz`.

```sh
# Consultar recuentos sin escribir
~/src/scripts/games/doom_reduce_monsters.py -p 30 -m "/ruta/mapa.pk3" --dry-run
# Cambiar la selección reproducible de monstruos
~/src/scripts/games/doom_reduce_monsters.py -p 30 -m "/ruta/mapa.pk3" --seed 123
# Destino alternativo
~/src/scripts/games/doom_reduce_monsters.py -p 25 -m "/ruta/mapa.wad" -o "/otra/copia.wad"
```

Aplica el porcentaje por mapa a los monstruos elegibles, redondeando al entero
más cercano (mitades hacia arriba). La semilla predeterminada es 0.

Conserva jugadores, armas, munición, llaves, decoración y demás recursos.
Protege aliados, Commander Keen, jefes de mapas con salidas conocidas y actores
con ID/acciones en mapas Hexen/UDMF. Si hay acciones de jefes personalizadas en
MAPINFO, protege también los tipos de jefe estándar de forma conservadora.
Por eso un 100 % no elimina los monstruos protegidos; el resumen muestra cuántos
son y cuántos se quitaron realmente.

Soporta mapas binarios de Doom, mapas **de Doom** en formato Hexen y UDMF de Doom.
No es un reductor de los juegos Hexen/Heretic/Strife. Reconoce los monstruos
estándar de Doom/Doom II; para un monstruo personalizado se puede repetir
`--extra-monster-type DOOMEDNUM`. No interpreta ACS, DEHACKED, DECORATE ni ZScript,
por lo que las mecánicas de mods complejos requieren una prueba dentro del juego.

