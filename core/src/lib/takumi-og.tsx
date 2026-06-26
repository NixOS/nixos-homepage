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
        padding: 32,
      }}
    >
      <div
        style={{
          display: 'flex',
          alignItems: 'center',
          backgroundColor: '#4d6fb7',
          color: '#ffffff',
          justifyContent: 'start',
        }}
      >
        <img
          src={imageBase64}
          style={{
            paddingLeft: '2rem',
            paddingRight: '2rem',
            height: 140,
          }}
        />
      </div>
      <div
        style={{
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'start',
          backgroundColor: '#ffffff',
        }}
      >
        <span
          style={{
            color: '#4d6fb7',
            fontSize: 64,
            lineHeight: 1,
            lineClamp: 3,
            textWrap: 'balance',
            marginTop: -8,
            paddingLeft: '2rem',
            paddingRight: '2rem',
          }}
        >
          {title}
        </span>
      </div>
    </div>,
  );
}
