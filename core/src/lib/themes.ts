import { THEME } from 'astro:env/client';
import { getNixLogoUrlUniversal } from './utils';

export function getNixLogoUrl(): string {
    return getNixLogoUrlUniversal(THEME, '');
}
