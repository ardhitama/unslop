# System values

Values for each pass. Two kinds live here. System values, like the text styles, semantic colors and control styles, come from Apple, so use them as they are. Starting values, like the spacing scale, the corner radii, the motion durations and the haptic map, are this skill's taste for what the system leaves open. When the project already has a good design system, keep its values and only fix how they are used. Let the direction move any starting value.

## Text styles

iOS and iPadOS at the default text size. Every style scales with Dynamic Type, so these are the base, not fixed sizes.

| Style | Size | Leading | Weight | Use |
| --- | --- | --- | --- | --- |
| `.largeTitle` | 34 | 41 | Regular | Large navigation titles, one hero figure |
| `.title` | 28 | 34 | Regular | Screen-level headings in content |
| `.title2` | 22 | 28 | Regular | Section headings, a card's main figure |
| `.title3` | 20 | 25 | Regular | Smaller headings |
| `.headline` | 17 | 22 | Semibold | Row titles, emphasized labels |
| `.body` | 17 | 22 | Regular | Default text |
| `.callout` | 16 | 21 | Regular | Text next to controls |
| `.subheadline` | 15 | 20 | Regular | Secondary lines in rows |
| `.footnote` | 13 | 18 | Regular | Footers, meta |
| `.caption` | 12 | 16 | Regular | Captions, chart labels |
| `.caption2` | 11 | 13 | Regular | The smallest text, use rarely |

macOS uses smaller sizes, with body at 13, and watchOS and visionOS have their own tables. Use the same style names everywhere and let each platform size them.

### Type designs

| Feeling | Design | Use |
| --- | --- | --- |
| Precise, calm, technical | `.default` | The interface of most apps |
| Friendly, playful, physical | `.rounded` | Interface and figures, fitness, habits, kids, home |
| Editorial, literary, crafted | `.serif` | Large titles and reading text, never small labels or buttons |
| Code, data, meta | `.monospaced` | Code, IDs, figures in tables, small meta |

- One design for the interface plus at most one partner, like `.rounded` figures in a `.default` interface or a `.serif` large title.
- `.monospacedDigit()` keeps figures aligned without switching the whole font to mono.
- Width variants, `.width(.condensed)`, `.width(.compressed)` and `.width(.expanded)`, are for one display moment.
- A custom figure size: `@ScaledMetric(relativeTo: .largeTitle) private var figure = 48`, then `.font(.system(size: figure, weight: .semibold, design: .rounded))`.
- A brand typeface: `.font(.custom("Brand", size: 17, relativeTo: .body))`.
- No `.tracking` or `.kerning` on any of these. San Francisco adjusts tracking by size on its own.

## Spacing

The system default comes first. `.padding()` without a value, the default spacing of `VStack` and `HStack`, and the insets of `List` and `Form` adapt to the platform. They do not grow with the text size.

For your own values, a 4 point scale as a starting value:

4, 8, 12, 16, 20, 24, 32, 40, 48, 64

- Inside a control or a tight group: 4 to 8
- Between related items, like a title and its subtitle: 2 to 6
- Between groups, like a label and its list, or two cards: 12 to 20
- Between sections: 24 to 40
- Screen margins: let `List` and `Form` set them, since they vary by device. On iOS, `.scenePadding()` gives the same 16 points as `.padding()`
- Card padding: 16 to 20
- Tap targets: at least 44 by 44 points, which system rows and controls already meet

Sizes that sit next to text grow with it through `@ScaledMetric`, like `@ScaledMetric private var iconBox = 28`.

## Semantic colors

| Role | SwiftUI | UIKit name |
| --- | --- | --- |
| Primary text | `.primary` | `label` |
| Secondary text | `.secondary` | `secondaryLabel` |
| Tertiary text, placeholders | `.tertiary` | `tertiaryLabel` |
| Disabled, faint | `.quaternary` | `quaternaryLabel` |
| Plain background | `Color(.systemBackground)` or `.background` | `systemBackground` |
| Grouped background | `Color(.systemGroupedBackground)` | `systemGroupedBackground` |
| A card on a grouped background | `Color(.secondarySystemGroupedBackground)` | `secondarySystemGroupedBackground` |
| A raised area on a plain background | `Color(.secondarySystemBackground)` | `secondarySystemBackground` |
| Fills for small controls and tracks | `.fill.secondary`, `.fill.tertiary` | `secondarySystemFill`, `tertiarySystemFill` |
| Separator | `Divider()` or `.separator` | `separator` |
| Accent | `.tint` | `tintColor` |

- Apply text roles with `.foregroundStyle(.secondary)`. On glass and materials the system makes them vibrant on its own.
- Brand colors live in the asset catalog with Any, Dark and High Contrast variants, and are used as `Color("Brand")` or a generated symbol like `Color.brand`.
- Muted text is for meta and captions only. Body text uses primary or secondary.
- Contrast: 4.5 to 1 for text up to 17 points, 3 to 1 for text of 18 points and up or bold text. Aim for 7 to 1 for small text in custom colors on dark backgrounds. Check with Increase Contrast on.
- The system colors adapt to both appearances, but as text on white, green, orange, yellow, mint and cyan reach only about 2 to 1. Use them for fills, bars and symbols, and keep text primary or secondary.

## Accent

- Keep a real brand color as the `AccentColor` asset. A violet to blue gradient is slop, not a brand color, unless the user says otherwise.
- Without a brand color, take it from the world. Warm worlds suit amber, coral or ember orange. Cool worlds suit cobalt, teal or a clear sky blue. Natural worlds suit moss or sage. Avoid the purple to blue family unless the brand really is purple.
- The system colors, `.orange`, `.teal`, `.indigo`, `.mint` and the rest, are a good start since they adapt to both appearances. Shift one in the asset catalog when the world needs a more specific hue, and give it a darker light-mode variant when it is used as text or on a tinted button.
- The accent is used judiciously, on what people can tap, the selection and status, like an unread badge or the selected tab.

## Corners

Starting values, continuous in every case.

| Element | Radius |
| --- | --- |
| Tag, keycap, small chip | 6 to 8 |
| Input, small card, image thumbnail | 10 to 12 |
| Card | 16 to 24 |
| Large panel or card shaped object | 20 to 28 |
| Buttons, bars, sheets, list sections | The system's own |

- Always continuous. `RoundedRectangle(cornerRadius:)` and `.rect(cornerRadius:)` default to `.continuous`.
- Nested radius: inner = outer − padding, never below 4. A 24 point card with 16 points of padding holds items with an 8 point radius.
- Since iOS 26, `ConcentricRectangle()` inside a view with `.containerShape(.rect(cornerRadius: 24))` computes the inner corners for you, and follows the device's corners at the screen edge.
- `.buttonBorderShape(.capsule)` or `.roundedRectangle` sets a button's shape. Capsules are for controls, not for cards.

## Buttons and controls

| Role | Style | Notes |
| --- | --- | --- |
| The one primary action in content | `.borderedProminent` | `.controlSize(.large)` for a hero action |
| Secondary action | `.bordered` | |
| Quiet action, in rows and toolbars | `.borderless` or `.plain` | |
| Floating control over content, iOS 26 and later | `.glass` | |
| Primary floating action, iOS 26 and later | `.glassProminent` | Takes the tint |
| Destructive | any style with `role: .destructive` | |

- Control sizes: `.mini`, `.small`, `.regular`, `.large`, `.extraLarge`. Set once on a container with `.controlSize`. `.extraLarge` differs from `.large` only on visionOS.
- One prominent action per toolbar, and at most two prominent buttons in a view.
- A custom `ButtonStyle` keeps the press honest: `.opacity(configuration.isPressed ? 0.7 : 1)` or `.scaleEffect(configuration.isPressed ? 0.97 : 1)`.

## SF Symbols

- Size with the font they sit next to, adjust with `.imageScale(.small)`, `.medium` or `.large`.
- Weight follows the font. Set it with `.fontWeight` only when a symbol stands alone.
- Rendering: `.monochrome` by default, `.hierarchical` for depth in one color, `.palette` for two chosen colors, `.multicolor` for symbols with natural color.
- In rows, give symbols one frame width so labels align, like `.frame(width: iconBox)` with a scaled `iconBox`.
- `.symbolEffect(.bounce, value:)` plays once on an action. `.contentTransition(.symbolEffect(.replace))` swaps one symbol for another.

## Depth

- Grouped surfaces on a grouped background give depth without shadows.
- The navigation layer is glass and floats on its own.
- A floating object, like a card shaped object over content: `.shadow(color: .black.opacity(0.12), radius: 16, y: 8)` in light, a lower opacity or nothing in dark.
- Small raised things: `.shadow(color: .black.opacity(0.06), radius: 2, y: 1)`.

## Motion

The springs are Apple's. The pairings and numbers below are starting values.

| Use | Animation |
| --- | --- |
| Most state changes | `.smooth`, or plain `withAnimation { }` |
| Quick feedback, toggles, selection | `.snappy(duration: 0.25)` |
| Things that enter or move far | `.smooth(duration: 0.45)` |
| Direct manipulation, a real celebration | `.bouncy` |
| Changing numbers | `.contentTransition(.numericText(value:))` |
| Content swapped in place | `.transition(.blurReplace)` |
| Card to detail | `.navigationTransition(.zoom(sourceID:in:))` |

- Stagger between items, when there is a reason to stagger: 0.03 to 0.05 seconds, at most six items.
- Press scale: 0.97. Movement on enter: 8 to 12 points.
- With Reduce Motion on, replace movement, zooms and blurs with `.opacity`, including `.blurReplace`.

## Haptics

A starting map from events to the system's feedback types.

| Event | Feedback |
| --- | --- |
| A goal reached, a task done | `.success` |
| A problem that needs attention | `.warning` or `.error` |
| A value snapping in a picker-like control | `.selection` |
| Something landing in place | `.impact(weight: .light)` |

Use `.sensoryFeedback(_:trigger:)` and only for these moments.

## Platforms

- **iPhone.** Tab bar for top-level places, large titles, the primary action in the toolbar or bottom bar. On iPhone Duo the outer display puts the tab bar and toolbars on the side and the inner display is regular width, so build to resize with size classes and no fixed widths.
- **iPad.** `NavigationSplitView` or `.sidebarAdaptable` tabs, an `.inspector` for detail, keyboard shortcuts, pointer hover, and every size from Slide Over to full screen.
- **Mac.** Sidebar, toolbar and menus. Every command in the menu bar through `.commands`, shortcuts only for the most frequent ones, a `Settings` scene for preferences, smaller controls, and windows people resize. On a Mac with a touch display, targets grow without changing density.
- **Apple Watch.** One glance answers the task, in interactions under a minute. Large figures, the Digital Crown to scroll, and a full-screen color or material when it carries meaning.
- **Apple Vision Pro.** Windows of glass with no background of your own, ornaments for controls, targets of at least 60 points, depth used for meaning, and comfortable placement in the field of view.

---

Adapted from unslop by Damir Sokolovsky ([@heydamir](https://x.com/heydamir)), CC BY 4.0, rewritten for SwiftUI. Keep this credit in copies and adaptations.
