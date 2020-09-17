NixOS website styles
====================

*Developer-centric notes*

How this is laid out
--------------------

This uses the rscss structure

 * https://rscss.io/

With one addendum that for *qualified* layout elements like `body > header` the
component will not be named (e.g. `page-header`); the qualified name for the
innate structure of the document is enough.


Units
-----

### `@unit`

**Always** use `@unit` relative sizes rather than pixels, if pixels equivalents
are desired. Otherwise, work with `em` for relative sizes according to the
current sizes, or `rem` for root-relative sizes.

Using pixel sizes is completely forbidden.

This ensures the site stays entirely scalable according to the user-agent's
configuration.

> **Tip:** To make a "2 pixels" border:
> 
> ```
> * {
> 	border: 2 * @unit solid red;
> }
> ```

This is not to be confused with the `unit()` function of LESS, which changes or
removes a unit without conversion. The `unit()` function maye be found near
uses of `@unit` to strip a unit to work around automatic unit conversions.

### `@gutter`

The gutter is the other unit that is being used on the site. It is defined as
based on `@unit`, so it respects the rule of always defining sizes based on
`@unit`.

A gutter is, simply put, the spacing between two elements of the design. When
spacing out elements, put 1 `@gutter` between them. It can be done through
dividing the responsibility in halves (`@gutter/2`).

It might be needed to space things a bit more. Using multiples of `@gutter`
makes ad-hoc adjustments harmonize better with the site.


Colours
-------

> TBD

Always use a named colour. Using functions (e.g.: `lighten` or `darken`) is not
recommended, as it may create unchecked variants in the palette.


Pitfalls
--------

### Broken `::before` on element with `id=`

To push anchor links inside a page, all elements with an `id=` property
are given pseudo-element that is used to push the element into the
visible section of the viewport.

What this means is that if the element you are attempting to style
has an `id=` property it is fighting against a generic rule.

If the element does not serve for navigation, neither is it used with
JavaScript, it should not have an ID. To target elements refer to RSCSS.

> Note that even with JavaScript it is preferable to use the RSCSS
> scheme to target elements in a generic fashion, unless you are
> targeting a specifically identified element rather than a generic use
> case.


Bibliography
------------

Useful resources to wrangle specifics.

 * [A Complete Guide to Flexbox](https://css-tricks.com/snippets/css/a-guide-to-flexbox/)
 * https://rscss.io/
