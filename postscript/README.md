This directory contains the PostScript implementation of the Twisted Pair fractal.

Generally speaking, none of these files should be run directly. See the top-level
`README.md` for usage instructions and hints.

# Architecture

The implementation is split into multiple files, a top-level script plus
several libraries. The libraries are included via the standard `run`
operator in the main script. There's no universally agreed upon system
for splitting a PostScript project into multiple files. The simple
method I've chosen here is far from perfect, but it works fine for a
small project like this one.

Here's a quick overview of the different files.

- `twisted-pair.ps`: the top-level script. This contains the
  mathematical definitions as well as the rendering algorithm.
- `roi.ps`: computational geometry for keeping track of an axis-aligned
  bounding box after transformations. This is used heuristically in the
  rendering logic to prune nodes that can be proved to lie entirely outside
  the imaging region.
- `disk.ps`: implementation of generalized disks. This is used in the
  ROI logic.
- `mobius.ps`: implementation of M&ouml;bius transformations.
- `complex.ps`: implementation of complex number arithmetic and some
  common special functions.
- `permute.ps`: implementation of permutation groups on the stack.
  The coloring logic is based on this.
- `stdlib.ps`: a small set of generic utilities I didn't think of a
  better collective name for.

In addition to those files, which constitute the implementation of the fractal,
there is a suite of tests:

- `test.ps`: the main suite of unit tests.
- `test-graphics.ps`: some graphics-dependent tests that I couldn't
  fully automate.

# On PostScript

This section is for people who are PostScript-curious and considering using it
for their own fractal art projects.

PostScript is vector graphics.
Any kind of 2D graphics you want to make that can be broken down into
simple primitives like points, lines, circles, triangles, squares, curves,
or pretty much any shape you could dream of, you can probably accomplish
in PostScript without too much trouble.
That covers a pretty wide variety of fractals.
What *doesn't* fit nicely is doing any computations at the
pixel level, because the concept of a pixel doesn't fit very naturally
in vector graphics.
You can make it work, but PostScript probably won't have
any advantages over other languages then.

Thus, my short recommendation is that if you're on the fence and the
vector graphics paradigm
makes sense for your fractal, go ahead and use it.
However, there are some things you might want to be aware of.

- PostScript isn't quite a general-purpose language and thus lacks many
  of the niceties that may be familiar from other programming environments. For example,
  while PostScript has strings (indeed, rendering text being one of the main things
  it's used for in the real world), its support for manipulating strings is very
  lacking. Also, the debugging experience is quite poor. Those things
  could actually be addressed pretty comprehensively in third-party libraries,
  but PostScript's lack of a good module system is again an annoyance there.
- As another important example of the previous point, PostScript doesn't
  have any concept of user-defined types. (It's less clear to me how this would
  be addressed properly even in a hypothetical third-party library.)
- PostScript only offers single-precision floating point.
  While internal computations may use double precision, sometimes that just isn't
  good enough. Generally speaking, this limitation can be worked around by choosing
  algorithms wisely, but that can be easier said than done. For example, for this
  project, certain early design decisions that seemed inoccuous at the time
  ended up being very consequential
  much later at a point where a full rewrite was impractical.
- Performance isn't great compared to compiled languages.

To be clear, when we're talking about a fractal art project,
those things aren't necessarily dealbreakers.
Using PostScript for such a project can be a fun and rewarding experience,
and thus I (cautiously) recommend it.
That said, I wouldn't recommend it for "serious" work like
running a business or driving your car, since it's really not meant for that.
