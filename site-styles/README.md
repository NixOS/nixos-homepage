NixOS website styles
====================

*Developer-centric notes*

Units
-----

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

Colours
-------

The `@bs_*` colours should not be used outside of the bootstrap-compatibility
layer. Prefer using the names named in `colors.less`, starting with `@color_`.

Always use a named colour. Using functions (e.g.: `lighten` or `darken`) is not
recommended, as it may create unchecked variants in the palette.
