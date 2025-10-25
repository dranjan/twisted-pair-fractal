# Twisted Pair Fractal

## Usage

### Dependencies

- GhostScript 9.x or above
- Python 3.x
- ImageMagick

### Running

    run/twisted-pair --height=2160  # The full official image
    run/twisted-pair --width=3840   # Equivalent
    run/twisted-pair --res 10       # Just a quick sanity check
    run/twisted-pair --nx=4 --ny=4  # Use a 16-thread grid instead of the default

After any of the above commands, get the output image from `out/output.png`.

## Developing

### Architecture

The top level is, as you've probably guessed by now, the script
`run/twisted-pair`, which is a Python script. This script handles the
logic for dividing up the whole image into a grid of subimages,
having each subimage's fractal rendered in its own process, and finally
combining the subimages into the output image. To minimize dependencies,
all of the imaging and image processing is done by calling external
commands from Python: GhostScript to do the mathematical rendering, and
ImageMagick to assemble the output image.

The main implementation is under `postscript` and is written in, as you
might also have guessed, the PostScript programming language. More
details are explained in that directory's `README.md`.

### Testing

    run/test           # run the main test suite
    run/test-graphics  # run the graphics-dependent tests

## Theory

Some of the theory is developed and explained in a Sage notebook under `nb`. That
directory's `README` has information on how to interact with the
notebook. That document was co-developed with the fractal itself and was
an integral part my development process, i.e., what you see there are
actual computations I had to do, whose results were incorporated into
the PostScript implementation. The only real exception is the
fundamental root (`rho_x rho_y` in the code), which I had computed using
ad-hoc means much earlier to prove the concept, before I knew how to use
Sage.

## History

I started this work around 2008 but only got as far as computing the
fundamental root and proving the concept of the fractal with a hacky
probabilistic algorithm implemented in PostScript. Unfortunately, there
was no clear route from there to a real implementation, so I got stuck
and set the project aside. In 2024, I finally picked it back up, found
a good way to visualize it, and completed the implementation, which you see
here. Since 2024, I've done some minor cleanup and refactoring.

Part of what made me put the project down for such a long time was that I somehow
convinced myself that I should use an entirely different and more
sophisticated type of rendering algorithm, one that would require a
brand new from-scratch implementation in a different programming
language. That inserted a huge additional step in front of any work
on the fractal itself, plus having no guarantee that the "better"
algorithm would be a good choice for this specific fractal, plus
my not even having a very clear mental picture of the geometry.
When I finally resumed the project, I decided to do it first using a
much more traditional and proven (to me) algorithm based on graph
traversal, which is what you see here. While the implementation is
very technical and inelegant in my opinion, the idea behind it is simple,
direct, and flexible, making it ideal for a first implementation.

(Now that the implementation is complete, I think the other algorithm is
still worth exploring, and I may investigate that in the future. In a
nutshell, the new algorithm computes a tuple of fractal measures on the
Riemann sphere as an eigenvector of a linear operator defined in terms
of the symmetry group of the fractal. The component measures of that
tuple give the contribution of each primary color to each pixel (or
arbitrary measurable set, mathematically speaking). To solve the eigevnalue
problem, we need to discretize the domain, with coarser discretizations
being less accurate but easier to solve. However, the solution at a coarser
discretization should give a good starting guess for a finer discretization,
which should allow us to bootstrap an accurate solution very efficiently
using, say, the power method.)

# License

This software is licensed under the terms of the GNU General Public
License, version 3.  See the file `COPYING` for details.

# Credits

Author: Darsh Ranjan
