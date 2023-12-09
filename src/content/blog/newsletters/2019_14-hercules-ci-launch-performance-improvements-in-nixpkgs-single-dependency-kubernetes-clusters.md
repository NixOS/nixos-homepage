---
title: "#14 - Hercules CI launch, performance improvements in nixpkgs, single dependency kubernetes clusters"
date: 2019-11-13
description: Be the change that you wish to see in the world. - Mahatma Gandhi
---

# News

- [Launching Hercules CI](https://blog.hercules-ci.com/2019/10/22/launching-hercules-ci/)

  Announcing general availability of continuous integration specialized for Nix projects.

- [Hercules CI Agent 0.6.1](https://blog.hercules-ci.com/2019/11/12/hercules-ci-agent-0.6.1-release/)

  Performance improvements, a bugfix to IFD and better onboarding experience.

- [Improved performance in Nixpkgs](https://matthewbauer.us/blog/avoid-subshells.html)

  Improving Nixpkgs setup by avoiding subshells in processing dependencies.

- [Recently rewritten Nix-on-Droid](https://github.com/t184256/nix-on-droid-bootstrap)
  got [accepted into F-Droid repository](https://f-droid.org/en/packages/com.termux.nix)

  Trying out Nix on your aarch64 or i686 Android device is now easier than ever.

- Two big stdenv cleanups: [Enable `__structuredAttrs`](https://github.com/NixOS/nixpkgs/pull/72074) and [treewide: `set -u` everywhere](https://github.com/NixOS/nixpkgs/pull/72347)

  It's time to clean up stdenv!
  By making our code less fragile, we increase the budget for interesting features.
  There should be plenty of failures, but many of them independent so we can easily parallelize the work to fix.
  Please come pitch in!

- [Pinning NixOps builds](https://jappieklooster.nl/pinning-nixops-builds.html)

- [Single dependency Kubernetes clusters for local testing, experimenting and development](https://github.com/saschagrunert/kubernix)

- [RFC steering commitee nominations](https://discourse.nixos.org/t/rfc-steering-committee-rotation-2019-20/4589/2)

# Contribute to NixOS Weekly Newsletter

This work would not be possible without the many contributions of the community.

You can help too! Create or comment on the [pull request](https://github.com/NixOS/nixos-weekly/pulls)
for the next edition or look at the
[issue tracker](https://github.com/NixOS/nixos-weekly/issues) to add other improvements.

