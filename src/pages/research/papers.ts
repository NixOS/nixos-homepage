export const papers = [
    {
      title: 'Extending Cloud Build Systems to Eliminate Transitive Trust',
      authors: [
        {
          name: 'Martin Schwaighofer',
          orcidUrl: 'https://orcid.org/0009-0001-1572-0495',
        },
        {
          name: 'Michael Roland',
          orcidUrl: 'https://orcid.org/0000-0003-4675-0539',
        },
        {
          name: 'René Mayrhofer',
          orcidUrl: 'https://orcid.org/0000-0003-1566-4646',
        },
      ],
      year: 2024,
      abstract:
        'Trusting the output of a build process requires trusting the build process itself, and the build process of all inputs to that process, and so on. Cloud build systems, like Nix or Bazel, allow their users to precisely specify the build steps making up the intended software supply chain, build the desired outputs as specified, and on this basis delegate build steps to other builders or fill shared caches with their outputs. Delegating build steps or consuming artifacts from shared caches, however, requires trusting the executing builders, which makes cloud build systems better suited for centrally managed deployments than for use across distributed ecosystems. We propose two key extensions to make cloud build systems better suited for use in distributed ecosystems. Our approach attaches metadata to the existing cryptographically secured data structures and protocols, which already link build inputs and outputs for the purpose of caching. Firstly, we include builder provenance data, recording which builder executed the build, its software stack, and a remote attestation, making this information verifiable. Secondly, we include a record of the outcome of how the builder resolved each dependency. Together, these two measures eliminate transitive trust in software dependencies, by enabling users to perform verification of transitive dependencies independently, and against their own criteria, at time of use. Finally, we explain how our proposed extensions could theoretically be implemented in Nix in the future.',
      doiOrPublisherUrl: 'https://doi.org/10.1145/3689944.3696169',
      publicationInfo: {
        type: 'conference',
        conference:
          'Workshop on Software Supply Chain Offensive Research and Ecosystem Defenses',
        location: 'Salt Lake City, Utah, USA',
        publisher: 'ACM',
      },
    },
    {
      title: 'Source Code Archiving to the Rescue of Reproducible Deployment',
      authors: [
        { name: 'Ludovic Courtès' },
        {
          name: 'Timothy Sample',
          orcidUrl: 'https://orcid.org/0009-0007-1813-4073',
        },
        {
          name: 'Stefano Zacchiroli',
          orcidUrl: 'https://orcid.org/0000-0002-4576-136X',
        },
        {
          name: 'Simon Tournier',
          orcidUrl: 'https://orcid.org/0000-0002-2639-818X',
        },
      ],
      year: 2024,
      abstract:
        'The ability to verify research results and to experiment with methodologies are core tenets of science. As research results are increasingly the outcome of computational processes, software plays a central role. GNU Guix is a software deployment tool that supports reproducible software deployment, making it a foundation for computational research workflows. To achieve reproducibility, we must first ensure the source code of software packages Guix deploys remains available.\n\nWe describe our work connecting Guix with Software Heritage, the universal source code archive, making Guix the first free software distribution and tool backed by a stable archive. Our contribution is twofold: we explain the rationale and present the design and implementation we came up with; second, we report on the archival coverage for package source code with data collected over five years and discuss remaining challenges.',
      doiOrPublisherUrl: 'https://doi.org/10.1145/3641525.3663622',
      publicationInfo: {
        type: 'conference',
        conference:
          "2nd ACM Conference on Reproducibility and Replicability (ACM REP '24)",
        location: 'Rennes, France',
        publisher: 'ACM',
        pages: '36-45',
      },
    },
    {
      title: 'Reproducibility in Software Engineering',
      authors: [
        {
          name: 'Pol Dellaiera',
          orcidUrl: 'https://orcid.org/0009-0008-7972-7160',
        },
      ],
      year: 2024,
      abstract:
        "The concept of reproducibility has long been a cornerstone in scientific research, ensuring that results are robust, repeatable, and can be independently verified. This concept has been extended to computer science, focusing on the ability to recreate identical software artefacts. However, the importance of reproducibility in software engineering is often overlooked, leading to challenges in the validation, security, and reliability of software products.\n\nThis master's thesis aims to investigate the current state of reproducibility in software engineering, exploring both the barriers and potential solutions to making software more reproducible and raising awareness. It identifies key factors that impede reproducibility such as inconsistent environments, lack of standardisation, and incomplete documentation. To tackle these issues, I propose an empirical comparison of tools facilitating software reproducibility.\n\nTo provide a comprehensive assessment of reproducibility in software engineering, this study adopts a methodology that involves a hands-on evaluation of four different methods and tools. Through a systematic evaluation of these tools, this research seeks to determine their effectiveness in establishing and maintaining identical software environments and builds.\n\nThis study contributes to academic knowledge and offers practical insights that could influence future software development protocols and standards.",
      doiOrPublisherUrl: 'https://doi.org/10.5281/zenodo.13894231',
      publicationInfo: {
        type: 'thesis',
        thesisType: "Master's",
        institution: 'University of Mons',
        location: 'Mons, Belgium',
      },
    },
    {
      title: 'Reproducibility of Build Environments through Space and Time',
      authors: [
        {
          name: 'Julien Malka',
          orcidUrl: 'https://orcid.org/0009-0008-9845-6300',
        },
        {
          name: 'Stefano Zacchiroli',
          orcidUrl: 'https://orcid.org/0000-0002-4576-136X',
        },
        {
          name: 'Théo Zimmermann',
          orcidUrl: 'https://orcid.org/0000-0002-3580-8806',
        },
      ],
      year: 2024,
      abstract:
        "Modern software engineering builds up on the composability of software components, that rely on more and more direct and transitive dependencies to build their functionalities. This principle of reusability however makes it harder to reproduce projects' build environments, even though reproducibility of build environments is essential for collaboration, maintenance and component lifetime. In this work, we argue that functional package managers provide the tooling to make build environments reproducible in space and time, and we produce a preliminary evaluation to justify this claim. Using historical data, we show that we are able to reproduce build environments of about 7 million Nix packages, and to rebuild 99.94% of the 14 thousand packages from a 6-year-old Nixpkgs revision.",
      doiOrPublisherUrl: 'https://doi.org/10.1145/3639476.3639767',
      publicationInfo: {
        type: 'conference',
        conference:
          'ACM/IEEE 44th International Conference on Software Engineering: New Ideas and Emerging Results',
        location: 'Lisbon, Portugal',
        publisher: 'ACM',
        pages: '97-101',
      },
    },
    {
      title: 'Secure Nix Expression Updates',
      authors: [{ name: 'Finn Landweber' }],
      year: 2024,
      abstract:
        'Projects and individual users often struggle to keep track of their deployed software and update vulnerable versions quickly. Nix, an increasingly popular package manager, provides a rigorous approach to dependency management and transparency and could be used to improve this situation significantly. However, updates to its build instructions are not cryptographically secured and thus give way to machine-in-the-middle attacks. This thesis demonstrates that instruction updates can be protected from these kinds of attacks with minimal changes to the update mechanism. It takes Git as the basis for distributing versioned and signed Nix code and explores multiple ways in which the origins of downloaded instructions can be verified automatically. The work contributes a structured analysis of Nix instruction update security based in literature. From there, it derives novel interfaces from Nix to two preexisting Git signature verification solutions and presents a new tool tailored to the needs of the Nix ecosystem. Although not all attacks on Nix expression updates can be mitigated by the suggested tools, they can provide a practical security gain for Nix users. The findings may help conceptualize a path towards a higher security standard for Nix deployments.',
      preprintOrArchiveUrl: 'https://landweber.xyz/ba.pdf',
      publicationInfo: {
        type: 'thesis',
        thesisType: "Bachelor's",
        institution: 'Leipzig University of Applied Sciences',
        location: 'Leipzig, Germany',
      },
    },
    {
      title:
        'Increasing Trust in the Open Source Supply Chain with Reproducible Builds and Functional Package Management',
      authors: [
        {
          name: 'Julien Malka',
          orcidUrl: 'https://orcid.org/0009-0008-9845-6300',
        },
      ],
      year: 2024,
      abstract:
        'Functional package managers (FPMs) and reproducible builds (R-B) are technologies and methodologies that are conceptually very different from the traditional software deployment model, and that have promising properties for software supply chain security. This thesis aims to evaluate the impact of FMPs and R-B on the security of the software supply chain and propose improvements to the FPM model to further improve trust in the open source supply chain.',
      doiOrPublisherUrl: '10.1145/3639478.3639806',
      publicationInfo: {
        type: 'conference',
        conference:
          'IEEE/ACM 46th International Conference on Software Engineering: Companion Proceedings',
        location: 'Lisbon, Portugal',
      },
    },
    {
      title:
        'Toward practical transparent verifiable and long-term reproducible research using Guix',
      authors: [
        {
          name: 'Nicolas Vallet',
        },
        {
          name: 'David Michonneau',
          orcidUrl: 'https://orcid.org/0000-0003-4553-3065',
        },
        {
          name: 'Simon Tournier',
          orcidUrl: 'https://orcid.org/0000-0002-2639-818X',
        },
      ],
      year: 2022,
      abstract:
        'Reproducibility crisis urge scientists to promote transparency which allows peers to draw same conclusions after performing identical steps from hypothesis to results. Growing resources are developed to open the access to methods, data and source codes. Still, the computational environment, an interface between data and source code running analyses, is not addressed. Environments are usually described with software and library names associated with version labels or provided as an opaque container image. This is not enough to describe the complexity of the dependencies on which they rely to operate on. We describe this issue and illustrate how open tools like Guix can be used by any scientist to share their environment and allow peers to reproduce it. Some steps of research might not be fully reproducible, but at least, transparency for computation is technically addressable. These tools should be considered by scientists willing to promote transparency and open science.',
      doiOrPublisherUrl: '10.1038/s41597-022-01720-9',
      publicationInfo: {
        type: 'journal',
        journal: 'Scientific Data',
        volume: '9',
        number: '597',
      },
    },
    {
      title: 'Build systems à la carte: Theory and practice',
      authors: [
        {
          name: 'Andrey Mokhov',
          orcidUrl: 'https://orcid.org/0000-0002-2493-3177',
        },
        {
          name: 'Neil Mitchell',
          orcidUrl: 'https://orcid.org/0000-0001-5171-9726',
        },
        { name: 'Simon Peyton Jones' },
      ],
      year: 2020,
      abstract:
        'Build systems are awesome, terrifying – and unloved. They are used by every developer around the world, but are rarely the object of study. In this paper, we offer a systematic, and executable, framework for developing and comparing build systems, viewing them as related points in a landscape rather than as isolated phenomena. By teasing apart existing build systems, we can recombine their components, allowing us to prototype new build systems with desired properties.',
      doiOrPublisherUrl: '10.1017/S0956796820000088',
      publicationInfo: {
        type: 'journal',
        journal: 'Journal of Functional Programming',
        volume: '30',
        publisher: 'Cambridge University Press',
        pages: 'e11',
      },
    },
    {
      title: 'Build systems à la carte',
      authors: [
        {
          name: 'Andrey Mokhov',
          orcidUrl: 'https://orcid.org/0000-0002-2493-3177',
        },
        {
          name: 'Neil Mitchell',
          orcidUrl: 'https://orcid.org/0000-0001-5171-9726',
        },
        { name: 'Simon Peyton Jones' },
      ],
      year: 2018,
      abstract:
        'Build systems are awesome, terrifying -- and unloved. They are used by every developer around the world, but are rarely the object of study. In this paper we offer a systematic, and executable, framework for developing and comparing build systems, viewing them as related points in landscape rather than as isolated phenomena. By teasing apart existing build systems, we can recombine their components, allowing us to prototype new build systems with desired properties.',
      doiOrPublisherUrl: '10.1145/3236774',
      publicationInfo: {
        type: 'conference',
        conference:
          "International Conference on Functional Programming 2018 (ACM ICFP '18)",
        location: 'St. Louis, Missouri, USA',
        publisher: 'ACM',
      },
    },
    {
      title: 'Multi-Platform Software Package Management',
      authors: [{ name: 'Joachim Schiele' }],
      year: 2011,
      abstract:
        'Today’s package management is a complex field. This diploma thesis analyses different package managementsystems in several regards: how the packaging is done; how the user interacts with the package manager; Apt(Debian Linux), Portage (Gentoo Linux) and Nix (Nix OS) are compared in great detail.To get practical results, the author used the evopedia application, an open source offline Wikipedia reader, toexperiment with several different package managers. This diploma thesis also tries to answer why there areno complex package managers for Microsoft Windows. Most package managers use their own terms which cannot be generalized to other package managers. This problem was solved by defining meaningful words whichdescribe certain properties of a package manager.',
      preprintOrArchiveUrl:
        'https://github.com/qknight/Multi-PlatformSoftwarePackageManagement/raw/master/Multi-PlatformSoftwarePackageManagement.pdf',
      publicationInfo: {
        type: 'thesis',
        thesisType: 'Diplomarbeit',
        institution: 'University of Tübingen',
        location: 'Tübingen, Germany',
      },
    },
    {
      title: 'Automating System Tests Using Declarative Virtual Machines',
      authors: [{ name: 'Sander van der Burg' }, { name: 'Eelco Dolstra' }],
      year: 2010,
      abstract:
        "Automated regression test suites are an essential software engineering practice: they provide developers with rapid feedback on the impact of changes to a system's source code. The inclusion of a test case in an automated test suite requires that the system's build process can automatically provide all the environmental dependencies of the test. These are external elements necessary for a test to succeed, such as shared libraries, running programs, and so on. For some tests (e.g., a compiler's), these requirements are simple to meet.\n\nHowever, many kinds of tests, especially at the integration or system level, have complex dependencies that are hard to provide automatically, such as running database servers, administrative privileges, services on external machines or specific network topologies. As such dependencies make tests difficult to script, they are often only performed manually, if at all. This particularly affects testing of distributed systems and system-level software.\n\nThis paper shows how we can automatically instantiate the complex environments necessary for tests by creating (networks of) virtual machines on the fly from declarative specifications. Building on NixOS, a Linux distribution with a declarative configuration model, these specifications concisely model the required environmental dependencies. We also describe techniques that allow efficient instantiation of VMs. As a result, complex system tests become as easy to specify and execute as unit tests. We evaluate our approach using a number of representative problems, including automated regression testing of a Linux distribution.",
      preprintOrArchiveUrl:
        'https://nixos.org/~eelco/pubs/decvms-issre2010-final.pdf',
      doiOrPublisherUrl: '10.1109/ISSRE.2010.34',
      publicationInfo: {
        type: 'conference',
        conference:
          '21st IEEE International Symposium on Software Reliability Engineering (ISSRE 2010)',
        location: 'San Jose, California, USA',
      },
    },
    {
      title: 'NixOS: A Purely Functional Linux Distribution',
      authors: [
        { name: 'Eelco Dolstra' },
        {
          name: 'Andres Löh',
          orcidUrl: 'https://orcid.org/0000-0002-7492-7293',
        },
        { name: 'Nicolas Pierron' },
      ],
      year: 2010,
      abstract:
        'Existing package and system configuration management tools suffer from an imperative model, where system administration actions such as upgrading packages or changes to system configuration files are stateful: they destructively update the state of the system. This leads to many problems, such as the inability to roll back changes easily, to deploy multiple versions of a package side-by-side, to reproduce a configuration deterministically on another machine, or to reliably upgrade a system. In this article we show that we can overcome these problems by moving to a purely functional system configuration model. This means that all static parts of a system (such as software packages, configuration files and system startup scripts) are built by pure functions and are immutable, stored in a way analogously to a heap in a purely functional language. We have implemented this model in NixOS, a non-trivial Linux distribution that uses the Nix package manager to build the entire system configuration from a modular, purely functional specification.',
      preprintOrArchiveUrl: 'https://nixos.org/~eelco/pubs/nixos-jfp-final.pdf',
      doiOrPublisherUrl: '10.1017/S0956796810000195',
      publicationInfo: {
        type: 'journal',
        journal: 'Journal of Functional Programming',
        volume: '20',
        number: '5-6',
        publisher: 'Cambridge University Press',
        pages: '577-615',
      },
    },
    {
      title:
        'Software Deployment in a Dynamic Cloud: From Device to Service Orientation in a Hospital Environment',
      authors: [
        { name: 'Sander van der Burg' },
        { name: 'Eelco Dolstra' },
        { name: 'Merijn de Jonge' },
        {
          name: 'Eelco Visser',
          orcidUrl: 'https://orcid.org/0000-0002-7384-3370',
        },
      ],
      year: 2009,
      abstract:
        'Hospital environments are currently primarily device-oriented: software services are installed, often manually, on specific devices. For instance, an application to view MRI scans may only be available on a limited number of workstations. The medical world is changing to a service-oriented environment, which means that every software service should be available on every device. However, these devices have widely varying capabilities, ranging from powerful workstations to PDAs, and high-bandwidth local machines to low-bandwidth remote machines. To support running applications in such an environment, we need to treat the hospital machines as a cloud, where components of the application are automatically deployed to machines in the cloud with the required capabilities and connectivity. In this paper, we suggest an architecture for applications in such a cloud, in which components are reliably and automatically deployed on the basis of a declarative model of the application using the Nix package manager.',
      preprintOrArchiveUrl:
        'https://nixos.org/~eelco/pubs/icse-cloud09-final.pdf',
      doiOrPublisherUrl: '10.1109/CLOUD.2009.5071534',
      publicationInfo: {
        type: 'conference',
        conference:
          '2009 ICSE Workshop on Software Engineering Challenges of Cloud Computing',
        location: 'Vancouver, British Columbia, Canada',
        pages: '61-66',
      },
    },
    {
      title: 'Atomic Upgrading of Distributed Systems',
      authors: [
        { name: 'Sander van der Burg' },
        { name: 'Eelco Dolstra' },
        { name: 'Merijn de Jonge' },
      ],
      year: 2008,
      abstract:
        'Upgrading distributed systems is a complex process. It requires installing the right services on the right machines, configuring them correctly, and so on, which is error-prone and tedious. Moreover, since services in a distributed system depend on each other and are updated separately, upgrades typically are not atomic: there is a time window during which some but not all services are updated, and a new version of one service might temporarily talk to an old version of another service. Previously we implemented the Nix package management system, which allows atomic upgrades and rollbacks on single systems. In this paper we show an extension to Nix that enables the deployment of distributed systems on the basis of a declarative deployment model, and supports atomic upgrades of such systems.',
      preprintOrArchiveUrl:
        'https://nixos.org/~eelco/pubs/atomic-hotswup2008-final.pdf',
      doiOrPublisherUrl: '10.1145/1490283.1490294',
      publicationInfo: {
        type: 'conference',
        conference:
          '1st International Workshop on Hot Topics in Software Upgrade (HotSWUp)',
        location: 'Nashville, Tennessee, USA',
      },
    },
    {
      title: 'NixOS: A Purely Functional Linux Distribution',
      authors: [
        { name: 'Eelco Dolstra' },
        {
          name: 'Andres Löh',
          orcidUrl: 'https://orcid.org/0000-0002-7492-7293',
        },
      ],
      year: 2008,
      abstract:
        'Existing package and system configuration management tools suffer from an imperative model, where system administration actions such as upgrading packages or changes to system configuration files are stateful: they destructively update the state of the system. This leads to many problems, such as the inability to roll back changes easily, to run multiple versions of a package side-by-side, to reproduce a configuration deterministically on another machine, or to reliably upgrade a system. In this paper we show that we can overcome these problems by moving to a purely functional system configuration model. This means that all static parts of a system (such as software packages, configuration files and system startup scripts) are built by pure functions and are immutable, stored in a way analogously to a heap in a purely function language. We have implemented this model in NixOS, a non-trivial Linux distribution that uses the Nix package manager to build the entire system configuration from a purely functional specification.',
      preprintOrArchiveUrl:
        'https://nixos.org/~eelco/pubs/nixos-icfp2008-final.pdf',
      doiOrPublisherUrl: '10.1145/1411204.1411255',
      publicationInfo: {
        type: 'conference',
        conference:
          'ICFP 2008: 13th ACM SIGPLAN International Conference on Functional Programming',
        location: 'Victoria, British Columbia, Canada',
        pages: '367-378',
      },
    },
    {
      title:
        'The Nix Build Farm: A Declarative Approach to Continuous Integration',
      authors: [
        { name: 'Eelco Dolstra' },
        {
          name: 'Eelco Visser',
          orcidUrl: 'https://orcid.org/0000-0002-7384-3370',
        },
      ],
      year: 2008,
      abstract:
        'There are many tools to support continuous integration (the process of automatically and continuously building a project from a version management repository). However, they do not have good support for variability in the build environment: dependencies such as compilers, libraries or testing tools must typically be installed manually on all machines on which automated builds are performed. The Nix package manager solves this problem: it has a purely functional language for describing package build actions and their dependencies, allowing the build environment for projects to be produced automatically and deterministically. We have used Nix to build a continuous integration tool, the Nix build farm, that is in use to continuously build and release a large set of projects.',
      preprintOrArchiveUrl:
        'https://nixos.org/~eelco/pubs/buildfarm-wasdett2008-final.pdf',
      publicationInfo: {
        type: 'conference',
        conference:
          'International Workshop on Advanced Software Development Tools and Techniques (WASDeTT 2008)',
        location: 'Paphos, Cyprus',
      },
    },
    {
      title:
        'Maximal Laziness — An Efficient Interpretation Technique for Purely Functional DSLs',
      authors: [{ name: 'Eelco Dolstra' }],
      year: 2008,
      abstract:
        "In lazy functional languages, any variable is evaluated at most once. This paper proposes the notion of maximal laziness, in which syntactically equal terms are evaluated at most once: if two terms e1 and e2 arising during the evaluation of a program have the same abstract syntax representation, then only one will be evaluated, while the other will reuse the former's evaluation result. Maximal laziness can be implemented easily in interpreters for purely functional languages based on term rewriting systems that have the property of maximal sharing — if two terms are equal, they have the same address. It makes it easier to write interpreters, as techniques such as closure updating, which would otherwise be required for efficienccy, are not needed. Instead, a straight-forward translation of call-by-name semantic rules yields a call-by-need interpreter, reducing the gap between the language specification and its implementation. Moreover, maximal laziness obviates the need for optimisations such as memoisation and let-floating.",
      preprintOrArchiveUrl:
        'https://nixos.org/~eelco/pubs/laziness-ldta2008-final.pdf',
      doiOrPublisherUrl: '10.1016/j.entcs.2009.09.042',
      publicationInfo: {
        type: 'conference',
        conference:
          'Eighth Workshop on Language Descriptions, Tools and Applications (LDTA 2008)',
        location: 'Budapest, Hungary',
        pages: '81-99',
        publisher: 'Elsevier Science Publishers',
      },
    },
    {
      title: 'Purely Functional System Configuration Management',
      authors: [{ name: 'Eelco Dolstra' }, { name: 'Armijn Hemel' }],
      year: 2007,
      abstract:
        "System configuration management is difficult because systems evolve in an undisciplined way: packages are upgraded, configuration files are edited, and so on. The management of existing operating systems is strongly imperative in nature, since software packages and configuration data (e.g., /bin and /etc in Unix) can be seen as imperative data structures: they are updated in-place by system administration actions. In this paper we present an alternative approach to system configuration management: a purely functional method, analogous to languages like Haskell. In this approach, the static parts of a configuration — software packages, configuration files, control scripts — are built from pure functions, i.e., the results depend solely on the specified inputs of the function and are immutable. As a result, realising a system configuration becomes deterministic and reproducible. Upgrading to a new configuration is mostly atomic and doesn't overwrite anything of the old configuration, thus enabling rollbacks. We have implemented the purely functional model in a small but realistic Linux-based operating system distribution called NixOS.",
      preprintOrArchiveUrl: 'https://nixos.org/~eelco/pubs/hotos-final.pdf',
      doiOrPublisherUrl: 'https://dl.acm.org/doi/abs/10.5555/1361397.1361410',
      publicationInfo: {
        type: 'conference',
        conference: '11th Workshop on Hot Topics in Operating Systems (HotOS XI)',
        location: 'San Diego, California, USA',
        publisher: 'ACM',
      },
    },
    {
      title: 'Automated Software Testing and Release with Nix Build Farms',
      authors: [
        { name: 'Eelco Dolstra' },
        {
          name: 'Eelco Visser',
          orcidUrl: 'https://orcid.org/0000-0002-7384-3370',
        },
      ],
      year: 2007,
      publicationInfo: {
        type: 'conference',
        conference: 'Verification and Validation of Software Systems (VVSS-2007)',
        pages: '65-77',
        location: 'Eindhoven, The Netherlands',
      },
      preprintOrArchiveUrl: 'https://pure.tue.nl/ws/files/2239914/628612.pdf',
    },
    {
      title: 'NixOS: the Nix based operating system',
      authors: [{ name: 'Armijn Hemel' }],
      year: 2006,
      abstract:
        "The subject of this thesis is how the Nix package management system can be applied to manage a whole Linux distribution. Many conventional package management systems have drawbacks that Nix ﬁxes. But, Nix has never been used to deploy and manage a whole system.\n\nIn this thesis a proof of concept Linux distribution called NixOS is described. NixOS uses the Nix package management system to manage all software that is installed on the system, including the Linux kernel, all software and system services.\n\nUsing Nix to manage all software on a system, as is done on NixOS, has several advantages. Developers don't need to be worried that unwanted dependencies are picked up during the build of a software package, since these are completely eliminated. System administrators get the possibility to deploy services using Nix and how they can immediately use all beneﬁts from Nix, including atomic upgrades and rollbacks, without going through a painful cycle of rolling back a service, with all its, possibly also updated, dependencies.\n\nThis thesis describes the implementation NixOS, including pitfalls that were encountered and choices that were made. Also shown are some concrete results of running NixOS and how NixOS can be bettered.",
      preprintOrArchiveUrl: 'http://nixos.org/docs/SCR-2005-091.pdf',
      publicationInfo: {
        type: 'thesis',
        thesisType: "Master's",
        institution:
          'Institute of Information and Computing Sciences, Utrecht University',
        location: 'Utrecht, The Netherlands',
      },
    },
    {
      title: 'The Purely Functional Software Deployment Model',
      authors: [{ name: 'Eelco Dolstra' }],
      year: 2006,
      abstract:
        "Software deployment is the set of activities related to getting software components to work on the machines of end users. It includes activities such as installation, upgrading, uninstallation, and so on. Many tools have been developed to support deployment, but they all have serious limitations with respect to correctness. For instance, the installation of a component can lead to the failure of previously installed components; a component might require other components that are not present; and it is generally difficult to undo deployment actions. The fundamental causes of these problems are a lack of isolation between components, the difficulty in identifying the dependencies between components, and incompatibilities between versions and variants of components.\n\nThis thesis describes a better approach based on a purely functional deployment model, implemented in a deployment system called Nix. Components are stored in isolation from each other in a Nix store. Each component has a name that contains a cryptographic hash of all inputs that contributed to its build process, and the content of a component never changes after it has been built. Hence the model is purely functional.\n\nThis storage scheme provides several important advantages. First, it ensures isolation between components: if two components differ in any way, they will be stored in different locations and will not overwrite each other. Second, it allows us to identify component dependencies. Undeclared build time dependencies are prevented due to the absence of “global” component directories used in other deployment systems. Runtime dependencies can be found by scanning for cryptographic hashes in the binary contents of components, a technique analogous to conservative garbage collection in programming language implementation. Since dependency information is complete, complete deployment can be performed by copying closures of components under the dependency relation.\n\nDevelopers and users are not confronted with components' cryptographic hashes directly. Components are built automatically from Nix expressions, which describe how to build and compose arbitrary software components; hashes are computed as part of this process. Components are automatically made available to users through “user environments”, which are synthesised sets of activated components. User environments enable atomic upgrades and rollbacks, as well as different sets of activated components for different users.\n\nNix expressions provide a source-based deployment model. However, source-based deployment can be transparently optimised into binary deployment by making pre-built binaries (keyed on their cryptographic hashes) available in a shared location such as a network server. This is referred to as transparent source/binary deployment.\n\nThe purely functional deployment model has been validated by applying it to the deployment of more than 278 existing Unix packages. In addition, this thesis shows that the model can be applied naturally to the related activities of continuous integration using build farms, service deployment and build management.",
      preprintOrArchiveUrl: 'https://nixos.org/~eelco/pubs/phd-thesis.pdf',
      publicationInfo: {
        type: 'thesis',
        thesisType: 'PhD',
        institution: 'Faculty of Science, Utrecht University',
        location: 'Utrecht, The Netherlands',
      },
    },
    {
      title:
        'Secure Sharing Between Untrusted Users in a Transparent Source/Binary Deployment Model',
      authors: [{ name: 'Eelco Dolstra' }],
      year: 2005,
      abstract:
        'The Nix software deployment system is based on the paradigm of transparent source/binary deployment: distributors deploy descriptors that build components from source, while client machines can transparently optimise such source builds by downloading pre-built binaries from remote repositories. This model combines the simplicity and flexibility of source deployment with the efficiency of binary deployment. A desirable property is sharing of components: if multiple users install from the same source descriptors, ideally only one remotely built binary should be installed. The problem is that users must trust that remotely downloaded binaries were built from the sources they are claimed to have been built from, while users in general do not have a trust relation with each other or with the same remote repositories.\n\nThis paper presents three models that enable sharing: the extensional model that requires that all users on a system have the same remote trust relations, the intensional model that does not have this requirement but may be suboptimal in terms of space use, and the mixed model that merges the best properties of both. The latter two models are achieved through a novel technique of {em hash rewriting} in content-addressable component stores, and were implemented in the context of the Nix system.',
      preprintOrArchiveUrl:
        'https://nixos.org/~eelco/pubs/secsharing-ase2005-final.pdf',
      publicationInfo: {
        type: 'conference',
        conference:
          '20th IEEE/ACM International Conference on Automated Software Engineering (ASE 2005)',
        location: 'Long Beach, California, USA',
        publisher: 'ACM',
        pages: '154–163',
      },
    },
    {
      title: 'Service Configuration Management',
      authors: [
        { name: 'Eelco Dolstra' },
        { name: 'Martin Bravenboer' },
        {
          name: 'Eelco Visser',
          orcidUrl: 'https://orcid.org/0000-0002-7384-3370',
        },
      ],
      year: 2005,
      abstract:
        'The deployment of services — sets of running programs that provide some useful facility on a system or network — is typically implemented through a manual, time-consuming and error-prone process. For instance, system administrators must deploy the necessary software components, edit configuration files, start or stop processes, and so on. This is often done in an ad hoc style with no reproducibility, violating proper configuration management practices. In this paper we show that build management, software deployment and service deployment can be integrated into a single formalism. We do this in the context of the Nix software deployment system, and show that its advantages — co-existence of versions and variants, atomic upgrades and rollbacks, and component closure — extend naturally to service deployment. The approach also elegantly extends to distributed services. In addition, we show that the Nix expression language can simplify the implementation of crosscutting variation points in services.',
      publicationInfo: {
        type: 'conference',
        conference:
          '12th International Workshop on Software Configuration Management (SCM-12)',
        location: 'Long Beach, California, USA',
        pages: '83–98',
      },
      preprintOrArchiveUrl:
        'https://nixos.org/~eelco/pubs/servicecm-scm12-final.pdf',
    },
    {
      title:
        'Efficient Upgrading in a Purely Functional Component Deployment Model',
      authors: [{ name: 'Eelco Dolstra' }],
      year: 2005,
      abstract:
        'Safe and efficient deployment of software components is an important aspect of CBSE. The Nix deployment system enables side-by-side deployment of different versions and variants of components, complete installation, safe upgrades, and safe uninstalls through garbage collection. It accomplishes this through a purely functional deployment model, meaning that the file system content of a component only depends on the inputs used to build it, and never changes afterwards. An apparent downside to this model is that upgrading "fundamental" components used as build inputs by many other components becomes expensive, since all of these must be rebuilt and redeployed. In this paper we show that binary patching between sets of components enables efficient deployment of upgrades in the purely functional model, transparently to users. Sequences of patches can be combined automatically to enable upgrading between arbitrary versions. The approach was empirically validated.',
      preprintOrArchiveUrl:
        'https://nixos.org/~eelco/pubs/eupfcdm-cbse2005-final.pdf',
      doiOrPublisherUrl: 'https://doi.org/10.1007/11424529_15',
      publicationInfo: {
        type: 'conference',
        conference:
          'Eighth International SIGSOFT Symposium on Component-based Software Engineering (CBSE 2005)',
        location: 'St. Louis, Missouri, USA',
        publisher: 'Springer-Verlag',
        pages: '219–234',
      },
    },
    {
      title: 'Nix: A Safe and Policy-Free System for Software Deployment',
      authors: [
        { name: 'Eelco Dolstra' },
        { name: 'Merijn de Jonge' },
        {
          name: 'Eelco Visser',
          orcidUrl: 'https://orcid.org/0000-0002-7384-3370',
        },
      ],
      year: 2004,
      abstract:
        'Existing systems for software deployment are neither safe nor sufficiently flexible. Primary safety issues are the inability to enforce reliable specification of component dependencies, and the lack of support for multiple versions or variants of a component. This renders deployment operations such as upgrading or deleting components dangerous and unpredictable. A deployment system must also be flexible (i.e., policy-free) enough to support both centralised and local package management, and to allow a variety of mechanisms for transferring components. In this paper we present Nix, a deployment system that addresses these issues through a simple technique of using cryptographic hashes to compute unique paths for component instances.',
      publicationInfo: {
        type: 'conference',
        conference:
          "18th Large Installation System Administration Conference (LISA '04)",
        location: 'Atlanta, Georgia, USA',
        publisher: 'USENIX',
        pages: '79–92',
      },
      preprintOrArchiveUrl:
        'https://nixos.org/~eelco/pubs/nspfssd-lisa2004-final.pdf',
    },
    {
      title: 'Imposing a Memory Management Discipline on Software Deployment',
      authors: [
        { name: 'Eelco Dolstra' },
        {
          name: 'Eelco Visser',
          orcidUrl: 'https://orcid.org/0000-0002-7384-3370',
        },
        { name: 'Merijn de Jonge' },
      ],
      year: 2004,
      abstract:
        'The deployment of software components frequently fails because dependencies on other components are not declared explicitly or are declared imprecisely. This results in an incomplete reproduction of the environment necessary for proper operation, or in interference between incompatible variants. In this paper we show that these deployment hazards are similar to pointer hazards in memory models of programming languages and can be countered by imposing a memory management discipline on software deployment. Based on this analysis we have developed a generic, platform and language independent, discipline for deployment that allows precise dependency verification; exact identification of component variants; computation of complete closures containing all components on which a component depends; maximal sharing of components between such closures; and concurrent installation of revisions and variants of components. We have implemented the approach in the Nix deployment system, and used it for the deployment of a large number of existing Linux packages. We compare its effectiveness to other deployment systems.',
      preprintOrArchiveUrl:
        'https://nixos.org/~eelco/pubs/immdsd-icse2004-final.pdf',
      doiOrPublisherUrl: '10.1109/ICSE.2004.1317480',
      publicationInfo: {
        type: 'conference',
        conference:
          '26th International Conference on Software Engineering (ICSE 2004)',
        location: 'Edinburgh, Scotland',
        publisher: 'IEEE Computer Society',
        pages: '583–592',
      },
    },
    {
      title: 'Integrating Software Construction and Software Deployment',
      authors: [{ name: 'Eelco Dolstra' }],
      year: 2003,
      abstract:
        'Classically, software deployment is a process consisting of building the software, packaging it for distribution, and installing it at the target site. This approach has two problems. First, a package must be annotated with dependency information and other meta-data. This to some extent overlaps with component dependencies used in the build process. Second, the same source system can often be built into an often very large number of variants. The distributor must decide which element(s) of the variant space will be packaged, reducing the flexibility for the receiver of the package. In this paper we show how building and deployment can be integrated into a single formalism. We describe a build manager called Maak that can handle deployment through a sufficiently general module system. Through the sharing of generated files, a source distribution transparently turns into a binary distribution, removing the dichotomy between these two modes of deployment. In addition, the creation and deployment of variants becomes easy through the use of a simple functional language as the build formalism.',
      publicationInfo: {
        type: 'conference',
        conference:
          '11th International Workshop on Software Configuration Management (SCM-11)',
        location: 'Portland, Oregon, USA',
        pages: '102–117',
      },
      preprintOrArchiveUrl: 'https://nixos.org/~eelco/pubs/iscsd-scm11-final.pdf',
    },
  ] as const;