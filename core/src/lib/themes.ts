import { THEME } from 'astro:env/client';
import { getNixosLogosUrlUniversal } from './utils';

export function getNixosLogoUrl(style): string {
  return getNixosLogosUrlUniversal(THEME, '')[style];
}
