import logoDefault from '@NixOS/branding/artifacts/internal/nixos-logo-default-gradient-black-regular-horizontal-none.svg';
import logoRainbow from '@NixOS/branding/artifacts/internal/nixos-logo-rainbow-gradient-black-regular-horizontal-none.svg';
import { THEME } from 'astro:env/client';

export function getNixosLogoUrl() {
  switch (THEME) {
    case 'pride':
      return logoRainbow;
    default:
      return logoDefault;
  }
}
