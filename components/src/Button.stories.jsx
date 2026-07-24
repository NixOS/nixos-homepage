import Button from './Button.astro';

export default {
  title: 'Components/Button',
  component: Button,
};

export const Default = {
  args: {
    label: 'Click me',
    nonPublic: false,
    color: 'semidarkblue',
  },
};
