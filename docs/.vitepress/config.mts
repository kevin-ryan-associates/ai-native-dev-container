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
          text: 'Governance & Sovereignty',
          items: [
            { text: 'EU Digital Sovereignty', link: '/research/governance-and-sovereignty/eu-digital-sovereignty' },
          ],
        },
        {
          text: 'Agents & Models',
          items: [
            { text: 'AI Coding Agents', link: '/research/agents-and-models/ai-coding-agents' },
            { text: 'The Harness', link: '/research/agents-and-models/the-harness' },
            { text: 'Developing the Harness', link: '/research/agents-and-models/developing-the-harness' },
            { text: 'Agentic Tooling', link: '/research/agents-and-models/agentic-tooling' },
            { text: 'How Coding Agents Swap Models', link: '/research/agents-and-models/how-coding-agents-swap-models' },
            { text: 'Model Selection', link: '/research/agents-and-models/model-selection' },
            { text: 'The Model Ecosystem', link: '/research/agents-and-models/the-model-ecosystem' },
          ],
        },
        {
          text: 'Containers & Infrastructure',
          items: [
            { text: 'The Development Container Standard', link: '/research/containers-and-infrastructure/devcontainer-standard' },
            { text: 'Docker and Podman', link: '/research/containers-and-infrastructure/docker-and-podman' },
            { text: 'Container Registries', link: '/research/containers-and-infrastructure/container-registries' },
            { text: 'npm Package Registries', link: '/research/containers-and-infrastructure/npm-package-registries' },
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
