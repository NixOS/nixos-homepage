---
title: "#12 - NixCon 2018 videos, Eris, NixDoc, Auto patching and jobs"
date: 2018-11-16
description: People Who Are Crazy Enough To Think They Can Change The World, Are The Ones Who Do
---

# News

- [NixCon 2018 videos of talks](https://www.youtube.com/channel/UCjqkNrQ8F3OhKSCfCgagWLg/videos)

- [Eris: A simple binary cache server](https://discourse.nixos.org/t/ann-eris-a-simple-binary-cache-server/1265)

- [News on the security team](https://discourse.nixos.org/t/news-on-the-security-team/1280)

- [Language Server Protocol for Nix using HNix](https://github.com/domenkozar/hnix-lsp)

- [NixOS mailserver 2.2.0](https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/tags/v2.2.0)

# Blogs

- [The NixOps resources.machines option](https://nixos.mayflower.consulting/blog/2018/10/26/nixops-machine-configs/)

- [Auto patching prebuilt binary software](http://sandervanderburg.blogspot.com/2018/10/auto-patching-prebuilt-binary-software.html)

# Jobs

- [Engineer at Mercury](https://mercury.co/jobs/generalist_engineer.md)

  Mercury is hiring a generalist engineer in SF. Mercury uses Nix for development, Hydra for CI, and runs on NixOS on AWS.

# Call for participation

- [Deployment Working Group](https://discourse.nixos.org/t/nix-deployment-working-group/1299)

- [nixdoc](https://github.com/tazjin/nixdoc) to generate documentation for Nix library functions

  [NixOS/nixpkgs#49275](https://github.com/NixOS/nixpkgs/pull/49275) for the first generated
  documentation files and [NixOS/nixpkgs#49383](https://github.com/NixOS/nixpkgs/pull/49383)
  for updated doc strings. Rendered example available [here](https://storage.googleapis.com/files.tazj.in/nixdoc/manual.html#sec-functions-library-debug).

- [Nix docker image built with Nix](https://github.com/garbas/nix-docker-nix)

- [Easy PureScript Nix](https://github.com/justinwoo/easy-purescript-nix)

- [filterSourceGitignore: Automatic filterSource by parsing .gitignore files from within nix](https://github.com/Profpatsch/nixperiments/blob/master/filterSourceGitignore.nix)

  [nix-gitignore](https://github.com/siers/nix-gitignore) tries to convert the fnmatch(3) strings in a .gitignore file to perl regexes valid in nix’s match.
  filterSourceGitignore opts for translation to nix boolean predicates instead and implements a subset of the gitignore logic as nix functions, aborting for unsupported parts.


# Contribute to NixOS Weekly Newsletter

This work would not be possible without the many contributions of the community.

You can help too! Create or comment on the [pull request](https://github.com/NixOS/nixos-weekly/pulls)
for the next edition or look at the
[issue tracker](https://github.com/NixOS/nixos-weekly/issues) to add other improvements.
