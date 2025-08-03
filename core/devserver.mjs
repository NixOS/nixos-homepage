import { dev } from 'astro';
import express from 'express';
import chalk from 'chalk';

console.log(chalk.gray('--- Spinning up Astro dev server...'));
console.log(
  chalk.red(
    '--- The link outputted by the Astro dev server does not include external content like manuals, pills and demos',
  ),
);

const app = express();
const devServer = await dev({
  root: './.',
  server: {
    port: 4320,
  },
  vite: {
    server: {
      hmr: {
        clientPort: 4320,
      },
    },
  },
});

app.use('/manual', express.static(process.env.PATH_MANUAL));
app.use('/guides/nix-pills', express.static(process.env.PATH_PILLS));
app.use('/demos', express.static(process.env.PATH_DEMOS));
app.use('/branding', express.static(process.env.PATH_BRANDING));
app.use(devServer.handle);

app.listen(devServer.address.port + 1, () => {
  console.log(
    '\n' +
      chalk.bgGreen.black('--- Dev env startup complete') +
      '\n' +
      chalk.gray(
        '--- The following link does include external content like manuals, pills and demos\n',
      ) +
      chalk.green(`--- Dev server running at `) +
      chalk.underline.bold(`http://localhost:${devServer.address.port + 1}`),
  );
});
