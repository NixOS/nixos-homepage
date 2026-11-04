import logoDefaultOnLight from '@nixos/branding/artifacts/internal/nixos-logo-default-gradient-black-regular-horizontal-none.svg';
import logoWhiteOnLight from '@nixos/branding/artifacts/internal/nixos-logo-white-flat-white-regular-horizontal-none.svg';
import logoRainbowOnDark from '@nixos/branding/artifacts/internal/nixos-logo-rainbow-gradient-white-regular-horizontal-none.svg';
import logoRainbowOnLight from '@nixos/branding/artifacts/internal/nixos-logo-rainbow-gradient-black-regular-horizontal-none.svg';
import { THEME } from 'astro:env/client';

export function getNixosLogoUrl(background: 'dark' | 'light' = 'dark') {
  const light = background === 'light';
  switch (THEME) {
    case 'pride':
      return light ? logoRainbowOnLight : logoRainbowOnDark;
    default:
      return light ? logoDefaultOnLight : logoWhiteOnLight;
  }
}
