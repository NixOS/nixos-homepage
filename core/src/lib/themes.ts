import logoDefault from '@nixos/branding/artifacts/internal/nixos-logo-default-gradient-black-regular-horizontal-none.svg';
import logoDefaultWhite from '@nixos/branding/artifacts/internal/nixos-logo-default-gradient-white-regular-horizontal-none.svg';
import logoRainbow from '@nixos/branding/artifacts/internal/nixos-logo-rainbow-gradient-black-regular-horizontal-none.svg';
import logoRainbowWhite from '@nixos/branding/artifacts/internal/nixos-logo-rainbow-gradient-white-regular-horizontal-none.svg';

import { THEME } from 'astro:env/client';

export function getNixosLogoUrl(variant = 'black') {
  switch (THEME) {
    case 'pride':
      return variant === 'white' ? logoRainbowWhite : logoRainbow;
    default:
      return variant === 'white' ? logoDefaultWhite : logoDefault;
  }
}
