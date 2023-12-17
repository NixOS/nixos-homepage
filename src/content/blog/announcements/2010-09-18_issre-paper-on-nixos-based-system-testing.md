---
id: issre-paper-on-nixos-based-system-testing
title: ISSRE paper on NixOS-based system testing 
date: 2010-09-18T00:00:01.000Z
category: announcements
---
The paper [“Automating System Tests Using Declarative Virtual Machines”](https://edolstra.github.io/pubs/decvms-issre2010-final.pdf) (by Sander van der Burg and Eelco Dolstra) has been accepted for presentation at the [21st IEEE International Symposium on Software Reliability Engineering (ISSRE 2010)](https://web.archive.org/web/20110726193652/http://www.issre2010.org/). It describes how system tests with complex requirements on the environment (such as remote machines, network topologies, system services or root privileges) can be written succinctly using [declarative specifications](https://svn.nixos.org/websvn/nix/nixos/trunk/tests/bittorrent.nix) of the machines needed by the test environment. From these specifications we can automatically instantiate (networks of) virtual machines. This is what we use for [automated regression testing of NixOS itself](https://hydra.nixos.org/jobset/nixos/trunk/jobstatus). A [draft of the paper](https://edolstra.github.io/pubs/decvms-issre2010-submitted.pdf) is available.
