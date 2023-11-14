---
title: Nix Manual
url:
---

Nix is a package manager which comes in a form of many command line tools. Packages that Nix can build are defined with the Nix Expression Language.

- [Installation](/manual/nix/stable/installation/installing-binary)
- [Basic package management](/manual/nix/stable/package-management/basic-package-mgmt)
- [What is a channel?](/manual/nix/stable/package-management/channels.html)
- Main command line tools:
  - [nix-env](/manual/nix/stable/command-ref/nix-env) — manipulate or query Nix user environments
  - [nix-build](/manual/nix/stable/command-ref/nix-build) — build a Nix expression
  - [nix-shell](/manual/nix/stable/command-ref/nix-shell) — start an interactive shell based on a Nix expression
  - [nix-store](/manual/nix/stable/command-ref/nix-store) — manipulate or query the Nix store
- [Nix expression language](/manual/nix/stable/expressions/expression-language.html)
  - [Built-in functions](/manual/nix/stable/expressions/builtins.html)
  - [Nixpkgs Library Functions](/manual/nixpkgs/stable/#sec-functions-library)
  - [Debugging Nix Expressions](/manual/nixpkgs/stable/#sec-debug)
