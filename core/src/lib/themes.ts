import logoDefault from '@nixos/branding/artifacts/internal/nixos-logo-default-gradient-white-regular-horizontal-none.svg';
import logoRainbow from '@nixos/branding/artifacts/internal/nixos-logo-rainbow-gradient-white-regular-horizontal-none.svg';
import { THEME } from 'astro:env/client';

export function getNixosLogoUrl() {
  switch (THEME) {
    case 'pride':
      return logoRainbow;
    default:
      return logoDefault;
  }
}
