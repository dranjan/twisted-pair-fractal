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

# Reflections

This section is for people who are PostScript-curious and considering using it
for their own fractal art projects. My short recommendation is that if
you're on the fence, go ahead and use it, assuming your idea fits nicely
in the vector graphics paradigm. However, if it doesn't (e.g., if you
need to have more control over the color of individual pixels), then
PostScript may not offer any particular advantages over other more
conventional languages.

[XXX rewrite this]
You might be wondering why I chose PostScript for this work. It's a valid
question without a very satisfying answer. To be clear I don't think it's a *wrong*
choice, but I wouldn't say it's necessarily the *best* choice, even for the
algorithm I chose to implement. Ultimately it just comes down to historical accident
because I followed an incremental path from some other work I had already done in
PostScript.

That being said, if you want to use PostScript
for your own fractals, I definitely don't want to dissuade you. It's well suited to
a pretty wide range of fractals, and it can be be very fun and rewarding to work
with. However, there are a few things you might want to be aware of.

- PostScript isn't quite a general-purpose language and thus lacks many
  of the niceties that may be familiar from other programming environments. For example,
  while PostScript has strings (indeed, rendering text being one of the main things
  it's used for in the real world), its support of manipulating strings is very
  lacking. Also, the debugging experience is also quite poor. Those things
  could actually be addressed pretty comprehensively in third-party libraries,
  but PostScript's lack of a good module system is again an annoyance there.
- As another important example of the previous point, PostScript doesn't
  have any concept of user-defined types. (It's less clear to me how this would
  be addressed properly even in a hypothetical third-party library.)
- PostScript only offers single-precision floating point precision.
  While internal computations may use double precision, sometimes that just isn't
  good enough. Generally speaking, this limitation can be worked around by choosing
  algorithms wisely, but that can be easier said than done. For example, for this
  project, certain choices that I made very early ended up being very consequential
  much later at a point where a full rewrite was impractical.
- Performance isn't great compared to compiled languages.
