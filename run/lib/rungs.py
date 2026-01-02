import argparse
import fractions
import pathlib
import shlex
import subprocess
import sys
import threading
import types

libdir = pathlib.Path(__file__).absolute().parent
psdir = libdir.parent.parent / 'postscript'


class GhostScriptPool:
    def __init__(self):
        self.sink = SharedSink(sys.stderr)
        self.procs = []
        self.streams = []

    def add(self, name, proc):
        self.procs.append(proc)
        self.streams.append(PipedStream(f"{name}(out)", proc.stdout, self.sink))
        self.streams[-1].start()
        self.streams.append(PipedStream(f"{name}(err)", proc.stderr, self.sink))
        self.streams[-1].start()

    def __enter__(self):
        self.procs = []
        self.streams = []
        return self

    def __exit__(self, exc_type, exc_val, tb):
        success = True
        for proc in self.procs:
            code = proc.wait()
            if code != 0:
                success = False
        for stream in self.streams:
            stream.join()
        if not success:
            raise RuntimeError("one or more subprocesses failed")


class GhostScriptProcess(subprocess.Popen):
    def __init__(self, scripts, popen_kwargs=None, *args, **kwargs):
        if popen_kwargs is None:
            popen_kwargs = {}
        defs = []
        for arg, val in kwargs.items():
            defs.extend(['-c', f'/{arg} {str(val)} def'])
        script_files = []
        for script in scripts:
            script_files.extend(['-f', script])
        cmd = ['gs', '-dNOSAFER', '-sDEVICE=x11alpha', '-dBATCH',
               *args, *defs, *script_files]
        cmdline = ' '.join(shlex.quote(arg) for arg in cmd)
        print(f"Executing: {cmdline}")
        super().__init__(cmd, **popen_kwargs, cwd=psdir)


class PipedStream(threading.Thread):
    def __init__(self, name, source, sink):
        super().__init__(name=name)
        self.source = source
        self.sink = sink

    def run(self):
        for line in self.source:
            self.sink.add(f"\033[33;1m[{self.name}]\033[0m {line.decode('utf-8')}")
        self.sink.add(f"\033[34;1;1m[{self.name} finished]\033[0m\n")


class SharedSink:
    def __init__(self, stream):
        self.lock = threading.Lock()
        self.stream = stream

    def add(self, line):
        with self.lock:
            self.stream.write(line)


class ScriptRunnerBase:
    def __init__(self, scripts, **kwargs):
        self.scripts = scripts
        self.parser = argparse.ArgumentParser()
        self.defaults = types.SimpleNamespace(width=None, height=None)
        for name, val in kwargs.items():
            setattr(self.defaults, name, val)

    def run(self, *args, **kwargs):
        proc = GhostScriptProcess(self.scripts, {}, *args, **kwargs)
        code = proc.wait()
        if code != 0:
            raise RuntimeError("subprocess failed with code %d" % code)

    def main(self, *args):
        parsed_args = self.parser.parse_args()
        self.run(*args, **vars(parsed_args))


class ScriptRunner(ScriptRunnerBase):
    def __init__(self, scripts, device_width, device_height, **kwargs):
        super().__init__(scripts, **kwargs)
        self.dw = device_width
        self.dh = device_height
        self.parser.add_argument('--width', type=int)
        self.parser.add_argument('--height', type=int)
        self.parser.add_argument('--save', action='store_true')

    def get_resolution(self, width=None, height=None):
        if width is None and height is None:
            width = self.defaults.width
            height = self.defaults.height

        ratio = fractions.Fraction(self.dw, self.dh)
        if width is not None:
            computed_height = width/ratio
            if (height is not None and
                height != computed_height):
                raise RuntimeError("inconsistent resolution")
            return (width, int(computed_height))
        if height is not None:
            return (int(height*ratio), height)
        raise RuntimeError("need width or height")

    def run(self, width, height, save, args, **kwargs):
        rw = 72 * width // self.dw
        return super().run(
            '-r%d' % rw,
            '-dDEVICEWIDTHPOINTS=%d' % self.dw,
            '-dDEVICEHEIGHTPOINTS=%d' % self.dh,
            *args,
            **kwargs)

    def main(self):
        args = self.parser.parse_args()
        gs_args = []
        try:
            args.width, args.height = \
                self.get_resolution(args.width, args.height)
            if args.save:
                (libdir.parent.parent / 'out').mkdir(exist_ok=True)
                gs_args.extend([
                    '-sDEVICE=png16m',
                    '-dGraphicsAlphaBits=4',
                    '-sOutputFile=../out/output.png',
                    '-dNOPAUSE',
                ])

        except RuntimeError as e:
            self.parser.error(e)
        self.run(args=gs_args, **vars(args))
