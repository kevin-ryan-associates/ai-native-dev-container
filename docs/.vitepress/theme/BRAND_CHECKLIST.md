# KRA Brand — Colour Application Checklist

Reference for styling any custom Vue components or content added on top of the
VitePress theme. All values live as CSS custom properties in `brand.css`; import
nothing, hardcode nothing.

## Tokens to use

| Need | Token | Notes |
|------|-------|-------|
| Lime accent on a dark surface (navbar, code block, active bar) | `--color-primary` | The headline lime #A8E10C. **Do not use for text on light backgrounds — fails AA.** |
| Readable brand text on a light surface (body links, inline code on warm-white) | `--color-primary-darker` (#5C8A06) | Clears WCAG AA against `--color-background`. This is what `--vp-c-brand-1` is mapped to. |
| Lime accent, lighter/darker variants | `--color-primary-light` / `--color-primary-dark` | Hover states. |
| Primary text on light surface | `--color-text-primary` (#0A0A0A) | |
| Secondary text / borders | `--color-text-secondary` (#55524E) | |
| Warm-white surface | `--color-background` (#F5F3EF) | |
| Near-black surface | `--color-background-dark` (#0A0A0A) | Navbar, code blocks, dark-mode body. |
| Headings | `font-family: var(--font-display)` | Bebas Neue, all-caps. Reserve for h1/h2. |
| Body / prose | `font-family: var(--font-body)` | Archivo. |
| UI (buttons, nav labels, badges) | `font-family: var(--font-ui)` | Work Sans. |
| Spacing | `--spacing-xs … --spacing-2xl` | Use the scale, not magic numbers. |

## Rules

1. **No raw hex in components / markup.** Always read a token.
2. **Dark mode is `.dark`.** If you write a custom block, support both directions
   by reading VitePress surface vars (`--vp-c-bg`, `--vp-c-text-1`) rather than
   the light-only `--color-background` / `--color-text-primary`. Those vars flip
   automatically; the raw `--color-*` ones are palette-fixed.
3. **Lime text on warm white is not AA.** For text, use `--color-primary-darker`.
   Reserve lime for fills, bars, icons-on-dark, and accents.
4. **Buttons:** lime fill (`--color-primary`), dark text
   (`--color-text-primary`). Hover → `--color-primary-light`. Keep text dark in
   both modes — lime + dark text passes AA either way.
5. **Cards / callouts:** add a 3px lime left bar (`--color-primary`) over the
   neutral border (`--vp-c-divider`) for instant brand recognition.
6. **Always add a `:focus-visible` outline** using `--color-primary`,
   `outline-offset: 2px` — keyboard users need a visible focus on dark elements.
7. **Test both light and dark** by toggling the theme switch in the navbar. A
   component that only looks right in one mode is broken.

## Verifying contrast

- Lime #A8E10C on #0A0A0A → ~13:1 (pass, AAA-large).
- Lime #A8E10C on #F5F3EF → ~1.3:1 (fail — never use as text here).
- `--color-primary-darker` #5C8A06 on #F5F3EF → ~5.6:1 (pass AA).
- `--color-text-primary` #0A0A0A on #F5F3EF → ~19:1 (pass AAA).
- `--color-text-secondary` #55524E on #F5F3EF → ~7:1 (pass AAA).

If a new combination is needed, check it before shipping:
<https://webaim.org/resources/contrastchecker/>.