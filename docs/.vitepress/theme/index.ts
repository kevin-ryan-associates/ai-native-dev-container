// KRA theme entry point.
//
// Extends the VitePress default theme (so all built-in components — navbar,
// sidebar, search, local nav, etc. — keep working) and layers the KRA brand
// on top via CSS overrides. Fonts are self-hosted through @fontsource packages
// (no CDN dependency); the woff2 assets are bundled at build time.
//
// Import order matters only in that brand.css must run after the fontsource
// imports so the font-family custom properties resolve against loaded faces.

import type { Theme } from 'vitepress'
import DefaultTheme from 'vitepress/theme'

// Self-hosted fonts (woff2 bundled into the build output). Each package ships
// only the weights/subsets we import below, keeping the footprint small.
import '@fontsource/bebas-neue/400.css'
import '@fontsource-variable/archivo/wght.css'
import '@fontsource-variable/work-sans/wght.css'

import './brand.css'

export default {
  extends: DefaultTheme,
} satisfies Theme