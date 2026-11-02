// Generates the section divider tile core/src/assets/image/divider/lambda_stack_24_tile.svg.
//
// Run with: npm run dividers --workspace core
//
// The tile is one horizontal period of a hex-lattice tiling of the NixOS logomark on a
// transparent ground, sized for CSS background-repeat along x. The logomark's dark lambdas
// are the section blue #3b5487 and its light lambdas white, so when the page paints white
// above the middle and section blue below, each logo is half figure and half ground on
// either side of the line. Divider.astro supplies that ground.
//
// Logos alternate between a cell and its mirror image down each column, with a 0,1,1,0
// column rhythm, so that every horizontal and 120-degree edge between neighbours meets as
// an exact reflection. The logos in the first column straddle the left edge; the period is
// drawn again one period to the right to complete their other halves at the right edge,
// and the viewBox clips the rest.
//
// Lambda coordinates are taken from nixos-logomark-default-flat-none.svg on brand.nixos.org,
// in lattice units: x in R/9, y in (R*sqrt3/2)/9, where R is the circumradius of the
// flat-top hexagon that bounds the logo.

import { writeFileSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';

const SQ3 = Math.sqrt(3);
const LAMBDA = [
  [-3.875, 0.25],
  [0.5, 9],
  [-1.5, 9],
  [-2.5, 7],
  [-3.5, 9],
  [-4.5, 9],
  [-5, 8],
  [-3.5, 5],
  [-4.875, 2.25],
];

const CELL = 24; // circumradius of each logo's bounding hexagon, px
const HEIGHT = 120; // tile height, px; must match the h-30 class in Divider.astro
const GROUT = 0.75; // px inset on every lambda, so neighbouring logos stay distinct
const FILE = 'lambda_stack_24_tile.svg';

const num = (v, digits) => {
  const f = 10 ** digits;
  return (Math.round(v * f) / f).toString();
};
const toReal = (p, R) => [(p[0] * R) / 9, (p[1] * R * SQ3) / 18];
const rot = (p, k) => {
  const a = (k * Math.PI) / 3,
    c = Math.cos(a),
    s = Math.sin(a);
  return [p[0] * c - p[1] * s, p[0] * s + p[1] * c];
};
// Reflection across the line at 60 degrees through the origin. Because the logo has 6-fold
// symmetry this is the same coloured figure as a reflection across the x axis.
const mirror60 = (p) => [
  -0.5 * p[0] + (SQ3 / 2) * p[1],
  (SQ3 / 2) * p[0] + 0.5 * p[1],
];
// Which cells are mirrored. Column i, row j; odd columns sit half a row lower.
const mirrored = (i, j) => (j + [0, 1, 1, 0][i % 4]) & 1;

// Six lambdas of one logo centred at (cx, cy): [{ parity, points }].
function logo(cx, cy, R, flip) {
  const place = (q) => {
    const r = flip ? mirror60(q) : q;
    return [cx + r[0], cy + r[1]];
  };
  const out = [];
  for (let k = 0; k < 6; k++) {
    out.push({
      parity: k % 2,
      points: LAMBDA.map((p) => place(rot(toReal(p, R), k))),
    });
  }
  return out;
}

// Move every edge of a simple polygon inward by d and re-intersect neighbouring edges.
function inset(points, d) {
  const n = points.length;
  let area = 0;
  for (let i = 0; i < n; i++) {
    const a = points[i],
      b = points[(i + 1) % n];
    area += a[0] * b[1] - b[0] * a[1];
  }
  const sign = area > 0 ? 1 : -1;
  const lines = points.map((a, i) => {
    const b = points[(i + 1) % n];
    const len = Math.hypot(b[0] - a[0], b[1] - a[1]);
    const e = [(b[0] - a[0]) / len, (b[1] - a[1]) / len];
    const nrm = [-e[1] * sign, e[0] * sign];
    return { p: [a[0] + nrm[0] * d, a[1] + nrm[1] * d], e };
  });
  return points.map((_, i) => {
    const L1 = lines[(i - 1 + n) % n],
      L2 = lines[i];
    const cross = L1.e[0] * L2.e[1] - L1.e[1] * L2.e[0];
    const t =
      ((L2.p[0] - L1.p[0]) * L2.e[1] - (L2.p[1] - L1.p[1]) * L2.e[0]) / cross;
    return [L1.p[0] + L1.e[0] * t, L1.p[1] + L1.e[1] * t];
  });
}

// One period: four columns of logos. Rows are fitted so the top and bottom rows are
// whole logos, centred vertically.
function tile() {
  const R = CELL;
  const dx = 1.5 * R,
    h = (R * SQ3) / 2,
    dy = 2 * h,
    pad = 6;
  const rows = Math.max(1, Math.floor((HEIGHT - 2 * pad - h) / dy));
  const y0 = (HEIGHT - (rows * dy + h)) / 2 + h;
  const period = 4 * dx;
  const shapes = [];
  for (let i = 0; i < 4; i++) {
    for (let j = 0; j < rows; j++) {
      const cy = y0 + j * dy + (i & 1 ? h : 0);
      for (const s of logo(i * dx, cy, R, mirrored(i, j))) {
        const pts = inset(s.points, GROUT)
          .map((p) => num(p[0], 2) + ',' + num(p[1], 2))
          .join(' ');
        shapes.push(
          `<polygon class="ld-${s.parity ? 'a' : 'b'}" points="${pts}"/>`,
        );
      }
    }
  }
  const id = `lambda-stack-${R}-tile`;
  return [
    `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 ${period} ${HEIGHT}" width="${period}" height="${HEIGHT}">`,
    `<style>.ld-a{fill:#ffffff}.ld-b{fill:#3b5487}</style>`,
    `<defs><g id="${id}">`,
    ...shapes,
    `</g></defs>`,
    `<use href="#${id}"/>`,
    `<use href="#${id}" x="${period}"/>`,
    `</svg>`,
    '',
  ].join('\n');
}

const file = join(
  dirname(fileURLToPath(import.meta.url)),
  'src',
  'assets',
  'image',
  'divider',
  FILE,
);
writeFileSync(file, tile());
console.log(`wrote ${file}`);
