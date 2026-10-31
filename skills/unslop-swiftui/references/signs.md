# Signs of slop

Go through every group and note each sign you find with the file and line where it lives. Each line pairs the sign with its fix.

## Contents

- Structure and navigation
- Liquid Glass and materials
- Color and surfaces
- Type
- Symbols
- Spacing
- Copy
- Components
- Visuals
- Motion
- Accessibility
- Template look, the defaults to check after the passes

## Structure and navigation

- A custom tab bar, an `HStack` of buttons in a `Capsule` pinned to the bottom of a `ZStack`, often with emoji and a gradient on the selected tab → `TabView` with `Tab` items and SF Symbols
- A hand-built header, an `HStack` with a big `Text` and icons, plus `.navigationBarHidden(true)` or `.toolbar(.hidden)` → `.navigationTitle` and `.toolbar` in a `NavigationStack`
- `NavigationView` → `NavigationStack`, or `NavigationSplitView` on iPad and Mac
- `.onTapGesture` on a `Text`, an image or a row that acts as a button → `Button` or `NavigationLink`
- A `ScrollView` with a `VStack` of hand-styled rows where a list fits → `List`, or `Form` for settings and input
- A custom modal, a `ZStack` with a dimmed color and a floating card → `.sheet`, `.alert` or `.confirmationDialog`
- A hand-built segmented control, toggle or search field → `Picker` with `.segmented`, `Toggle`, `.searchable`
- A fake dropdown, like a pill that says `This week ▾` → `Menu` or `Picker` with `.menu`
- Layout computed from `UIScreen.main.bounds`, or fixed widths like `.frame(width: 390)` → adaptive layout
- `.ignoresSafeArea()` on the content → only on the background
- Bars colored with `.toolbarBackground(Color.purple)`, `UINavigationBarAppearance` or a solid view behind them → the system bars, which are Liquid Glass since iOS 26
- Every action as a large button in the content, three or more stacked → the task's verb in the toolbar or bottom bar, the rest in a `Menu`
- A button with an empty handler promoted to the primary action → a quiet control and a question for the user
- Settings or the account as a tab → a toolbar button
- A screen action in the tab bar accessory → the toolbar, or next to the content it acts on
- A greeting, a pep talk or a stat leading the screen while the answer to the task sits below → the answer first

## Liquid Glass and materials

- `.glassEffect()` on every card, row or text block → plain grouped surfaces, glass only on controls floating over content
- Glass on glass, a glass button in a glass card in a sheet → one glass layer
- Tinted glass everywhere, like `.glassEffect(.regular.tint(.purple))` → untinted, with tint only on the one prominent action
- Glassmorphism cards, `.ultraThinMaterial` with a white stroke and a colored shadow → a system grouped surface
- Material stacked on a flat color where nothing shows through → a solid semantic background
- Glass elements side by side without a `GlassEffectContainer` → group them so they blend and morph together

## Color and surfaces

- `LinearGradient(colors: [.purple, .blue])` or similar hue to hue gradients on backgrounds, cards, buttons or the selected tab → system backgrounds, accent only where it means something
- Gradient text through `.foregroundStyle(LinearGradient(...))` on titles, figures or the logo → `.primary`
- Colored glows like `.shadow(color: .purple.opacity(0.6), radius: 20)` or a shadow on an emoji → none, or a soft neutral shadow on something that floats
- Blurred colored circles behind content, like `Circle().fill(.purple).blur(radius: 90)` → remove
- `Color(hex:)` helpers and `Color(red:green:blue:)` all over the views → semantic colors and named colors in the asset catalog
- Five near identical text colors, like `.white.opacity(0.7)`, `0.65` and `0.6` → `.primary`, `.secondary` and `.tertiary`
- Hard-coded `.white` or `.black` text → `.primary`, which adapts to the appearance
- `.preferredColorScheme(.dark)` forced so the gradient works → both appearances
- Neon or gradient strokes like `.stroke(LinearGradient(...))` → none, or the system separator
- Every element tinted, so nothing stands out → the accent on what people can tap, the selection and status
- The accent on text or figures that cannot be tapped → `.primary` or `.secondary`
- System green or orange as small text on white → primary or secondary text next to a colored symbol
- Green and red as the only signal of a change → color plus a sign or a symbol

## Type

- Point sizes like `.font(.system(size: 28))` → text styles like `.title`
- `.black` or `.heavy` weights on titles, labels and figures → the weight of the text style, `.semibold` for rare emphasis
- `.textCase(.uppercase)` with `.tracking(2)`, or uppercase string literals like `TOTAL BALANCE` → `Balance`, in the app's case style, no tracking
- Negative `.kerning` or `.tracking` on small text → none
- `.lineLimit(1)` with `.minimumScaleFactor(0.5)` to make running text fit → let it wrap, or give it room
- `design: .rounded` on some views, the default on others, and a random custom font → one design chosen for the feeling
- Numbers in mixed formats, like `$12,480.5` next to `$860.00`, `-$23.1` or `07` → one `FormatStyle`, `.monospacedDigit()`
- Dates in mixed formats, like `Oct 28`, `10/27/2026` and `Yesterday` in one list → one date style through `FormatStyle`
- `.italic()` for emphasis → the text style or `.secondary`

## Symbols

- Emoji as icons, like `Text("🏠")`, `Text("💸 Spent")`, `Text("🔔")` or `🔥 7` → SF Symbols in a `Label`, or nothing
- `Image(systemName:).resizable().frame(width: 24, height: 24)` for an interface icon → `.font` and `.imageScale`
- Every symbol a different color, like `.orange`, `.pink` and `.mint` per row → the text role or the tint
- Hue to hue gradient-filled symbols → one color, `.hierarchical` for depth, or the system's single-color gradient on large symbols
- Mixed weights and sizes of symbols on one screen → symbols that follow their text
- Icon-only buttons with no title for VoiceOver → `Button("Title", systemImage:)` with `.labelStyle(.iconOnly)`
- `sparkles` for anything AI → remove, or a plain symbol that explains the action

## Spacing

- Odd values like `.padding(13)`, `.padding(.top, 7)`, `.padding(21)` or `HStack(spacing: 11)` → the system default or the 4 point scale
- `Spacer().frame(height: 37)` and `.offset` nudges → stack spacing and alignment
- Rows in one list with different paddings → one height, one inset
- Groups that sit closer to their neighbours than to their own items → smaller spacing inside groups, bigger between them
- Uneven padding inside sibling cards → one padding
- Fixed `.frame(height:)` on text containers → `minHeight` or nothing
- A bottom overlay with a guessed `.padding(.bottom, 120)` on the scroll content → `.safeAreaInset(edge: .bottom)` or the system tab bar

## Copy

- Greeting headlines like `Welcome back, Alex! 👋` → the place or period as the navigation title
- Pep talk subtitles like `Let's crush your money goals today!!` → remove, or one plain line of real information
- Exclamation marks everywhere, `!!`, or any in errors → plain statements, an occasional one only in a brand voice
- Changes without a reference, like `+12%!! 🚀` → the bare `12%` until the user says what it compares to, then `12% more than September`
- Wordy placeholders, like `Search anything...` → `Search`
- Hype words like supercharge, seamless, unlock, magic, optimize → what the thing actually does
- `Oops!`, `Something went wrong` and an `OK` button on an alert that asks for a choice → what happened, what to do, and a button that names the result
- Numbers built with string concatenation or `String(format:)`, and plurals like `1 items` → `FormatStyle` and the String Catalog
- Inconsistent capitalization, `Add expense` on one button and `Save Changes` on the next → title case on buttons, menu items and alert buttons, one style per element type elsewhere
- Fake looking data, like `$123,456` or `[X]` → plausible numbers

## Components

- Glowing capsules for counts, plans or status → quiet `.secondary` text, a small status dot, or `.badge(_:)` for what needs attention
- `PRO`, `New ✨` and `Beta 🚀` badges → remove, or one quiet text badge
- Bar charts drawn from `RoundedRectangle`s in an `HStack` → Swift Charts
- Rainbow bars, gradient bars, glowing bars or uppercase day labels → color that encodes one thing, one highlighted series over gray or one fixed color per category, and the system axes
- Sparklines, tallies or mini bars added to every stat card → the number, its label and its change
- Equal cards side by side, each with the same layout → one main figure or chart, compact stats, varied widths
- A custom `ButtonStyle` with a gradient, a glow and a `1.1` scale → `.borderedProminent`, `.bordered` or `.glassProminent`
- `RoundedRectangle(cornerRadius:style: .circular)` and the deprecated `.cornerRadius(_:)` → continuous corners with `.clipShape(.rect(cornerRadius:))`
- Inner and outer corners that do not nest → inner equals outer minus padding, or `ConcentricRectangle`
- Everything a capsule, from cards to search fields → capsules for buttons and controls only
- An empty state that is a blank screen or a `Text("No data")` → `ContentUnavailableView` with an action
- A shimmer animation for loading → `.redacted(reason: .placeholder)` or `ProgressView`
- An onboarding carousel of five pages with blobs → no tour, TipKit tips in context, or one skippable welcome page

## Visuals

- Glossy 3D blobs, orbs, liquid chrome or a purple nebula → the product's own content, or one concrete metaphor in the right place
- Robots, glowing brains, circuit lines or holograms for anything AI → remove, or show what the AI actually produces
- Text, fake buttons or a fake logo baked into an image → real `Text` in the view, an image without text
- An image with a hard edge on a background of a different color → an image made for the background, or masked into it
- An app icon that is a gradient tile with a sparkle → a note in the report with one simple glyph idea from the product

## Motion

- `.repeatForever` pulses, breathing scales or rotating badges on things that are not live → static
- Content flying in on `.onAppear` with offsets from different sides → content in place
- Overshooting springs like `.spring(response: 0.3, dampingFraction: 0.4)` on simple UI → `.smooth` or `.snappy`
- `.scaleEffect(1.08)` on the selected item or on press → the system selection, a 0.97 scale on press at most
- `.animation(.default)` without a value → `.animation(_:value:)` scoped to the change
- Parallax and offsets driven by `GeometryReader` while scrolling → static layout
- `.rotation3DEffect` card tilts → remove
- Haptics on every tap → `.sensoryFeedback` on meaningful events only
- Motion that ignores Reduce Motion → a crossfade when `accessibilityReduceMotion` is on

## Accessibility

- Fixed font sizes, so nothing grows in the `-ax` snapshot → text styles and `@ScaledMetric`
- Rows that clip or overlap at large text sizes → reflow to vertical stacks
- Large figures that break inside the number at large text sizes, like `$12,4` over `80.50` → `.lineLimit(1)` with `.minimumScaleFactor(0.6)`
- Three or more stats in a row on iPhone, so figures wrap → two to a row, the rest as list rows
- A chart with a fixed height, whose plot shrinks to a sliver as its axis labels grow → a height from `@ScaledMetric(relativeTo: .caption)` and shorter labels at accessibility sizes
- Icon-only buttons without a name, emoji read aloud by VoiceOver → titles and decorative images
- Low contrast, like gray text on purple → semantic colors that pass 4.5 to 1
- Tap targets smaller than 44 by 44 points → larger frames or `.contentShape`
- `.padding(.left)` and `.offset(x:)` for direction → leading and trailing

## Template look

These are not slop, but they are what a cleaned up screen falls back to when nobody made a decision. Watch for them after the passes, and treat any other default the result fell back on the same way.

- A cream or off-white background behind every screen, like `Color(red: 0.98, green: 0.96, blue: 0.92)` → `Color(.systemBackground)` or the grouped background, with warmth carried by the accent and one moment
- An italic or serif accent word inside a title, like `Text("Your money, *simplified*")` → one plain title in one style
- Numbered section labels, like `01`, `02` and `03` or `01 — Overview` above each section → the section's name as a plain header, or no header when the content speaks for itself
- `.monospaced` labels, captions and meta, often small and uppercase → the interface's own design, with mono only for code and identifiers
- A default `List` with the default blue tint on a product whose world is warm or bright → an accent from the world and one moment
- The Settings app look for every screen, rows of colored icon tiles → icon tiles only where the screen is settings
- A title that would fit another app if you swapped the name → say what this product does, with its own nouns
- Every product getting the same layout, type design and tint → let the direction choose

---

Adapted from unslop by Damir Sokolovsky ([@heydamir](https://x.com/heydamir)), CC BY 4.0, rewritten for SwiftUI. Keep this credit in copies and adaptations.
