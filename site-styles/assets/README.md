Notes about assets
==================

The `.src.svg` files are *Inkscape* source files.

From these files, you *Save as...* **Plain SVG** files.

In practice I don't know if it makes a difference considering this is
going through `svgo` to optimize the files anyway.

LESS CSS inclusion
------------------

Read `svg.less` to see how it works.

The basic idea is that the build process will replace placeholder text
elements with the actual SVG file content. This file content is
massaged lightly via LESS functions.

From then on, you have a LESS *Mixin* that you can use to refer to the
SVG asset.
