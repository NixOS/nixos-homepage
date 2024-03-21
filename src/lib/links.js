const NIX_VERSION = import.meta.env.NIX_STABLE_VERSION;
const NIXOS_VERSION = import.meta.env.NIXOS_STABLE_SERIES;

const NIX_VERSION_SANITIZED = NIX_VERSION.split('.').slice(0, -1).join('.');

export const nixReleaseNotesLink = `/manual/nix/stable/release-notes/rl-${NIX_VERSION_SANITIZED}`;
export const nixosReleaseNotesLink = `/manual/nixos/stable/release-notes#sec-release-${NIXOS_VERSION}`;