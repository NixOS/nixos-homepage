---
id: nixos-logo-and-branding-update
title: NixOS Logo and Branding Update
date: 2025-05-01T11:00:00.000Z
category: announcements
---

## History

The NixOS logo was originally designed by [Simon Frankau](https://arbitrary.name/) for Haskell as part of the [2009 Haskell logo contest](https://wiki.haskell.org/Haskell_logos/New_logo_ideas).
Simon kindly gave permission for the design to be used by the NixOS project, and it was [made official](https://github.com/NixOS/nixos-homepage/commit/d5af1e3971822b8a3ec19689a17464558baf7244) in November 2009.
In 2015, a new version of the logo with a "hexagon design" was created by [Tim Cuthbertson](https://github.com/timbertson) and [added to the homepage](https://github.com/NixOS/nixos-homepage/pull/55).
In March of 2017, it officially [superseded the previous logo](https://github.com/NixOS/nixos-artwork/pull/18) and was added to the [nixos-artwork](https://github.com/NixOS/nixos-artwork) repository.
Over the years, there have been many updates to the logo and repository, including:

- [Converting the logotype to paths](https://github.com/NixOS/nixos-homepage/pull/129), removing the dependency on users having the designated font installed.
- Adding documentation about
  the [font used to create the logotype](https://github.com/NixOS/nixos-artwork/commit/46c399722e4a5a729474978aee6f939336efd9d3),
  [guide layers](https://github.com/NixOS/nixos-artwork/commit/a24f08b2754cc1ad821a1781ffdc3ac5e9040582),
  and [colors](https://github.com/NixOS/nixos-artwork/commit/5ea155993a4a0f6bb91d52ef2e0b8ffe9194167d)
- Introducing various logo variants, including
  a [vertical variant](https://github.com/NixOS/nixos-artwork/pull/22),
  an [all-white variant](https://github.com/NixOS/nixos-artwork/commit/9ba74f81ffeec7e88bc95b3ddf3509e9a8a97587),
  and a [rainbow variant](https://github.com/NixOS/nixos-artwork/pull/133)

## Motivation to change

An incredible amount of work has gone into creating and improving the logo and its documentation.
However, it suffers from some inconsistencies and many parts of it are still ambiguous.

The image below is a zoomed in view of the bottom of the NixOS logo with a horizontal line drawn starting at the bottom left of the snowflake.
If you open the image and zoom in, you will see that the edges of the snowflake are not parallel to the horizontal line.
Additionally, the edges of the snowflake are not collinear with each other.
<img
  src="/images/blog/announcements/nixos-lambdas-not-collinear.jpg"
  alt="A zoomed in view of the bottom of the NixOS logo showing that the lambdas are not collinear or flat."
  style="display: block; margin: 0 auto; float: none; max-width: 100%; height: auto;"
  decoding="async"
  loading="lazy"
/>

The image below shows the paths that define the gradient for the lambdas.
There are two gradient definitions that are different and ideally they would be the same.

<img 
  src="/images/blog/announcements/nixos-lambda-two-gradient-defs.jpg"
  alt="A view of the NixOS logo source showing two gradient definitions."
  style="display: block; margin: 0 auto; float: none; max-width: 40%; height: auto;"
  decoding="async"
  loading="lazy"
/>

When creating a brand guide, there are usually sections describing the anatomy of the logo, clearspace, sizing, alignment, variations, and misuse.
Some of this information has been captured in the README co-located with the logos but not all of it is well defined.
For example:

- The anatomy of the logo is not well defined which should include information like the relative size of the logomark and logotype and the spacing between them.
- The anatomy of the logomark is not well defined which should include information like the dimensions of the lambdas and the gap between lambdas.
- The anatomy of the logotype is not well defined which should include information like spacing between glyphs.
- The paths used to define the gradients of the lambdas are not well defined and are different.
- The clearspace around the logo and logomark is not well defined.
- The clearspace around the logo and logomark is not sufficient.
- There are no guidelines about sizing and alignment.
- There is no variation of the logotype by itself.
- There are no guidelines about creating new variations.
- There are no guidelines about misuse.

## Work towards improvement

To address these issues, I want to improve how we create logos, create a Branding Guide, and create a Media Kit.
Before I started any design work, I tried to find a tool that would satisfy my 2 requirements:

1. I have to be able to design the logo parametrically.
1. I have to be able to generate SVG files programmatically.

The idea behind the first requirement was that I want to be able to reduce the creation of the logo to a few simple parameters.
Additionally, if I can generate the SVG files programmatically, I can programmatically generate the Branding Guide and Media Kit.
I'm calling this approach **"Branding as Code" (BaC)**

I surveyed many FOSS image editing and CAD tools but none of them could satisfy both my requirements.
In the end, I decided to create my own tooling in Python.
After three months of work the tooling has a lot of capabilities.
It can:

- Generate a lambda based on 3 parameters: radius, thickness, and gap.
- Generate a logomark with different colors and color styles.
- Generate a logotype with different colors and styles.
- Generate a logo (logomark + logotype) in different layouts.
- Generate all three logo products with different clearspace values and meaningfully unique filenames.
- Generate dimensioned and annotated SVG files for use in the Branding Guide.

A few example output products are shown below.

<img 
  src="/images/blog/announcements/nixos-lambda-dimensioned-linear.svg"
  alt="A lambda from the NixOS logomark with linear dimensions shown."
  style="display: block; margin: 0 auto; float: none; max-width: 100%; height: auto;"
  decoding="async"
  loading="lazy"
/>

<img 
  src="/images/blog/announcements/nixos-lambda-gradient-dimensioned.svg"
  alt="The gradient paths of the NixOS logomark with dimensions shown."
  style="display: block; margin: 0 auto; float: none; max-width: 100%; height: auto;"
  decoding="async"
  loading="lazy"
/>

<img 
  src="/images/blog/announcements/nixos-lambda-gradient-background.svg"
  alt="The gradient paths of the NixOS logomark with dimensions shown and the gradient overlaid."
  style="display: block; margin: 0 auto; float: none; max-width: 100%; height: auto;"
  decoding="async"
  loading="lazy"
/>

<img 
  src="/images/blog/announcements/nixos-snowflake-dimensioned-linear.svg"
  alt="The NixOS logomark with linear dimensions shown."
  style="display: block; margin: 0 auto; float: none; max-width: 100%; height: auto;"
  decoding="async"
  loading="lazy"
/>

There is still much more work to be done including: generating many more annotated drawings for the Branding Guide, creating the Branding Guide, and creating the Media Kit.
I would like to thank [Ida Bzo](https://github.com/idabzo), [Sebastian Kraus](https://github.com/Ra33it0), [Ross Turk](https://github.com/rossturk), and [David Nuon](https://github.com/davidnuon) for their feedback and assistance throughout this process.
This is just the beginning of building a more precise, flexible, and scalable visual identity for the NixOS project.
