---
name: unslop-swiftui
description: Turns vibecoded, AI-looking SwiftUI into an app that feels designed the Apple way, native to the platform and with its own character. Applies Apple's design principles and the Human Interface Guidelines, moves custom chrome onto system components including Liquid Glass, then refines the screen in eleven passes from structure to accessibility. Use when the user asks to unslop, polish, clean up, review or redesign a SwiftUI screen, or to make it feel native or "like Apple made it", and when SwiftUI code shows AI tells like hue gradients and colored glows, gradient text, emoji labels, fixed font sizes, hand-built tab bars or headers, or glass on every card. Works for iOS, iPadOS, macOS, watchOS and visionOS.
license: CC-BY-4.0
metadata:
  author: Damir Sokolovsky
  adapted-by: ardhitama
  original: https://github.com/heydamir/unslop
  x: https://x.com/heydamir
  site: https://heydamir.design/unslop
---

# Unslop for SwiftUI

Adapted from unslop by Damir Sokolovsky ([@heydamir](https://x.com/heydamir)), who started the Unslopping series on X. This version is rewritten for SwiftUI and Apple's way of designing products. It is licensed under CC BY 4.0, so keep this credit in any copy or adaptation.

Vibecoded SwiftUI fails in the same predictable ways. The model builds a web page in Swift. A purple gradient fills the background, a hand-built capsule replaces the tab bar, every card glows, every label has an emoji, padding is whatever number came out that day, and fixed font sizes break the moment someone turns up their text size. Unslopping fixes the craft and keeps the product. Every feature stays reachable. What changes is that every view, value, word and image becomes deliberate.

On Apple platforms the first move is subtraction. People already know how a navigation stack, a list, a sheet, a toolbar and a tab bar behave. A system component brings Dynamic Type, dark mode, accessibility, keyboard and pointer support, right-to-left layout, Liquid Glass and every future OS update for free. A hand-built copy brings none of that and looks dated a year later. So the screen moves onto the platform first, and then the content gets the care.

Removing slop is only half the job. Apple's principles ask for more than a tidy screen: a clear purpose, and moments that make the product feel like itself. Those moments come from what the product shows, never from decoration.

Work like a designer doing a redline pass, one layer at a time, across the whole screen.

Hold the result to the bar of Apple's own apps. Before you hand it over, look at it the way the most exacting designer you know would, the one who screenshots the single wrong thing and sends it back with "what is this?". A symbol sitting off its text, a figure wrapping at a large text size, two edges a point apart, the accent on something nobody can tap. If you can picture that screenshot, you have found the next fix.

## How Apple designs a product

The Human Interface Guidelines rest on eight principles. Use them as the judgment behind every pass.

- **Purpose. Make something meaningful.** Ask what the screen is for and whether the design serves it. Focus on the most important features and make them great. Define what sets this product apart.
- **Agency. Let people do things their own way.** Get people straight to the task. Never lock them into a flow, and make any guided flow easy to skip. Let them undo instead of asking them to confirm.
- **Responsibility. Act in people's best interest.** Be clear about what the product does with their data. Ask for a permission when people use the feature that needs it, with a reason. Protect what is private on screen, like a balance.
- **Familiarity. Build on what people know.** Use system patterns, keep each behavior and appearance consistent, and give clear feedback when something happens.
- **Flexibility. Adapt to diverse contexts and needs.** Design for everyone from the start. Support every text size, input method, display and window size the platform has.
- **Simplicity. Be clear and direct.** Every element earns its place. Simplicity is not minimalism. Keep the important things close and let the rest fall away. Use exactly the words you need.
- **Craft. Care about every detail.** Precise wording, smooth motion, the press state, the empty state, and the screen at its largest text size.
- **Delight. Make it human.** Know the feeling the product should create and let it shape the design. Create defining moments, but never mistake delight for decoration.

Liquid Glass adds three goals for the interface itself. Hierarchy, so controls float above the content they serve. Harmony, so shapes and corners nest inside each other and the device. Consistency, so one design adapts across every window size and display.

When this skill says Apple does something, it comes from the HIG or from Apple's own apps. Values called starting values, like the spacing scale and the corner radii in [references/system.md](references/system.md), are this skill's taste. The direction or the project's own design system can move them.

## What good looks like

- **One clear subject.** Each screen has one thing that answers its task, like a figure, a chart, a photo, a map or a list. It reads first.
- **Familiar structure.** Someone who has never seen the app knows how to navigate it, go back, search and find the primary action.
- **Color that means something.** The accent marks what people can tap, what is selected, and status. Content gets color only when the color carries information, like one fixed color per category.
- **A defining moment, where the product has one.** A chart drawn with care, a card that looks like the real object, a route on a map. Settings and plain lists do not need one.
- **Works for everyone.** It holds up in dark mode, at the largest accessibility text size, with Increase Contrast and Reduce Transparency, with VoiceOver and Voice Control, and on every device size the app supports.
- **Real content, every state.** Sample data looks real. The screen also works when it is empty, loading, failing, or showing a very long name.

Which visual styles tend to work, and which fail, is in [references/visuals.md](references/visuals.md). Apps and finished screens to learn from are in [references/refs.md](references/refs.md), and code treatments like drawing an image in glyphs are in [references/effects.md](references/effects.md).

## Scope

A screen redesign owns the screen and its edges:

- How people arrive and where each element leads.
- Its states: empty, loading, error, and the first time with no history.
- Dynamic Type, VoiceOver and Voice Control.
- Localization: format numbers, dates and currencies from the locale, never hard code a currency.
- The privacy of what it shows. Use `.privacySensitive()` on balances and personal data.
- Any permission the screen needs, asked for when the feature is used, never at launch.

It does not build widgets, Live Activities, App Intents, Spotlight, Handoff, an onboarding flow, the app icon, sounds or App Store art. When the screen points to one of these, note the ones that would matter most in the report, so it stays about the screen. For example, a glance task that a widget would serve better, or an app icon that is slop.

## Run it

1. **Look at the screen.** Find the views that render it, the app's deployment targets and its asset catalog. Look at the screens around it too, where people arrive from and where each element leads. Judge what people see, not only the code.
   - With an Xcode project, run `${CLAUDE_SKILL_DIR}/scripts/sim.sh snapshot --name before` from the folder that holds the project. It builds the scheme for a simulator and saves light, dark and largest accessibility text size screenshots to `unslop/`. Add `--scheme`, `--project` or `--workspace` when there is more than one, and `--device` with an iPad's name from `xcrun simctl list devices available` for iPad. Numbers and dates follow the simulator's region, so pin it with `-- -AppleLocale en_US -AppleLanguages "(en)"` when it should match what the user sees. If it fails, read the error, since it usually names the fix.
   - If Xcode's MCP server is connected, its preview tool can render a `#Preview` instead, which is faster for one view.
   - A Mac app has no simulator. Run it and ask the user for a screenshot, or render the view's `#Preview`.
   - Only a screenshot or a design file? Rebuild the screen as one SwiftUI file with plausible sample data and a `#Preview`, matching it closely, and treat that as the original.
2. **Audit.** Go through [references/signs.md](references/signs.md) and list every sign you find, one line each with the file and line where it lives.
3. **Decide how much to change.** Read the audit honestly before planning anything.
   - **Heavy slop**, many signs across structure, color, type and symbols. Run the full process below.
   - **Light slop**, a screen that is mostly designed with a few signs left. Polish mode. Fix only what the audit found, keep the order of sections, take the direction from the existing brand, and keep the palette, type, layout and visual. Bigger ideas go into the report as suggestions, not changes.
   - **No slop.** Say so plainly and suggest only the small refinements that clearly help, with exact code. Apply them only if the user agrees. Never change a good screen just to make it different.
4. **Set the direction and stop.** Write the direction described below, and list the questions only the user can answer. Examples: what a figure compares to, what an empty button should do, whether a claim is real. Show the audit, the direction and the questions, and wait for the answer before editing, since changing the direction later means redoing everything. Skip the wait only when the user already said to just do it. Then keep the bare facts for anything unanswered and list it in the report.
5. **Fix in eleven passes, in order.** Finish a pass across the whole screen before starting the next. When nearly every line changes, plan the passes in order and then write the new view in one go, as long as every pass is applied. Structure comes first because it decides what is on the screen and in what order, and system containers bring their own spacing, type and materials. Spacing comes next because everything reads differently once the rhythm is right. Copy comes before type and layout because the length of a title decides its style and where it sits. Visuals and motion come late because they should fit a screen that already works without them. Accessibility comes last as a check of everything before it.
6. **Check.** Build, render the preview states from the checklist, run the checklist at the end of this file, snapshot again with `--name after` and compare with the audit list and the before screenshots. Answer the visual items from the screenshots, not from the code, since a modifier that reads right can still look wrong. Then look for the defaults in the Template look group of [references/signs.md](references/signs.md), which is what a cleaned up screen falls back to when nobody decided. Last, hold the after screenshot next to the closest Apple screen from the direction and name the one difference in quality, like hierarchy, density, spacing or how the subject reads, never in likeness. If yours is the busier, flatter or emptier one, that is the next fix. Anything still on the list gets fixed, and so does any other default the result fell back on that the list does not name yet.
7. **Review with a fresh eye, in a full run.** Hand a subagent the brief in [references/review.md](references/review.md) with only what it lists, never your plan, your audit or your reasons, since a reviewer who knows why something was done tends to agree with it. Fix the findings that hold up and keep the rest for the report with why they stand. Polish and no-slop runs skip this step. If you cannot start a subagent, say in the report that no fresh-eye review ran.
8. **Report** the direction, a few lines per pass about what changed, every section you moved and where, the open questions, any image prompt you wrote, out of scope notes, the reviewer's findings and what you did with each, and what you did not check, like a Mac or watch layout you did not render or VoiceOver you did not run. A check you did not run is listed as not checked, never as passed.
9. **Record, when asked or when the user wants something to share.** Build the story view and record the video described in [Story video](#story-video).

Keep a run quick. Snapshot at most three times, each run of `sim.sh snapshot` counting as one. When you generate an image, start it right after the direction is confirmed and keep doing the first passes while it runs.

Starting values for every pass live in [references/system.md](references/system.md).

## Direction

Before touching anything, write these short lines. Derive them from what the app says it does and who it is for. Never from what is trending.

- **Product.** What it does and for whom, in one plain sentence.
- **Task.** The one thing people come to this screen to do. Its answer becomes the screen's subject.
- **Context.** Where and how it is used, like glanced at on an iPhone between meetings, worked in on an iPad with a keyboard, kept open in a Mac window all day, or a quick look on the wrist. This decides density, reach and navigation.
- **Feeling.** The emotion the product should create, in two or three concrete words, like `calm, exact, a little warm` or `quick, energetic, playful`. A fitness app might energize and a meditation app might calm. Words like clean, modern, sleek, minimal, premium and native are not allowed, because they describe every app.
- **Defining moments.** The place or material the product belongs to, and the one or two places on this screen where richer color and detail carry real information. A plant care app lives near soil and window light, so its moment could be a photo of each plant with its watering ring. A running app lives near roads and morning light, so its moment is the route on a map. Write "none" for a settings or utility screen.
- **Signature.** Optional. One detail that carries meaning only this product has, used everywhere it applies, like the rings in Fitness. Never invent one to decorate.
- **Closest Apple screen.** The screen in Apple's own apps whose task is closest to this one, from the table in [references/refs.md](references/refs.md), like Health's Summary for a dashboard of figures. It is the bar for hierarchy, density and craft in the Check step, never a layout, tint or type to copy.

The examples only show the shape of an answer. Derive yours from the product in front of you, even when an example happens to fit.

If the app already has a real brand, like an app icon, a color or a typeface that is not slop, keep it and build the direction around it. A violet to blue gradient, sparkles and glow are slop even when they sit in the icon, so they do not count as brand unless the user says they do.

## 1. Structure

- **Order follows the task.** Keep every feature reachable. Order and placement may change so the answer to the task reads first. A section that does not serve the task moves to a detail screen behind a `NavigationLink`, or to another tab. List each move in the report. In polish mode the order stays.
- **Navigation.** A `NavigationStack` with `.navigationTitle` replaces a hand-built header of an `HStack` with a big `Text` and icons, and the `.navigationBarHidden(true)` or `.toolbar(.hidden)` that hid the real bar. Top-level screens on iPhone use the large title. iPad and Mac apps with a list of places use a `NavigationSplitView` with a sidebar. `NavigationView` is deprecated and becomes one of these.
- **Tabs.** A `TabView` with `Tab` items replaces a custom tab bar drawn in a `ZStack`. Each tab is a place with content, named in a single word with an SF Symbol. Never hide or disable a tab, and explain an empty one instead. Search can be its own `Tab(role: .search)`. On iPad, `.tabViewStyle(.sidebarAdaptable)` shows a tab bar that people can turn into a sidebar. Apple's own apps put settings and the account behind a toolbar button, not in a tab.
- **Lists and forms.** A list of things is a `List`. Settings and input are a `Form` with `Section`s and `LabeledContent`. A `ScrollView` with a `LazyVStack` stays only when the design really needs something a list cannot do, like a card layout or a full width chart.
- **Rows lead somewhere.** A row that stands for a thing is a `NavigationLink`. It shows what people need to pick it, and the rest waits on the screen it opens. A shortened list ends with a `See All` link.
- **Actions.** Actions live in `.toolbar` with semantic placements, `.primaryAction`, `.confirmationAction`, `.cancellationAction` or `.bottomBar`. The primary action is the task's verb, like `Add Expense`. Use one prominent action per toolbar, and at most two prominent buttons in a view. Keep the toolbar to three groups at most, and use the standard Back and Close symbols, not text. Row actions are `.swipeActions` and `.contextMenu`.
- **A control that does nothing is a question.** A button with an empty handler is a question for the user, not a feature to promote. Keep it quiet and ask what it should do.
- **Presentation.** Secondary tasks open in a `.sheet` with `.presentationDetents`. Cancel sits on the leading edge, and Done on the trailing edge always pairs with Cancel or Back. Destructive choices use `.confirmationDialog`. `.alert` is only for something people must act on. Common actions that can be undone get undo, not an alert. A custom overlay with a dimmed background and a card becomes one of these.
- **Controls.** Use the real control. `Button`, `Toggle`, `Picker` with `.segmented` or `.menu` style, `Menu`, `DatePicker`, `Stepper`, `Slider`, `ShareLink`, `PhotosPicker`, `.searchable`, `.refreshable`, `ProgressView`, `Gauge`, `ContentUnavailableView`. A hand-built segmented control, search field or toggle goes.
- **Everything tappable is a `Button` or a `NavigationLink`.** `.onTapGesture` on a `Text` or a row has no pressed state, no button trait for VoiceOver, no keyboard or pointer support, and goes.
- **Liquid Glass.** Since iOS 26 and macOS 26, bars, tab bars, sheets, menus and toolbar buttons are glass on their own. Remove colored `.toolbarBackground`, `UINavigationBarAppearance` colors and solid views placed behind the bars, so content scrolls under them and the scroll edge effect works. Custom glass with `.glassEffect` is only for a custom control in the navigation layer floating over content, like a map control, grouped in a `GlassEffectContainer`. Never glass on content like cards, rows and text blocks, and never glass on glass. `.clear` glass is only for controls over photos and video.
- **Deployment target.** Check it before using new APIs. Code that must run below iOS 26 gets Liquid Glass APIs behind `if #available(iOS 26, *)`. Do not raise the target without asking.

## 2. Spacing

- Let the system space first. Default `.padding()`, the default spacing of stacks, `List` and `Form` insets, `.contentMargins` and `.safeAreaPadding` adapt to the platform. A number you write does not. None of them grow with the text size, so space that should grow uses `@ScaledMetric`.
- Where you set values, a 4 point scale keeps the rhythm, 4, 8, 12, 16, 20, 24, 32, 40, 48, 64. Odd values like `.padding(13)`, `.padding(.top, 7)`, `Spacer().frame(height: 37)` and nudges with `.offset` become steps from the scale or the system default.
- Same thing, same size. All rows in a list share one height and one inset, all cards in a row share one padding.
- Space shows grouping. Space inside a group is smaller than space between groups, so a list reads as one block and sections read as separate ones.
- Things line up. Symbols sit in one column, labels start on one line, figures align on the trailing edge. Use `Label`, `LabeledContent` and `Grid` for aligned columns instead of fixed widths. Edges that almost line up, a point or two apart, read as a mistake, so line them up exactly or part them by at least 8 points.
- Respect the safe area. `.ignoresSafeArea()` belongs on a background, never on content. Something pinned to the bottom goes into `.safeAreaInset(edge: .bottom)` or the toolbar instead of an overlay with a guessed padding.
- No fixed frames on text. `.frame(width: 324)` or `.frame(height: 44)` around text breaks on other devices and larger text. Use `maxWidth: .infinity`, `minHeight`, and `@ScaledMetric` for a custom size that should grow with the text.
- Tap targets are at least 44 by 44 points on iPhone and iPad, and 60 on visionOS.

## 3. Color

- Semantic colors first. Text uses the hierarchical styles `.primary`, `.secondary` and `.tertiary` through `.foregroundStyle`. Backgrounds use `.background`, `Color(.systemBackground)`, `Color(.secondarySystemBackground)` or the grouped variants. They adapt to dark mode, Increase Contrast and vibrancy over glass on their own.
- Hex colors in views go. Each real brand color moves into the asset catalog with light, dark and high contrast variants, and is used by name. `Color(hex:)` helpers scattered through views and `.white.opacity(0.65)` text become semantic styles.
- One accent, used judiciously. The `AccentColor` asset tints what people can tap, what is selected, and status like an unread badge. Content that cannot be tapped does not take the accent, since the same color would then mean two things.
- Color in content carries information. One fixed color per category, used everywhere that category appears, or a color for a state like up and down. Pair it with a symbol or a word, so color is never the only signal.
- The system colors like `.blue`, `.orange` and `.green` adapt to dark mode and Increase Contrast. As text on white, green, orange, yellow, mint and cyan fall far below 4.5 to 1, so use them for fills, bars and symbols. Text stays primary or secondary next to a colored symbol, or uses a darker asset variant that passes.
- Bars and controls stay untinted. A brand color can live in the content layer, like a header image or a card that scrolls beneath the glass, as long as text on it passes contrast.
- Support both appearances. A forced `.preferredColorScheme(.dark)` that only exists so a gradient works goes, and so does an in-app appearance setting. A dark-only app is a deliberate product choice for media or night use. It still supplies light and dark colors, so Liquid Glass adapts.
- Remove hue to hue `LinearGradient` backgrounds, gradient text in `.foregroundStyle`, colored `.shadow(color: .purple, radius: 20)` glows, blurred circles behind content, `AngularGradient` borders and neon strokes.
- A gradient is allowed only as a tone shift inside one hue. Any color's `.gradient`, like `Color.accentColor.gradient`, is Apple's own, used on fills like an icon tile or a progress bar. `MeshGradient` is for one moment tuned to the world, never behind every screen.
- Materials are for surfaces that need separation from what is behind them, like a panel over a photo or a map. Not stacked on a flat color where they do nothing.
- Separators are `Divider()` or the list's own. Not a 1 point rectangle in a custom color.
- Depth comes from grouped surfaces and the glass of the navigation layer. A shadow is neutral, soft and only on something that floats, like a card shaped object.

## 4. Symbols

- Every emoji used as an icon or as decoration in a label becomes an SF Symbol. `Label("Inbox", systemImage: "tray")`, not `Text("📥 Inbox")`. Check in the SF Symbols app that the symbol exists for the deployment target.
- Symbols are type. They scale with the font of their text and match its weight. Size them with `.font` and `.imageScale`, never `.resizable().frame(width: 24, height: 24)` for an interface icon.
- Symbols take the color of their text role or the tint. They never get one color each. `.symbolRenderingMode(.hierarchical)` adds depth in one color, `.palette` takes two colors from the palette, and `.multicolor` is for symbols with natural color like weather. The system's single-color gradient rendering is fine on large symbols. A hue to hue gradient is not.
- Colored icon tiles, like the ones in Settings, belong to settings-like lists and sidebars, with one consistent color per category, used sparingly.
- Variants are automatic. Tab bars pick the filled variant on their own, so do not force `.fill` everywhere.
- Icon-only buttons still carry a title for VoiceOver, like `Button("Add Expense", systemImage: "plus") { }` with `.labelStyle(.iconOnly)` where the title should not show.
- A brand glyph becomes a custom symbol exported from the SF Symbols app, so it scales and aligns like the rest.
- Drop symbols that add nothing, like one before every section header. `sparkles` for anything AI goes, unless it explains a real action.

## 5. Copy

- Write the way Apple's interface speaks. Clear, direct and short. Speak to the person as you, and use possessives like your and my sparingly, so `Favorites`, not `Your Favorites`. Avoid we. Name things the way people do, and leave out what the screen already shows.
- Titles name the place, usually the tab, like `Summary` or `Budget`, in under 15 characters and never the app's name. A period like `October` is the title only when every figure on the screen belongs to it, and then `.toolbarTitleMenu` lets people change it. No greeting headlines like `Welcome back, Alex! 👋`.
- Buttons describe the result, ideally in one or two words, starting with a verb, like `Add Expense`, `Save` or `Delete Budget`. Flow buttons stay consistent, like `Continue` and `Done`. Say tap, not click, on touch devices.
- An alert title says what happened or asks the question. Its buttons answer it, like `Delete` and `Cancel`. Cancel is always `Cancel`, and `OK` is fine only when the alert just informs.
- Capitalization follows the HIG. Buttons, menu items, segmented control labels and alert buttons use title case. An alert title uses title case when it is a fragment and sentence case when it is a full sentence. For every other element type, pick one style that fits the app's voice and use it everywhere.
- Exclamation marks are rare. A brand voice may use an occasional one, never `!!`, and never in errors or warnings.
- Numbers, money, dates and percentages go through `FormatStyle`, like `amount.formatted(.currency(code: currency))` with the currency from the data or the locale, `date.formatted(.relative(presentation: .named))` or `change.formatted(.percent)`. Never `"$" + String(value)` or `String(format:)`. It localizes for free and keeps one format across the screen.
- A change says what it compares to when the data says so, like `12% more than September`. Otherwise ask, and keep the bare figure until the user answers. Never invent the comparison.
- Strings are localizable. Use string literals in `Text` and `String(localized:)`, put plurals in the String Catalog, and never build a sentence by concatenation.
- No hype words like supercharge, seamless, unlock, magic, revolutionize or game-changing, and no `AI-powered` on everything.
- Claims that cannot be checked become quiet and specific if the user confirms they are real, and are removed otherwise. Ask, and list them in the report.
- An error says what happened and what to do next, not `Oops! Something went wrong`.
- Sample data looks real, with plausible numbers and names, never `[X]` or `123,456`.
- Badges like `PRO`, `New ✨` or `Beta 🚀` go away unless the product really needs them, and then they are quiet text.

## 6. Type

- Text styles, not point sizes. `.largeTitle`, `.title`, `.title2`, `.title3`, `.headline`, `.body`, `.callout`, `.subheadline`, `.footnote`, `.caption` and `.caption2` scale with Dynamic Type and carry tracking and leading tuned for each size. `.font(.system(size: 17))` becomes `.body`. Nothing goes below `.caption2`.
- A size outside the styles, like one large figure, scales with them through `@ScaledMetric(relativeTo: .largeTitle)`. A brand typeface uses `Font.custom(_:size:relativeTo:)` so it still scales.
- San Francisco stays unless the brand has a real typeface. Pick its design for the feeling. `.default` for precise and calm, `.rounded` for friendly and playful, `.serif`, which is New York, for editorial and literary, and `.monospaced` only for code and identifiers, like an account number. Mono labels and captions are a template default, not a design. Width variants like `.width(.condensed)` are for one display moment. One design for the interface plus at most one partner keeps it coherent.
- Let the text styles and the bars set weight. `.headline` is already semibold, and the navigation bar draws its large title in bold, while the `.largeTitle` style itself is regular. Add `.fontWeight(.semibold)` for emphasis. Keep `.heavy` and `.black` for one display figure the feeling calls for, never for labels and running text.
- Hierarchy comes from the style, the weight and `.secondary` together, chosen once per role, not a different mix on every line.
- No `.textCase(.uppercase)` with `.tracking` on labels. `TOTAL BALANCE` becomes `Balance`. List section headers keep whatever style the system gives them.
- No `.tracking` or `.kerning` on text styles at all. San Francisco adjusts tracking by size on its own.
- Figures that change or line up use `.monospacedDigit()`, and one format through `FormatStyle`.
- `.lineLimit(1)` with `.minimumScaleFactor(0.5)` to cram running text in goes. Let it wrap, or give the layout room. A large figure must never break or truncate inside the number. Give it `.lineLimit(1)` and `.minimumScaleFactor(0.6)`, and give it the full width at accessibility sizes, since a half-width card still truncates it.
- No italic for emphasis.
- Text aligns leading, in alerts and onboarding too. Center only a short empty state, as `ContentUnavailableView` does.

## 7. Layout

- The subject reads first. Order the screen by importance, as decided in the structure pass.
- The primary action sits in the toolbar or the bottom bar, where the system places it for each device. A tab bar accessory is only for something that persists across tabs, like a mini player, never for a screen's own action.
- Adapt instead of fixing sizes. Read `horizontalSizeClass`, and use `ViewThatFits`, `Grid`, `LazyVGrid` with `.adaptive` columns and `.containerRelativeFrame`. Never compute layout from `UIScreen.main.bounds`, and never fix a width like 390. Apps resize on iPad, on Mac and on iPhone Duo, whose outer display puts the tab bar and toolbars on the side and whose inner display is regular width.
- Reflow for large text. When `dynamicTypeSize.isAccessibilitySize` is true, a label and value side by side stack vertically, through `AnyLayout(VStackLayout())` against `AnyLayout(HStackLayout())`. Grids drop to fewer columns.
- iPad and Mac are not a stretched iPhone. Use the sidebar, an `.inspector`, multiple columns, keyboard shortcuts, pointer hover and menus. Keep text columns readable, around 600 to 700 points wide.
- A dashboard on iPhone has a hierarchy. One figure or chart that answers the task, then supporting figures, then a list. Two stats to a row at most keeps figures whole.
- No `ScrollView` nested in a `ScrollView` on the same axis.
- An overview screen ends where its content ends. Long feeds, a full history or settings move to their own screens.
- On visionOS the content sits in a window of glass, ornaments hold the controls, and nothing important sits at the far edges of the field of view. On watchOS one glance answers the task, large figures lead, the Digital Crown scrolls, and a full-screen color or material may carry meaning.

## 8. Details

- **Corners.** Continuous, never `style: .circular`. `RoundedRectangle(cornerRadius:)` and `.rect(cornerRadius:)` are continuous by default. Nested corners are concentric, inner radius equals outer radius minus the padding between them. Since iOS 26, `ConcentricRectangle` and `.containerShape` do this math against the container and the device's corners. Capsules are for buttons and controls, not for cards.
- **Buttons.** System styles. `.borderedProminent` for the most likely action, `.bordered` for a secondary, `.borderless` or `.plain` for quiet ones, and `.glass` or `.glassProminent` for controls in the navigation layer since iOS 26. `.controlSize(.large)` for a hero action and `role: .destructive` where it applies. A custom `ButtonStyle` with a gradient, a glow and a 1.1 scale goes. One that stays reacts to `configuration.isPressed` with a slight dim or a 0.97 scale.
- **States.** Pressed, disabled, focused and selected states exist. System controls have them. Custom ones need them.
- **Charts.** Swift Charts, not bars drawn from rectangles in an `HStack`. Color encodes one thing. Either one highlighted series over gray, or one fixed color per category used everywhere that category appears, as in Apple Card. Never color by position. Inside a chart, hierarchical styles like `.secondary` and `.quaternary` are shades of the accent, not gray, so give neutral marks an explicit gray like `Color(.systemGray4)`. Keep the default axes and grid, plot dates as dates so labels localize, and lead with the figure the chart sums, like a weekly total above the bars. Pick the chart for the data, a trend is a `LineMark`, a comparison is a `BarMark`, a share is one stacked bar or a list with bars, a single goal is a `Gauge` or a `ProgressView`. One main chart is clearly the biggest thing on the screen, and `.chartXSelection` lets people scrub it. Axis labels grow with the text size, so the chart's height comes from `@ScaledMetric(relativeTo: .caption)`, and at accessibility sizes labels get shorter, like narrow weekdays. No rainbow bars, glowing bars or uppercase day labels.
- **Stat cards are numbers.** A label, a figure, and a change with what it compares to when the data has one. No sparklines, tallies or emoji added to fill them. A card can hold a real looking object when it is the very thing its number counts, like a card shape next to card spending.
- **Vary the sizes.** Equal cards side by side with the same content read as a template. Give the screen a rhythm, like one wide figure above two compact stats and a full width chart.
- **Badges** mark what needs attention, like unread items, with `.badge(_:)`. Not every count gets one, and never a custom glowing circle.
- **Empty, loading and error states.** `ContentUnavailableView` with a symbol, a title, one line and an action for empty and error. `ProgressView` or `.redacted(reason: .placeholder)` for loading. No shimmer loops.
- **Haptics.** `.sensoryFeedback` on meaningful events only, like finishing a goal or a selection snapping into place. Never on every tap.
- **Keyboard.** iPad and Mac commands get `.keyboardShortcut`. On Mac, declare them in `.commands` so they appear in the menu bar. Only the most frequent commands get a new shortcut.
- **The signature detail**, if the direction has one, appears where it carries meaning and nowhere else.

## 9. Visuals

- Decorative filler goes. Glossy blobs, orbs, nebulas, floating cubes, glowing grids, holographic brains and robots say nothing about the product.
- App screens almost never need generated images. Their moments come from the product, a chart drawn with care, figures set beautifully, a map with MapKit, real photos and avatars, a status that feels alive. A physical thing the product deals with, like a payment card in a finance app, is better built in code, a `RoundedRectangle` with a soft tone shift inside one hue, a chip and a number in the mono design.
- Empty states prefer an SF Symbol in `ContentUnavailableView`. A generated illustration only when the world calls for it and the user wants one.
- People should understand the screen by using it. Teach a feature with a TipKit tip in context, not a tour. If the screen is a first-run screen, keep it to one skippable page with a few feature rows and one button.
- Before this pass, look at the references in [references/refs.md](references/refs.md). Take qualities from them, like composition, light, restraint and how the moment is placed, never their subject or layout.
- How to pick the subject, the prompt recipe and how to place an image are in [references/visuals.md](references/visuals.md). Read it before this pass.

## 10. Motion

- Apple's motion is springs. Plain `withAnimation { }` already uses a smooth spring. `.smooth` is the default for most changes, `.snappy` for quick small ones, and `.bouncy` only for direct manipulation and real celebrations. A hand-tuned `.spring(response: 0.3, dampingFraction: 0.4)` that overshoots on simple UI goes.
- Remove motion that loops for no reason, like `.repeatForever` pulses, breathing glows and scales on things that are not live, rotating badges, floating offsets and parallax driven by `GeometryReader`.
- Remove entrances where content flies in on `.onAppear` from different sides. Apple's apps show content in place. At most one quiet fade for content that loads late.
- Keep motion that explains something. A push and a sheet come from the system. `.navigationTransition(.zoom(sourceID:in:))` with `.matchedTransitionSource` grows a card into its detail. `.contentTransition(.numericText(value:))` tweens a changing number. `.symbolEffect` plays once when its action happens, and `.contentTransition(.symbolEffect(.replace))` turns one symbol into the next, like play into pause. `.transition(.blurReplace)` swaps content in place.
- A change people cause animates where it happens. Insert, remove and reorder rows inside `withAnimation`, so the rows around the change make room instead of jumping.
- Scope animations. `.animation(_:value:)` with a value, never `.animation(.default)` without one, which is deprecated and animates things by accident.
- Respect Reduce Motion. Read `accessibilityReduceMotion` and use a crossfade instead of movement, zooms and blurs, including `.blurReplace`. The system transitions already do.
- Avoid animating large blurs and many shadows, they drop frames on older devices. Animate opacity, scale and offset.
- A haptic is part of the motion. It lands with the visual change it belongs to.

## 11. Accessibility

- **Dynamic Type.** Check the largest accessibility size in the `-ax` snapshot. Nothing is clipped, overlapping or truncated into nonsense, rows reflow as in the layout pass, figures stay whole, and charts keep their plot area. The snapshot shows only the first screen, so check a section further down by rendering its `#Preview` at `.dynamicTypeSize(.accessibility5)`, or by moving it to the top for one snapshot and back. Bold Text works on its own with text styles.
- **VoiceOver.** Every button has a name, including icon-only ones. Decorative images use `Image(decorative:)` or `.accessibilityHidden(true)`. A stat card reads as one element through `.accessibilityElement(children: .combine)`, like `Spent, $2,140`. Custom controls get `.accessibilityAddTraits`, `.accessibilityValue` and `.accessibilityAdjustableAction`. Swift Charts read their marks on their own, so do not cover a chart with one label. A custom chart gets `.accessibilityChartDescriptor`.
- **Voice Control.** People say what they see, so a control's accessibility name starts with its visible text.
- **Large Content Viewer.** A bar item that cannot grow with Dynamic Type gets `.accessibilityShowsLargeContentViewer()`. System bars already have it.
- **Contrast and transparency.** Text up to 17 points passes 4.5 to 1, and larger or bold text passes 3 to 1, in both appearances and with Increase Contrast. Custom translucent fills read `accessibilityReduceTransparency` and turn solid. System materials and glass already do.
- **Not color alone.** Status pairs color with a symbol or a word, and respects `accessibilityDifferentiateWithoutColor`.
- **Direction.** Use leading and trailing, never left and right, so the layout mirrors for right-to-left languages. Directional SF Symbols mirror on their own.
- **Photos and video** use `.accessibilityIgnoresInvertColors()` so Smart Invert leaves them alone.

## Story video

A short video where the screen unslops itself step by step, with red redlines on the slop. Look at [refs/story-dashboard-frames.webp](references/refs/story-dashboard-frames.webp) before you build it, eight frames from the original web version, in order. It works like this:

- **Nothing is swapped, everything morphs.** One view, and each step only changes values, so padding, spacing, sizes, colors, corners and shadows animate from the old value to the new one in place. SwiftUI does this on its own when the values depend on the step.
- **A wave.** Elements start a few dozen milliseconds apart from the top down, so a change runs across the screen instead of everything flipping at once.
- **Text rolls.** Copy that changes blurs out and the new words replace it.
- **Redlines first.** The slop gets red boxes with tags, a spacing step shows red measurements whose numbers count to the new value, and a details step outlines corners with their radius.
- **Close and short.** Square, cropped close on the part that changes most, so it reads on a phone, and about 10 seconds.

It adds a few minutes, so make it only when the user wants it. The details and the helper file are in [references/story.md](references/story.md).

## Do not

- Do not rename the product, even when the name has AI in it. Keep a real icon as it is. When the icon itself is slop, note it in the report with a one sentence idea for the glyph.
- Do not drop features. Every feature stays reachable, even when it moves. Placeholder content that means nothing may be replaced with content that does.
- Do not rebuild what the system provides. No custom tab bars, navigation bars, alerts, toggles or search fields.
- Do not replace removed decoration with new decoration, and do not swap one trend for another, like glass on every card, grain, neon or bento grids.
- Do not invent features, claims, data or comparisons.
- Do not raise the deployment target, add a dependency or change the app's architecture to unslop a screen without asking.
- Do not fall back on the look a model reaches for when nobody decided: a cream or off-white background in place of the system background, an italic accent word in a title, numbered `01` `02` `03` section labels, `.monospaced` labels and captions, capsules on every chip, field and card, and the same tint and layout for every product. The direction decides the tint, the type design and the moment.

## Checklist

- [ ] The direction is written, the open questions are asked, and every pass follows the answers
- [ ] The screen's subject answers the task and reads first, and every feature is still reachable
- [ ] System navigation, tabs, lists, toolbars and sheets, no hand-built chrome, and every tappable thing is a `Button` or `NavigationLink` that leads somewhere
- [ ] Glass only on the navigation layer, never on content and never glass on glass
- [ ] System spacing or the scale, equal things equal, no fixed frames on text, content inside the safe area
- [ ] Semantic colors, the accent only on what people can tap, selection and status, works in light and dark
- [ ] No hue gradients, gradient text, glows, colored shadows or color blobs
- [ ] No emoji left in the interface, SF Symbols sized by font, one color role each
- [ ] Apple's voice and capitalization, no greeting title, no unverified claims or invented comparisons, numbers through `FormatStyle` with the locale's currency
- [ ] Text styles everywhere, custom sizes through `@ScaledMetric`, no uppercase tracked labels, no tracking, no italic
- [ ] The layout adapts to size class and reflows at accessibility sizes, and figures stay whole
- [ ] Continuous, concentric corners and system button styles
- [ ] Charts in Swift Charts with color that encodes one thing, stat cards are numbers
- [ ] Previews render empty data, a first period with no history, a negative value, a very long name and another currency
- [ ] Springs from the system, no loops, no fly-in entrances, Reduce Motion respected
- [ ] The `-ax` snapshot holds up, VoiceOver and Voice Control name everything, text passes contrast, color is never the only signal
- [ ] Held next to the closest Apple screen, it is not the busier, flatter or emptier one
- [ ] Meaning check. Every color, symbol and word carries this product's information, and the screen shows what sets this product apart in its content, not in decoration
