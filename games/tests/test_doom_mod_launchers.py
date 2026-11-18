#!/usr/bin/env python3
"""Local-library regression tests; engines are replaced by argument-capture stubs.

Run: python3 -m unittest discover -s ~/src/scripts/games/tests -v
DOOM_LIBRARY can override ~/games/doom. No games or downloads are started.
"""
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import unittest

SCRIPTS = Path(__file__).resolve().parents[1]
LIBRARY = Path(os.environ.get('DOOM_LIBRARY', Path.home() / 'games/doom')).resolve()


@unittest.skipUnless((LIBRARY / 'maps/iwads/doom2.wad').is_file(), 'local Doom library required')
class DoomModLaunchers(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory(prefix='doom-launcher-test-')
        self.addCleanup(self.tmp.cleanup)
        self.root = Path(self.tmp.name)
        self.home = self.root / 'home'
        (self.home / 'games').mkdir(parents=True)
        (self.home / 'games/doom').symlink_to(LIBRARY, target_is_directory=True)
        self.scripts = self.root / 'scripts'
        self.scripts.mkdir()
        for source in SCRIPTS.glob('*.sh'):
            target = self.scripts / source.name
            shutil.copy2(source, target)
            # Fixture copies must not overwrite the user's normal /tmp engine logs.
            text = target.read_text().replace('/tmp/uzdoom.log', str(self.root / 'uzdoom.log'))
            text = text.replace('/tmp/gzdoom.log', str(self.root / 'gzdoom.log'))
            target.write_text(text)
        self.capture = self.root / 'args.json'
        stub = (f'#!{sys.executable}\n'
                'import json, os, sys\n'
                'with open(os.environ["DOOM_TEST_CAPTURE"], "w") as f:\n'
                '    json.dump(sys.argv[1:], f)\n')
        for executable in ('src/UZDoom/build/uzdoom', 'src/gzdoom/build/gzdoom',
                           'bin/flatpak', 'bin/gzdoom', 'bin/uzdoom'):
            path = self.home / executable
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text(stub)
            path.chmod(0o755)
        self.env = dict(os.environ, HOME=str(self.home), DOOM_TEST_CAPTURE=str(self.capture),
                        PATH=str(self.home / 'bin') + os.pathsep + os.environ['PATH'])

    def run_launcher(self, name, *args):
        shell = 'bash' if name == 'launchGzdoom.sh' else 'sh'
        result = subprocess.run([shell, str(self.scripts / name), *args], env=self.env,
                                input='\n', text=True, capture_output=True, timeout=30)
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertTrue(self.capture.exists(), result.stdout + result.stderr)
        argv = json.loads(self.capture.read_text())
        for flag in ('-iwad', '-config'):
            self.assertIn(flag, argv)
            self.assertTrue(Path(argv[argv.index(flag) + 1]).is_file(), argv)
        start = argv.index('-file') + 1
        files = []
        for arg in argv[start:]:
            if arg.startswith(('-', '+')):
                break
            files.append(arg)
        self.assertTrue(files)
        for file in files:
            self.assertTrue(Path(file).is_file(), f'missing file: {file}')
        return argv, files

    def test_versioned_profiles(self):
        cases = {
            'uzdoom_doom_projectbrutality.sh': 'PB-0_4_1.pk3',
            'uzdoom_doom2_projectbrutality.sh': 'PB-0_4_1.pk3',
            'gzdoom-flatpak_doom_projectbrutality.sh': 'PB-0_4_1.pk3',
            'gzdoom-flatpak_doom2_projectbrutality.sh': 'PB-0_4_1.pk3',
            'uzdoom_heretic_brutal.sh': 'BrutalHereticRPG_V6.5.pk3',
            'gzdoom-flatpak_heretic_brutal.sh': 'BrutalHereticRPG_V6.5.pk3',
            'uzdoom_hexen_brutal.sh': 'BrutalHexenRPG_V8.0_beta.pk3',
            'gzdoom-flatpak_hexen_brutal.sh': 'BrutalHexenRPG_V8.0_beta.pk3',
            'uzdoom_doom2_beautiful.sh': 'relighting_v4.0165b.pk3',
        }
        for script, expected in cases.items():
            with self.subTest(script=script):
                self.capture.unlink(missing_ok=True)
                _, files = self.run_launcher(script)
                self.assertIn(expected, [Path(p).name for p in files])
                # Updating versions must not silently enable extra Heretic textures.
                if script == 'uzdoom_heretic_brutal.sh':
                    self.assertNotIn('heretic_gz.pk3', [Path(p).name for p in files])
                if script == 'gzdoom-flatpak_heretic_brutal.sh':
                    self.assertIn('heretic_gz.pk3', [Path(p).name for p in files])

    def test_legacy_flags_and_current_paths(self):
        for game, expected in [('doom2', 'brutalv21.50.1.pk3'),
                               ('heretic', 'BrutalHereticRPG_V6.5.pk3'),
                               ('hexen', 'BrutalHexenRPG_V8.0_beta.pk3')]:
            for flag in ('--brutal', '-b'):
                with self.subTest(game=game, flag=flag):
                    self.capture.unlink(missing_ok=True)
                    map_file = str(LIBRARY / f'maps/iwads/{game}.wad')
                    # Put the switch before another option to catch the old double shift.
                    _, files = self.run_launcher('launchGzdoom.sh', flag, '--iwad', game,
                                                 '--wads', map_file)
                    self.assertIn(expected, [Path(p).name for p in files])

    def test_legacy_beautiful_and_no_mod_switch(self):
        for flags in ([], ['--beautiful']):
            with self.subTest(flags=flags):
                self.capture.unlink(missing_ok=True)
                _, files = self.run_launcher('launchGzdoom.sh', '--iwad', 'doom2', '--wad',
                                             str(LIBRARY / 'maps/iwads/doom2.wad'), *flags)
                if flags:
                    self.assertIn('beautiful_doom_716.pk3', [Path(p).name for p in files])

    def test_random_launcher_project_brutality_dry_run(self):
        result = subprocess.run(['sh', str(self.scripts / 'doom_random_launcher.sh'), '--dry-run'],
                                input='2\n5\n6\n', text=True, capture_output=True,
                                env=self.env, timeout=30)
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertIn('Project Brutality', result.stdout)
        self.assertIn('Simulacion', result.stdout)
        self.assertFalse(self.capture.exists(), 'dry run must not launch an engine')


if __name__ == '__main__':
    unittest.main()
