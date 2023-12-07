---
title: "#03 - NixOS Weekly"
date: 2020-03-18
description: Problems are not stop signs, they are guidelines - Robert H. Schuller
---

# News

- [Introducing nixbuild.net](https://blog.nixbuild.net/posts/2020-02-18-introducing-nixbuild-net.html)

  [nixbuild.net](https://nixbuild.net) is nix build as a service, allowing you
  to easily run distributed builds without having to setup, scale and maintain
  build servers.

- [Proposal for improving Nix error messages
  ](https://blog.cachix.org/post/2020-03-18-proposal-for-improving-nix-error-messages/)

  Crowdfunding campaign to fund a complete rework of error messages in Nix to improve
  beginner's experience and make working with the tooling pleasant.

- [Contextflow is hiring!](https://docs.google.com/document/d/1IwIRFV4ZzkMr4N2K06aHAjaGq3vcLfQBWZpvasDVG24/edit)

  contextflow is an award winning Vienna-based startup using AI on 3D medical images to improve radiology workflows. We are looking for a fulltime Senior DevOps and Backend Engineer (m/f) with NixOs experience.

- [nix-freeze-tree](http://jackkelly.name/blog/archives/2020/01/25/nix-freeze-tree/index.html)

  `nix-freeze-tree` is a utility that walks a directory tree, and writes out Nix expressions which
  rebuild that tree. The generated expressions have two important properties:
  a) Each file in the tree is built by a separate fixed-output derivation, and
  b) Directories are built by derivations that symlink their contents recursively.
  If you are using `nix copy` to ship a derivation between nix stores, copying the derivation built
  by evaluating the output of `nix-freeze-tree` can reuse existing files in the destination store, as
  fixed-output derivations can be checked against a hash before copying.

- [I was wrong about Nix
  ](https://christine.website/blog/i-was-wrong-about-nix-2020-02-10)

  Christine talks about packaging Go and Elm application with Nix
  and publishing binaries to Cachix.

- [How I start: Nix](https://christine.website/blog/how-i-start-nix-2020-03-08)

  Christine talks about packaging and developing Rust with Nix.

- Nixpkgs reached 200,000 commits milestone

  It took less than 3 years since [previous 100,000 milestone](
  https://www.reddit.com/r/NixOS/comments/5rsqde/nixpkgs_just_hit_the_100000_commits_mark/)

- [Nix for Coq Development](https://yannherklotz.com/blog/2020-02-15-nix-for-coq-development.html)

  Yann talks about how to package Coq with Nix using a
  simple tutorial.

- [Possible nixpkgs-based Google Summer of Code projects
  ](http://big-data-biology.org/positions/gsoc-tweag/).

  We want to try to use nix(pkgs) to build perfectly reproducible environments in a context
  where the users wouldn’t even be aware that nix is a thing that exists (unless, obviously,
  they want to know). This is in the context of a bioinformatics application, written in Haskell,
  but the nixpkgs integration can be done without writing Haskell code ([NGLess](https://ngless.embl.de/))

- [Nix: override packages with overlays
  ](https://thomashartmann.dev/blog/nix-override-packages-with-overlays/)

  Thomas has written a tutorial covering the problem that overlays
  are trying to solve, as well as how to use them.

- [Announcing TUNA Nix mirror for China users
  ](https://discourse.nixos.org/t/announcing-tuna-nix-mirror/6144)

- [Oslo NixOS minicon rapport
  ](https://blog.hackeriet.no/oslo-nixos-minicon-rapport/)

- [How NixOS Is Enabling Edge and IoT Projects
  ](https://www.worksonarm.com/blog/how-nixos-is-enabling-edge-and-iot-projects/)

- [Interactive tutorials for using Nix and Nixpkgs written as a Jupyter notebook
  ](https://github.com/FRidh/nix-tutorials)

  made by [@FRidh](https://github.com/FRidh)

- [A declarative process manager-agnostic deployment framework based on Nix tooling
  ](https://sandervanderburg.blogspot.com/2020/02/a-declarative-process-manager-agnostic.html)

# Contribute to NixOS Weekly Newsletter

This work would not be possible without the many contributions of the community.

You can help too! Create or comment on the [pull request](https://github.com/NixOS/nixos-weekly/pulls)
for the next edition or look at the
[issue tracker](https://github.com/NixOS/nixos-weekly/issues) to add other improvements.

