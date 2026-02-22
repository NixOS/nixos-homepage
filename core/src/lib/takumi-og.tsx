import type { RenderFunctionInput } from 'astro-takumi';
import React from 'react';

export async function nixOg({
  title,
  description,
}: RenderFunctionInput): Promise<React.ReactNode> {
  return Promise.resolve(
    <div
      style={{
        display: 'flex',
        height: '100%',
        width: '100%',
        alignItems: 'start',
        justifyContent: 'center',
        flexDirection: 'column',
        backgroundColor: '#4d6fb7',
        textAlign: 'center',
        padding: 32,
      }}
    >
      <div
        style={{
          color: '#ffffff',
          fontSize: 72,
          fontWeight: 900,
          fontFamily: 'Roboto Flex',
        }}
      >
        {title}
      </div>
    </div>,
  );
}
