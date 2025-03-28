---
title: '#03 - Kubenix, kernel regressions and jobs'
date: 2019-02-20
description: From what we get, we can make a living; what we give, however, makes a life.
---

# News

- [NixOS is bootable via netboot.xyz](https://github.com/antonym/netboot.xyz/issues/37)

  Try out NixOS, without having to even create a USB key.

- [Easy dependency management for Nix projects](https://github.com/nmattia/niv)

  Easily pin, update, and maintain remote dependencies for each of your Nix projects.

- The Pantheon desktop environment has been added to NixOS (on master)

  It can be enabled with `services.xserver.desktopManager.pantheon.enable`.

- [The case of the supersized shebang](https://lwn.net/SubscriberLink/779997/11de2bdc8dbc0d69/)

  Regression in the linux kernel all together with backporting the issue into all stable kernels.

- [Diving into NixOS](https://rycwo.xyz/2018/07/29/nixos-series-dual-boot)

  Setting up NixOS and Windows 10 on the Dell XPS 13 9370.

- [Deploying k8s apps with kubenix](https://zimbatm.com/deploying-k8s-apps-with-kubenix/)

  Zimbatm describes configuring Kubernetes using typed Nix wrappers to generate the Kubernetes YAML files.
  KubeNix automatically follows the API specification and validates your configuration entirely locally.

- [The status.im project starts moving to Nix](https://discuss.status.im/t/the-road-to-nix-a-functional-package-manager-to-rule-them-all/1049)

  Status.im plans to migrate to Nix to manage its various packages and environments.
  Status.im looks to Nix for most of its usual advantages. Some of the provided examples
  are ensuring consistent development tools, and development/CI parity.
  They are also interested in Nixpkg's Linux and and macOS compatibility.

# Jobs

- [Nix SRE position in Helsinki, Finland](https://relex.recruiterbox.com/jobs/fk0jx41/)

- [IOHK is hiring devops engineers in US/Europe](https://iohk.io/careers/#op-291346-devops-engineer--nix-nixos-nixops-hydra)

# Contribute to NixOS Weekly Newsletter

This work would not be possible without the many contributions of the community.

You can help too! Create or comment on the [pull request](https://github.com/NixOS/nixos-weekly/pulls)
for the next edition or look at the
[issue tracker](https://github.com/NixOS/nixos-weekly/issues) to add other improvements.
