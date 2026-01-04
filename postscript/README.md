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

PostScript is a pretty neat language and a good fit for many types of
fractal visualizations, due to its simple, elegant, and expressive syntax and its
convenient and intuitive 2D vector graphics
capabilities. However, it is at its heart a _page description language_ and
not quite a general-purpose programming language, so some things you may be
used to in more conventional programming languages are lacking or completely missing:

- string manipulation (although strings themselves are there),
- user-defined types,
- any sane debugging facilities,
- any reasonable module system,
- double-precision floating point,

_et cetera_. That said, those things don't need to be deal breakers for many
fractal art projects. For this project, the only one of those
shortcomings
that ended up being a real hindrance was the lack of double-precision floating point,
and to be fair, that could have been largely mitigated by choosing a better data
representation. But I made that choice at the beginning of the project,
and I had to do it without being able to define my own type, so I na&iuml;vely did it
with poor encapsulation, and thus when it became clear that there was a problem,
making the change I really wanted was just too hard and I had to find another way.
The poor debuggability also made it much harder to find such problems in
the first place. Thus, maybe you can see how these shortcomings of the underlying
programming language can compound on each other to create real problems.
All that being said, there are always ways to get around the problems, and ultimately
it can be really fun and rewarding to code 2D graphics in PostScript, particularly
fractals in my opinion.

The other part of this I want to emphasize is that PostScript is for *vector graphics.*
That means it's well suited when you can break down your graphics problem into
simple primitive shapes like line segments, circles, polygons, etc.
That covers a pretty wide variety of fractals.
However, it's not well suited to doing
computations at "pixel-level," because the concept of a pixel doesn't fit naturally
in the vector graphics paradigm.
As soon as the
definition of a pixel becomes important, PostScript's own graphics capabilities
become a lot less useful.

Here are some examples of fractals that thus generally aren't a good
fit for PostScript.

1. Most fractals arising from complex dynamics, like the Mandelbrot set and related
   constructions. For those you typically iterate over all the pixels in the image
   and do some computation on the coordinates of each pixel.
2. More generally, any fractal you define on a point-by-point basis by computing the
   color value as a function of a point's coordinates.
3. My own ["Super Apollonian"](https://github.com/dranjan/super-apollonian-cpp) fractal.
   This one's more subtle because you'd normally think it would be perfectly suited
   to vector graphics,
   being defined as basically a collection of filled circles,
   but to get a good result it turns out it's very helpful to know exactly how much of
   each circle falls within each pixel. Actually, the first version of that fractal
   was written in PostScript, and I rewrote it in C++ for exactly that reason.
4. More generally, any fractal rendering algorithm that needs to know what a pixel is.
   The alternate algorithm mentioned near the end of the top-level README would be
   another good example of that, and thus if I decided to pursue that, I most likely
   wouldn't do it PostScript.

In such cases, PostScript's built-in graphics facilities might not be much help
at all.
You can certainly make it work, but it
probably doesn't have any particular advantages over more conventional languages...unless
you just really like the syntax, and I wouldn't blame you for that.
