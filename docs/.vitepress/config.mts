import { defineConfig } from 'vitepress'

export default defineConfig({
  title: 'AI-Native Dev Container',
  description: 'Docker-based AI-native dev environment with OpenCode, Neovim (AstroNvim), and a curated CLI toolbelt.',
  base: '/ai-native-dev-container/',
  cleanUrls: true,
  lastUpdated: true,

  themeConfig: {
    nav: [
      { text: 'Guide', link: '/guide/getting-started' },
      { text: 'Research', link: '/research/' },
      { text: 'Reference', link: '/reference/cli' },
    ],

    sidebar: {
      '/guide/': [
        {
          text: 'Guide',
          items: [
            { text: 'Getting Started', link: '/guide/getting-started' },
            { text: 'Usage', link: '/guide/usage' },
            { text: 'Dev Container', link: '/guide/devcontainer' },
            { text: 'Port Forwarding', link: '/guide/ports' },
            { text: 'Secrets Management', link: '/guide/secrets' },
          ],
        },
      ],
      '/research/': [
        {
          text: 'Research',
          items: [
            { text: 'EU Digital Sovereignty', link: '/research/eu-digital-sovereignty' },
            { text: 'AI Coding Agents', link: '/research/ai-coding-agents' },
            { text: 'How Coding Agents Swap Models', link: '/research/how-coding-agents-swap-models' },
            { text: 'The Harness', link: '/research/the-harness' },
            { text: 'Developing the Harness', link: '/research/developing-the-harness' },
            { text: 'Model Selection', link: '/research/model-selection' },
            { text: 'The Development Container Standard', link: '/research/devcontainer-standard' },
            { text: 'Docker and Podman', link: '/research/docker-and-podman' },
          ],
        },
      ],
      '/reference/': [
        {
          text: 'Reference',
          items: [
            { text: 'CLI Reference', link: '/reference/cli' },
            { text: 'Configuration', link: '/reference/configuration' },
            { text: 'Project Structure', link: '/reference/project-structure' },
          ],
        },
      ],
    },

    socialLinks: [
      { icon: 'github', link: 'https://github.com/kevin-ryan-associates/ai-native-dev-container' },
    ],

    editLink: {
      pattern: 'https://github.com/kevin-ryan-associates/ai-native-dev-container/edit/main/docs/:path',
      text: 'Edit this page on GitHub',
    },

    footer: {
      message: 'Released under the MIT License.',
    },
  },
})
