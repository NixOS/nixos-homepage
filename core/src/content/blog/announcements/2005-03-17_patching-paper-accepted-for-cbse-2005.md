---
id: patching-paper-accepted-for-cbse-2005
title: Patching paper accepted for CBSE 2005
date: 2005-03-17T00:00:00.000Z
category: announcements
---

The paper “Efficient Upgrading in a Purely Functional Component Deployment Model” has been accepted at [CBSE 2005](https://web.archive.org/web/20090712101213/https://www.sei.cmu.edu/pacc/CBSE2005/). It describes how we can deploy updates to Nix packages efficiently, even if “fundamental” packages like Glibc are updated (which cause a rebuild of all dependent packages), by deploying binary patches between components in the Nix store. Includes techniques such as patch chaining and computing deltas between archive files.
