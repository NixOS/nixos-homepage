---
id: service-deployment-paper-accepted-for-scm-12-2005
title: Service deployment paper accepted for SCM-12 
date: 2005-08-22T00:00:00.000Z
category: announcements
---
The paper “Service Configuration Management” (accepted at the [12th International Workshop on Software Configuration Management](https://web.archive.org/web/20200422192338/https://users.soe.ucsc.edu/~ejw/scm12/)) describes how we can rather easily deploy “services” (e.g., complete webserver configurations such as our [Subversion server](http://svn.nixos.org/)) through Nix by treating the non-component parts (such as configuration files, control scripts and static data) as components that are built by Nix expressions. The result is that all advantages that Nix offers to software deployment also extend to service deployment, such as the ability to easily have multiple configuration side by side, to roll back configurations, and to identify the precise dependencies of a configuration.
