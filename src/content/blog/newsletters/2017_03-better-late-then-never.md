---
date: 2017-02-22
description: |
  Better late than never (me), but never late is better (my wife).
title: "#03 - Better Late Than Never"
---

Another two weeks have passed and it is time for our summary.

A new section **Questions** was added to the newsletter. The intention
for this new section is that it is going to expose some of the questions
that happen in the past. We hope that none of the questions will be left
unanswered.

Sometimes we forget just how awesome Nix / NixOS is and we take its
capabilities for granted. It is important that we remind ourself from
time to time why are we using it, via reddit - [In
Love](https://www.reddit.com/r/NixOS/comments/5uc9ms/in_love/):

> Just thought I\'d share a compliment, switched from Arch, this thing
> is beautiful. Installing low level packages, configuration files, it
> all works so well.
>
> Only issues are documentation (which I can see is being worked on and
> solved, albeit with limited manpower), and that some packages don\'t
> seem to work well with the package manager, but that\'s fixable over
> time.
>
> But it\'s great for what it is, easy to get running, but still fully
> customization.

# News

- Important date: **27. Feb 2017** a branch-off for next NixOS
  release, 17.03 (Gorilla), [is going to
  happen](https://www.mail-archive.com/nix-dev@lists.science.uu.nl/msg31817.html)

  This means you have few more days to land your change to
  [nixpkgs](https://github.com/NixOS/nixpkgs) master if you want them
  to be a part of Gorilla.

  You can also follow the
  [17.03](https://github.com/NixOS/nixpkgs/milestone/10) milestone.

- Assistance Required for Vulnerability Roundups

  Since last newsletter 2 Vulnerability Roundup happen:
  [21](https://github.com/NixOS/nixpkgs/issues/22549),
  [22](https://github.com/NixOS/nixpkgs/issues/22826).

  [Graham Christensen](https://github.com/grahamc) is doing an amazing
  work coordinating the effort of a security team and also doing a big
  chunk of the work. Recently [he asked for
  help](https://www.mail-archive.com/nix-dev@lists.science.uu.nl/msg31432.html)
  and let us make sure he gets some helping hand, or two, three, \...

  We can all recognize that The work the security team is doing is of
  a great importance, since that makes it possible for the rest
  community to use NixOS in more production environments.

- At FOSDEM a very [spontaneous NixOS discussion panel
  happen]{.title-ref}. As a follow-up
  [\@zimbatm](https://twitter.com/zimbatm) created an [initial
  proposal for
  RFC](https://www.mail-archive.com/nix-dev@lists.science.uu.nl/msg31769.html).

  Having a more formal proposal how we work together and how bigger
  changes are discussed is a step towards mature Linux distribution.
  Having NixOS already reached this state is an impressive
  achievement.

- [xorg-server major
  update](https://www.mail-archive.com/nix-dev@lists.science.uu.nl/msg31762.html)

- [KDE4 removed in
  master](https://www.mail-archive.com/nix-dev@lists.science.uu.nl/msg31701.html)

- [Haskell: master has switched to LTS 8.x with GHC
  8.0.2](https://www.mail-archive.com/nix-dev@lists.science.uu.nl/msg31818.html)

- [Python 3 as default
  (discussion)](https://www.mail-archive.com/nix-dev@lists.science.uu.nl/msg31806.html).

- [Nixpkgs: Adding setcap-wrapper
  functionality](https://github.com/NixOS/nixpkgs/pull/16654)

- [Nix: Add support for s3://
  URIs](https://github.com/NixOS/nix/commit/9ff9c3f2f80ba4108e9c945bbfda2c64735f987b)

- Feedback requested: [Feedback on workshop
  material](https://www.mail-archive.com/nix-dev@lists.science.uu.nl/msg32011.html)

- Feedback requested: [Better firewalling in
  NixOS](https://github.com/NixOS/nixpkgs/pull/12940)

- Feedback requested: [\"Monitoring\"
  NixOS?](https://www.mail-archive.com/nix-dev@lists.science.uu.nl/msg31836.html)

- Release:
  [vagrant-nixos-plugin](https://rubygems.org/gems/vagrant-nixos-plugin/versions/0.2.1)
  released v0.2.1, now with \--show-trace support.

  Add basic nix configuration provisioning for NixOS guests in
  Vagrant.

- Release:
  [docker-nix-builder](https://github.com/numtide/docker-nix-builder)
  beta.

  Did you ever have to battle with a user that only wants to have
  Docker installed on his system? Or a user that is developing on
  macOS and has broken nix packages?

  `docker-nix-builder` is a tool to help smooth the transition.
  Instead of using nix to build the project, use Docker to run nix to
  build the project. At the end the users gets a new Docker container
  that only (mostly) contains the build result.

- Release: Bundle Nix derivations to run anywhere,
  [nix-bundle](https://github.com/matthewbauer/nix-bundle)

  `nix-bundle` is a way to package Nix attributes into single-file
  executables. Benefits: Single-file output, Can be run by non-root
  users, No runtime, Distro agnostic, Completely portable, No
  installation

# Reading

- [A truly reproducible scientific
  paper?](https://medium.com/@bmpvieira/a-truly-reproducible-scientific-paper-5059b282ee9a#.hutdj7dte)
  by [Bruno Vieira](https://twitter.com/bmpvieira).
- [NixOS Linux vs CoreOS Container
  Linux](https://www.vandorp.biz/2017/02/nixos-linux-vs-coreos-container-linux/)
  by [Daniel van Dorp](https://twitter.com/djvdorp).

# Presentations

- Last month\'s talk on [Nix and NixOS from the Louisville Haskell
  Meetup](https://youtu.be/D5Gq2wkRXpU).
- [Deploying NPM packages with the Nix package
  manager](https://video.fosdem.org/2017/K.4.601/deploying_npm_packages_with_nix.mp4)
  by [Sander van der Burg](https://twitter.com/svdburg).
- [NixOS - Les infrastructures immuables et la configuration
  déclarative](https://www.youtube.com/watch?v=YWSeJQKWw9g) by David
  Sferruzza

# Meetups

- **Feb 24--26, 2017**,
  [HackIllinois](https://medium.com/@HackIllinois/open-source-2017-b322ad688471#.vim3uki6h),
  University of Illinois, USA

  For any university students in the US, the University of Illinois at
  Urbana-Champaign is holding a hackathon oriented towards getting
  people into open source development, and I\'m going to be mentoring
  people for Nix/NixOS/Haskell development. Be sure to put \"NixOS\"
  or \"Haskell\" into your application somewhere.

- **Feb 25, 2017**, [Amsterdam Nix
  Meetup](https://www.meetup.com/Amsterdam-Nix-Meetup/events/232753333/)
  at [Container
  Solutions](https://maps.google.com/maps?f=q&hl=en&q=de+Ruyterkade+142-143%2C+Amsterdam%2C+nl),
  Amsterdam, Netherlands

- **Mar 22, 2017**, [Munich NixOS
  Meetup](https://www.meetup.com/Munich-NixOS-Meetup/events/237831744/?eventId=237831744)
  at [OpenLab
  Augsburg](https://maps.google.com/maps?f=q&hl=en&q=48.357765,10.886834),
  Augsburg, Germany

  John Darrington will give a talk about guix and guixSD, a package
  manager and a Linux distribution which are based on similar concepts
  as nix/NixOS.

  The talk will be in English.

## Meetups that just happened

- **Feb 18, 2017**, [Berlin NixOS
  Meetup](https://www.meetup.com/Berlin-NixOS-Meetup/events/237045577/)
  at [Schnee von
  morgen](https://maps.google.com/maps?f=q&hl=en&q=Kiefholzstrasse+1%2C+12435+Berlin%2C+Berlin%2C+de),
  Berlin, Germany
- **Feb 09, 2017**, [NixOS: Functional Packaging For The
  Win](https://www.meetup.com/SeeIT-IT-Meetup-in-Konstanz-Kreuzlingen/events/236693855)
  by [Tobias Pflug](http://twitter.com/tpflug) at [Wasserturm
  Stromeyersdorf](https://maps.google.com/maps?f=q&hl=en&q=Turmstra%C3%9Fe+30%2C+78467+Konstanz%2C+%2C+Konstanz%2C+de),
  Konstanz, Germany

# Questions

- [Problem: fail to build ghc in
  nix](https://www.reddit.com/r/NixOS/comments/5ubtc4/fail_to_build_ghc_in_nix_missing_dependencies/)
- [Best way to handle .desktop files in user installed
  packages](https://www.reddit.com/r/NixOS/comments/5un4bi/best_way_to_handle_desktop_files_in_user/)
- [Awesomewm and
  NixOS](https://www.reddit.com/r/NixOS/comments/5ssgek/awesomewm/)
- [Help - Global Cursor Config
  XMonad](https://www.mail-archive.com/nix-dev@lists.science.uu.nl/msg31518.html)
- [Help with patch for screen
  locking](https://www.mail-archive.com/nix-dev@lists.science.uu.nl/msg31433.html)
- [How to nix-build again a built store
  path?](http://stackoverflow.com/questions/41486747/how-to-nix-build-again-a-built-store-path)
- [NixOS, Haskell, opengl : problems with building and running openGL
  programs](http://stackoverflow.com/questions/41527061/nixos-haskell-opengl-problems-with-building-and-running-opengl-programs)
- [lib.mapAttrsToList and infinite
  recursion](http://stackoverflow.com/questions/42150082/lib-mapattrstolist-and-infinite-recursion)
- [How to use
  buildMaven](https://www.mail-archive.com/nix-dev@lists.science.uu.nl/msg31613.html)

# Jobs

> [Looking for some Nix developers? Let us help
> you.](https://github.com/NixOS/nixos-weekly/issues/new)

- [Smarkets](https://smarkets.com/about), London, United Kingdom

  We are looking for [Infra team
  lead](https://boards.greenhouse.io/smarkets/jobs/486940) and [Infra
  engineer](https://boards.greenhouse.io/smarkets/jobs/486940).

  The jobs are not a Nix jobs per se since we are not using Nix at the
  moment. However, internally few of us are interested in trying it
  for e.g. building AMIs or provisioning docker containers with
  (mostly) python software. We think some strong candidate with
  experience of using Nix in production would have a good chance of
  seeing some adoption here.

# Editor\'s corner

As you also probably noticed, this newsletter is coming out 2 days late.
I am trying to get it out in time, but life happens also. If you would
like to help release weekly newsletter please [contact
me](https://twitter.com/garbas).
