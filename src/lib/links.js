const NIX_VERSION = import.meta.env.NIX_STABLE_VERSION;
const NIXOS_VERSION = import.meta.env.NIXOS_STABLE_SERIES;

const NIX_VERSION_SANITIZED = NIX_VERSION.split('.').slice(0, -1).join('.');

export const NIX_RELEASE_NOTES_LINK = `/manual/nix/stable/release-notes/rl-${NIX_VERSION_SANITIZED}`;
export const NIXOS_RELEASE_NOTES_LINK = `/manual/nixos/stable/release-notes#sec-release-${NIXOS_VERSION}`;

export const nixosDownloadLink = (
  variant,
  arch,
  format = 'iso',
  sha256 = false,
) => {
  return `https://channels.nixos.org/nixos-${NIXOS_VERSION}/latest-nixos-${variant ? `${variant}-` : ''}${arch}.${format}${sha256 ? '.sha256' : ''}`;
};
