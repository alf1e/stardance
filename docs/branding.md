# Stardance branding

Authoritative reference for the Stardance visual identity: colors, typography,
containers, buttons, and forms. Sourced from the Figma "design system" page in
[the empty space above](https://www.figma.com/design/0SKWTBoX3TSGPfF1SOAQBL/the-empty-space-above?node-id=4473-6469)
(node `4473:6469`).

This document is the source of truth. The CSS tokens in
[app/assets/stylesheets/config/_variables.scss](../app/assets/stylesheets/config/_variables.scss)
should follow what's here. When the code and this doc disagree, the doc wins
unless the code is being intentionally moved first — in that case, update the
doc in the same PR.

For agents: the brief version is in [AGENTS.md](../AGENTS.md#stardance-themeing).
Read this doc when you need details beyond the brief — anything to do with
typography sizing, button states, container semantics, or which set/accent
applies in a given context.

---

## 1. Colors

The palette is split into four families:

| Family | Purpose |
| --- | --- |
| **Sets 1–4** | Surfaces: page background + container fills, paired with their own foreground text colors. |
| **Highlights** | Quiet attention-grabbers (callouts, toasts, badges) that aren't a full accent. |
| **Accents 1–6** | The expressive pastel palette — used sparingly for emphasis, illustrations, status, branded surfaces. |
| **Foreground** | Pure white text used on dark sets. |

**Rule:** never use pure black `#000000`. The darkest color in the system is
set 1's background, `#08061E`.

**Rule:** when in doubt, pick from the palette below. If you must go outside it,
stay pastel — avoid deep saturated colors that fight with the rest of the
system.

### 1.1 Sets (containers + their text)

Each set is a `(background, secondary-foreground)` pair. The "foreground" is
always `#FFFFFF` (white). Use `secondary-foreground` for muted/secondary text
on top of that set's `background`.

| Set | Background | Secondary foreground | Where to use |
| --- | --- | --- | --- |
| **Set 1** — main | `#08061E` | `#83828D` | Page background. Containers with lots of text: posts, notifications, comments. Default surface. |
| **Set 2** — dark blue | `#343651` | `#83828D` | Cards that are themselves interactive: project cards, clickable cards. |
| **Set 3** — solid blue | `#606684` | `#AFB2C1` | Profile sections, top-of-page cards. The "lifted" surface. |
| **Set 4** — highlighted | `#65625D` | `#B3B1AD` | Highlighted posts that need to draw attention. Warmer than the others on purpose. |

Foreground text on any set: `#FFFFFF`.

### 1.2 Highlights

For badges, callouts, toast strips, light-on-dark emphasis — not full accents,
not container surfaces. They live on top of set 1 / set 2.

| Token | Hex | Notes |
| --- | --- | --- |
| **Highlight** | `#F4EBB9` | Soft golden yellow. |
| **Secondary highlight** | `#FEFCE7` | Near-white cream — used as a quieter alternative to `Highlight`. |

### 1.3 Accents

Six pastels, used for branded surfaces, illustrations, status colors, and any
"colored area" decision. Reach for these before inventing new HSL tints.

| Token | Hex | Common role |
| --- | --- | --- |
| **Accent 1** — peach | `#FFD598` | Warm, gentle emphasis. |
| **Accent 2** — yellow | `#FFE564` | Stars, special-action button fill, "important". |
| **Accent 3** — salmon | `#FF8D9D` | Warn / destructive accents. |
| **Accent 4** — blue | `#95DBFF` | Cool emphasis. |
| **Accent 5** — lilac | `#EBB7FF` | Default primary accent. |
| **Accent 6** — mint | `#81FFFF` | Cool emphasis, "online"/"active" states. |

### 1.4 Special cases

When a surface needs to disappear into another set's background (e.g. a card
embedded inside a set 1 area that shouldn't visually separate), use the same
hex as the surrounding background — set 1, set 2, or set 3 background — rather
than going transparent or inventing a new color.

### 1.5 Mapping to CSS variables

These tokens already exist in
[_variables.scss](../app/assets/stylesheets/config/_variables.scss). When you
write SCSS, reference the variable, not the hex.

| Doc token | CSS variable | Status |
| --- | --- | --- |
| Set 1 background `#08061E` | `--color-space-bg` | Currently defined as `hsl(245, 55%, 8%)` — approximately the same but not pixel-exact. Prefer using the variable; if a pixel-exact match is needed, use the hex directly. |
| Accent 1 peach `#FFD598` | `--color-brand-peach` | ✓ exact |
| Accent 2 yellow `#FFE564` | `--color-brand-yellow` | ✓ exact |
| Accent 3 salmon `#FF8D9D` | `--color-brand-salmon` | ✓ exact |
| Accent 4 blue `#95DBFF` | `--color-brand-blue` | ✓ exact |
| Accent 5 lilac `#EBB7FF` | `--color-brand-lilac` | ✓ exact |
| Accent 6 mint `#81FFFF` | `--color-brand-mint` | ✓ exact |
| Highlight `#F4EBB9` | _(no variable yet)_ | `--color-brand-cream: #FFF8D5` is close but not the same. Add `--color-brand-highlight` when first needed. |
| Secondary highlight `#FEFCE7` | _(no variable yet)_ | `--color-brand-off-white: #FFFCF4` is close but not the same. Add `--color-brand-highlight-secondary` when first needed. |
| Set 2/3/4 backgrounds + secondary foregrounds | _(no variables yet)_ | Add `--color-set-N-bg` / `--color-set-N-fg-secondary` when first needed. |

---

## 2. Typography

Two type families:

- **Exo 2** — the workhorse. All body, headings, labels.
- **Playfair Display** — italic emphasis variant for **Title** and **Title 2**.
  Used to add a touch of editorial weight to the largest type. Always bold
  italic.

### 2.1 Scale

| Role | Font | Size | Weight | Casing | Use for |
| --- | --- | --- | --- | --- | --- |
| **Title** | Exo 2 _or_ Playfair Display _bold italic_ | 70px | Bold | normal | Hero-level page titles (one per page max). The Playfair variant is the editorial flourish; Exo 2 is the plain variant. Pick one per title. |
| **Title 2** | Exo 2 _or_ Playfair Display _bold italic_ | 56px | Bold | normal | Secondary page titles, large section titles, modal titles. Same Exo/Playfair pairing as Title. |
| **Heading** | Exo 2 | 40px | Bold | normal | Section headings inside a page. |
| **Small heading** | Exo 2 | 22px | Bold | **ALL CAPS** | Subsection / group labels above lists or cards. The all-caps cue distinguishes it from Body at the same size. |
| **Body** | Exo 2 | 22px | Regular | normal | Default page text. |
| **Label** | Exo 2 | 16px | Regular | normal | Form labels, captions, metadata, fine print. |

### 2.2 Notes

- **Italics for emphasis at title sizes only.** Playfair Display is bold-italic
  for Title / Title 2 — don't introduce Playfair at smaller sizes, and don't
  italicize Exo 2 as a substitute. The italic moment is reserved.
- **Playfair fallback.** If Playfair Display isn't loaded in a given context,
  fall back through `"Times New Roman", Georgia, serif` so the italic feel
  survives (this is already the pattern in `_hero.scss` and the sidebar's
  active-nav label).
- **Exo 2 fallback.** `"Exo 2", sans-serif` — the system default sans is fine
  if Exo 2 is missing.
- **Line height.** `--line-height-headers: 1.1` for headings, `normal` for
  body. Defined in `_variables.scss`.
- **Mobile.** Body shrinks to 16px below 600px viewport width. See the
  `@media (max-width: 600px)` block in `_variables.scss`. The landing scale
  (`--font-display`, `--font-h2`, `--font-h3`, `--font-body`, `--font-subtitle`)
  is fluid-clamped — use those tokens on landing pages instead of the fixed
  scale above.

---

## 3. Containers

All containers use an **8px corner radius**. Four standard "set" variants plus
one special case.

| Variant | Border | Background | Use for |
| --- | --- | --- | --- |
| **Main container** (set 1) | 2px | `#08061E` | Posts, notifications, comments — anywhere with a lot of text. Default container. |
| **Dark blue container** (set 2) | 2px | `#343651` | Project cards and other clickable cards. The presence of a border signals "you can click me." |
| **Solid blue container** (set 3) | _none_ | `#606684` | Profile sections, top-of-page cards. No border because they sit above the page surface visually. |
| **Highlighted container** (set 4) | 2px | `#65625D` | Highlighted posts that need to stand out — warmer tone than the blues. |

**Borders.** When a set has a 2px border, the border color matches the
container's secondary-foreground (the muted text color) — this gives the edge
the same "muted" feel as the supporting text inside.

**Special case — invisible container.** When a container shouldn't visually
separate from its parent surface, set its background to the same hex as the
surface it's sitting on (set 1, 2, or 3). Don't use `transparent` — pick the
matching hex explicitly so the container still renders predictably when
copy-pasted or moved.

---

## 4. Buttons

Three button types: **small action**, **large action**, **special action**.
Each has variants and states. All three use **fully rounded corners**
(pill shape — `border-radius` = half the height).

### 4.1 Small action buttons

- **Text:** 16px, bold.
- **Border:** 2px.
- **Padding:** 16px horizontal, 3px vertical.
- **Used for:** Edit profile / Edit post, Save and discard on profile / posts,
  confirmation popups.

**Variants:**

- **Primary action** — filled with the muted set color.
- **Secondary action** — outlined.
- **Destructive action** — uses `accent 3` salmon to signal warning. Reserve
  for irreversible deletes (delete post, delete account).

**States** (all three variants):

- **Normal** — base appearance.
- **Hover** — slightly lighter / inverted fill (no symbol movement at this
  size).
- **Pressed** — fill saturates briefly.
- **Disabled** — 50% opacity over the normal state.

Small buttons are designed against set 1 / set 2 backgrounds. If you're
placing one on set 3 or set 4, eyeball contrast and adjust.

### 4.2 Large action buttons

- **Text:** 22px, bold.
- **Border:** 2px.
- **Padding:** ≥32px horizontal _or_ fill the row horizontally; 12px vertical.
- **End icon:** optional. When present, it moves right on hover.
- **Used for:** the primary action on a page or modal — "Post a devlog",
  "Create new ship", external link buttons like "Try project" / "See source
  code".

**Variants:**

- **Primary action** — filled with `accent 2` yellow (`#FFE564`). The "do the
  thing" button.
- **Secondary action** — outlined / muted. Lives next to a primary on a form.

**States:** Normal · Hover · Pressed · Disabled (50% opacity). On hover, the
end icon translates right by a few pixels — the button itself doesn't move,
just the trailing icon.

### 4.3 Special action button

- **Shape:** the button body sits inside a **star symbol** outline — the
  rounded-rect button overlaps a star shape so a few of the star's points peek
  out behind the pill.
- **Text:** 22px, bold.
- **Border:** 2px transparent _plus_ a 2px yellow ring — i.e. the pill has a
  transparent stroke and the underlying star is yellow (`accent 2`).
- **Padding:** ≥32px horizontal, 12px vertical.
- **End icon:** required (the symbol that "moves right" on hover, same as
  large buttons).
- **Used for:** big, important, and (ish-)irreversible actions. New post,
  submitting a rating, "Continue" in forms. The star is the cue that this
  button is the climactic action of a flow — don't sprinkle it on minor
  buttons.

**States:**

- **Normal** — star + pill at rest.
- **Hover** — **star rotates 72° clockwise** (= one fifth of a turn — one
  point of the star) and the end icon translates right.
- **Pressed** — star locks at the hover position; subtle compression.
- **Disabled** — 50% opacity.

### 4.4 Approved button backgrounds

Each button group is designed against specific set backgrounds. The Figma
labels the approved background swatches under each group as "For these
backgrounds/containers". The short version: assume **small buttons** and
**large secondary buttons** are tuned for **set 1 / set 2**. The **large
primary** (yellow) and **special action** stay legible on any set because
their fill is bright. If you put a small button on set 3 or set 4, retest
contrast.

---

## 5. Forms and inputs

The Figma is sparse here — only one field type is shown.

### 5.1 Field pattern

- **Layout:** label on the left, input on the right (horizontal pair).
- **Label:** Label type token (Exo 2 16px regular).
- **Help icon:** a small `?` circle sits immediately after the label when the
  field has a tooltip / hint. Hover or focus reveals the hint.
- **Input:** rounded-corner box, set against set 1 background, with a thin
  muted border. Inherits its border color from the surrounding set's
  secondary-foreground.

When in doubt about a form pattern that isn't in the Figma yet (radio groups,
selects, multi-line text), pick the pattern that's most consistent with this
one — labels on the left, inputs filling the remaining row width, set-1 fills,
muted borders — and document the choice back into this section.

---

## 6. Spacing and radii

- **Container radius:** 8px (everywhere except buttons).
- **Button radius:** fully rounded (= half the button's height).
- **Border weight:** 2px when a border is present.
- **Spacing tokens:** use `--space-*` from `_variables.scss`
  (`--space-xxxs` 4px → `--space-xxxxl` 64px). The button paddings above
  (`16px`, `32px`, `12px`, `3px`) don't all map cleanly to the scale — they're
  baked into the button component styles rather than picked freshly per usage.

---

## 7. House rules (TL;DR for fast lookups)

1. Never use pure black. Use set 1 background `#08061E`.
2. Pick colors from the palette. If you need a new color, stay pastel.
3. Page background defaults to set 1 (`#08061E`). Reach for sets 2–4 for
   containers within the page.
4. Body text: white (`#FFFFFF`). Muted text: the secondary-foreground of the
   set you're sitting on.
5. Exo 2 everywhere; Playfair Display bold-italic only for Title / Title 2 as
   editorial emphasis.
6. Containers: 8px radius. Buttons: fully rounded.
7. Yellow `#FFE564` is reserved for the special-action star and large primary
   buttons. Don't paint a regular surface with it.
8. Salmon `#FF8D9D` signals warn/destructive. Use it for that, not decoration.
9. Disabled = 50% opacity over the normal state — don't invent a separate
   disabled color.
10. CSS lives in `app/assets/stylesheets/`, all selectors follow BEM
    (`block / block__element / block--modifier`). Reference design tokens via
    `var(--token-name)`, not inline hex.
