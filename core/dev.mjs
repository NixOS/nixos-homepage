import { dev } from "astro";
import express from 'express';

const app = express();
const devServer = await dev({
  root: "./.",
  server: {
    port: 4320
  }
})

app.use('/manual', express.static(process.env.PATH_MANUAL))
app.use('/guides/nix-pills', express.static(process.env.PATH_PILLS))
app.use('/demos', express.static(process.env.PATH_DEMOS))
app.use(devServer.handle);

app.listen(devServer.address.port + 1, () => {
  console.log(`--- http://localhost:${devServer.address.port + 1} ---`)
})