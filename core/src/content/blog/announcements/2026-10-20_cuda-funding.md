---
id: cuda-funding-2026
title: NixOS CUDA team receives commercial funding
date: 2026-10-20T12:00:00.000Z
category: announcements
authors:
  - name: Steve Swoyer
    discourse: reyows.evets
---

We're excited to announce that the [effort](https://nixos.org/community/teams/cuda/) for building, maintaining, and continuously improving CUDA in the NixOS ecosystem is the recipient of a significant funding pledge from [PDT Partners](https://pdtpartners.com/), [Jane Street Capital](https://www.janestreet.com/), and [Anthropic](https://anthropic.com).

For a long time, the NixOS CUDA team has done its thing without any source of funding.
In spite of this, they've managed to keep up with the objectively rapid evolution of the CUDA ecosystem and the explosion of CUDA-enabled packages.

PDT Partners, Jane Street, and Anthropic all rely on Nixpkgs and NixOS CUDA as an upstream source for the package definitions, patches, and integration work backing their own CUDA software stacks.

Working with the NixOS Foundation, these companies pledged to commit €300,000 to improve the state of CUDA in the NixOS ecosystem.
**This is the first time a Nixpkgs or NixOS team has received targeted funding from commercial sponsors**.
There are very good reasons to hope it won't be the last.

This builds on work dating to just over a year ago.
At that time, [Flox](https://flox.dev) partnered with [NVIDIA](https://nvidia.com), the NixOS CUDA team, and the NixOS Foundation to secure approval to redistribute CUDA on Nix, with Flox building, caching, and serving CUDA packages to the Nix community [via its public binary cache](https://wiki.nixos.org/wiki/CUDA#Flox_binary_cache).

## What makes this different

Outside funding isn't unprecedented in the Nix ecosystem.
[The Sovereign Tech Fund/Agency](https://www.sovereign.tech/tech/nix) invested €226,000 in a NixOS ecosystem supply-chain security project, and Amazon's ongoing sponsorship of the Nix public binary cache amounts to more than $100,000 annually.
Similarly, [Summer of Nix](https://github.com/ngi-nix/summer-of-nix), an annual coding mentorship program, is sponsored by the European Commission via [NLnet](https://nlnet.nl/).
The NixOS Foundation, via [Open Collective](https://opencollective.com/nixos/projects), channels funding to projects across the NixOS ecosystem, including the NixOS documentation team and the team supporting `cache.nixos.org`.

But a six-figure pledge backed by multiple commercial entities to fund the work of a _specific_ NixOS ecosystem team?
_That_ is unprecedented.
Also notable is the NixOS Foundation's role in coordinating and administering that earmarked commercial funding, which offers a model that other NixOS ecosystem teams and the companies that depend on their work can follow.

"It should now be easier for other teams to receive funding for their work through the [NixOS] Foundation," says NixOS CUDA team member Yuriy Taraday.
"I personally hope this will benefit the community at large."

## The cost of keeping up with CUDA

The work of the NixOS CUDA team has been nothing less than incredible.
In four years, NixOS CUDA has grown to encompass hundreds of packages, many of them critical.
In addition to maintaining core NVIDIA CUDA binaries and libraries, the team has kept massive CUDA-enabled projects like PyTorch, vLLM, and others working with CUDA in Nixpkgs and NixOS.

To cite just one example, the NixOS CUDA team has mostly kept pace with the aggressive release schedule of [the upstream PyTorch project](https://github.com/pytorch/pytorch)… in spite of the fact that building and testing CUDA-enabled PyTorch requires massive CPU, memory, and disk resources.
These have neither been easy to come by—nor to keep.

The challenges involved in maintaining CUDA go beyond package definitions and build systems.
They cross over into licensing, distribution, and (not least) _sociotechnics_: the logistics of coordinating among Nixpkgs and NixOS teams, the NixOS Foundation, NVIDIA, and community-run infrastructure.

"We have strong interaction and coordination with the compiler teams and other [teams] … because our work interacts heavily with these parts," explains NixOS CUDA maintainer Gaetan Lepage.
"We are working very closely with people who have nothing to do with NixOS CUDA … [because] there are lots of packages that might have a CUDA backend or a CUDA option that are consuming the [NixOS] CUDA libraries.
The diversity of packages that are within our scope is quite large: it spans across several languages (C, C++, Python, Rust, etc.) and numerous domains (high-performance computing, robotics, deep learning frameworks, inference engines, etc.)."

Unlike most Nix ecosystem maintainers, the CUDA team can't rely on the NixOS project's automated build and test infrastructure to surface failures, either.
That's because the standard Nixpkgs builds of packages like PyTorch, ONNX Runtime, and vLLM are produced with CUDA support disabled, mostly out of respect for NVIDIA's historically restrictive licensing terms.
As a result, regressions specific to CUDA aren't naturally surfaced by the NixOS project's normal CI or binary-cache infrastructure.

Most frustrating of all is the team's never-ending need for hardware to build and test CUDA packages across the gamut of NVIDIA GPUs: consumer-grade GPUs like the RTX 5090, desktop systems like DGX Spark, embedded platforms like Jetson systems, or rack-scale platforms like NVIDIA's GB300 NVL72 use different streaming multiprocessor (SM) architectures.
A build that works on one NVIDIA SM architecture, like SM120 (RTX-50xx series), may fail on an adjacent architecture… like SM121 (DGX Spark).
Because the team can't test for all NVIDIA SM combinations and product lines, they can only guarantee compatibility against hardware they actually have access to.
This means product lines like NVIDIA Jetson, NVIDIA DRIVE, and others can't be assumed to be compatible.

For most of the team's history, in fact, members have used their own personal hardware to supplement donated capacity and (more recently) rented servers.
But the problem isn't simply access to NVIDIA GPUs: building and testing large CUDA-enabled packages such as PyTorch, ONNX Runtime, and vLLM consumes enormous amounts of CPU, memory, storage, and _time_ even before real-world testing on a GPU can even commence.

"Building PyTorch with CPU support takes eight minutes; building PyTorch with CUDA support takes two hours.
Our team is really hardware-bound at this stage, both in terms of access to hardware in general and, especially, CUDA hardware diversity," says NixOS CUDA maintainer Gaetan Lepage.
"We are still heavily relying on personal systems and personal investments that some of us are able and willing to do on behalf [of Nix CUDA]."

## What the funding changes

The new funding could translate into better hardware coverage and more dependable access to compute, plus the possibility of tackling work that involves more than just keeping the lights on.
It opens the door to must-haves like automated CI across heterogeneous hardware; possible refactorings of packages such as PyTorch and JAX; the ability to onboard new contributors who don't bring NVIDIA kit with them, and so on.

It also seems like long-overdue validation.
Because despite operating on the shoestringiest of budgets, the NixOS CUDA maintainers have consistently delivered software that meets the highest professional standards.
The new funding is an opportunity to start supporting that work at a level commensurate with the quality the NixOS CUDA team has maintained to date.

NixOS CUDA team member Taraday looks to the future.
"In companies … [that] use Nix a lot, there is usually a very small team that does platform engineering that 'sold' Nix internally.
This team has to somehow demonstrate to the money people that CUDA support in Nixpkgs is worthy of investing in," he observes.
"And we need to help them [internal Nix champions] convince the people responsible for whatever marketing budget [their companies] have to recognize what we do."

He deftly articulates the mix of feelings experienced by his team: a sense of relief and optimism, yes, but also the feeling that there's _so_ much more still to be done: "There's so much we have to do that it is sometimes very hard to strike a balance when what we're dealing with is: 'We need more money, we need more hardware, we need more _everything_,'" he says.

But the NixOS CUDA team is optimistic this is just the beginning.
More companies that materially depend on NixOS CUDA are now taking steps to support it: NVIDIA, Anthropic, Jane Street, and PDT Partners are, each in their own way, backing the NixOS Foundation.
The Foundation itself gives commercial entities a formal institutional counterpart they can work with to direct financial or in-kind support toward work done by community-run NixOS and Nixpkgs teams.
Basically, Taraday and Lepage say, there's a whole lot here to be hopeful about.
