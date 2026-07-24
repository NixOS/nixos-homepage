import type { AstroIntegration } from 'astro';
import astroIcon from 'astro-icon';
import tailwindcss from '@tailwindcss/vite';

export default function nixosUi(): AstroIntegration {
  return {
    name: '@nixos/ui',
    hooks: {
      'astro:config:setup'(params) {
        params.updateConfig({
          integrations: [astroIcon({
            include: {
              mdi: ['*'],
              simpleIcons: ['*'],
            },
          })],
          vite: {
            plugins: [tailwindcss()],
          },
        });
      },
    },
  };
}
