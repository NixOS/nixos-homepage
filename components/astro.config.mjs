import { defineConfig } from 'astro/config';
import nixosUi from './astroIntegration';

export default defineConfig({
  output: 'static',
  integrations: [
    nixosUi()
  ],
});
