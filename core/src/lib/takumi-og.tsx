import type { RenderFunctionInput } from 'astro-takumi';
import React from 'react';
import path from 'path';
import fs from 'fs';

const filePath = path.join(
  process.cwd(),
  '..',
  'node_modules',
  '@nixos',
  'branding',
  'artifacts',
  'internal',
  'nixos-logo-white-flat-white-regular-horizontal-none.svg',
);

const imageBase64 = `data:image/png;base64,${fs.readFileSync(filePath).toString('base64')}`;

export async function nixOg({
  title,
  description,
}: RenderFunctionInput): Promise<React.ReactNode> {
  return Promise.resolve(
    <div
      style={{
        display: 'grid',
        gridTemplateColumns: '1fr',
        gridTemplateRows: '1fr 1fr',
        height: '100%',
        width: '100%',
        backgroundColor: '#4d6fb7',
        padding: 32,
      }}
    >
      <div
        style={{
          gridRow: '1 / 2',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'start',
        }}
      >
        <img
          src={imageBase64}
          style={{
            height: 140,
            marginBottom: '2rem',
          }}
        />
      </div>
      <div
        style={{
          gridRow: '2 / 3',
          display: 'flex',
          alignItems: 'start',
          justifyContent: 'start',
        }}
      >
        <div
          style={{
            color: '#ffffff',
            fontSize: 72,
            fontWeight: 600,
            fontFamily: 'Roboto Flex',
          }}
        >
          {title}
        </div>
      </div>
    </div>,
  );
}
