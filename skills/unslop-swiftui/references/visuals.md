# Visuals

How to replace decorative filler with a visual that belongs to this product, and how to generate one when an image tool is available.

## Decide what the visual is

1. **Does the screen need one?** Working screens, like lists, dashboards, editors and settings, do not. Their moment comes from content. An empty state or a welcome page sometimes does. The app icon, widgets and App Store screenshots are out of scope for a screen redesign, so note them in the report instead.
2. **Can the product show itself?** Build the moment in SwiftUI first. A chart in Swift Charts, a map in MapKit, the person's own photos, a card shaped object drawn in code. Pick the one moment that proves what the screen is for, not the whole app. A budget app shows where this month's money went by category, a running app shows today's route on a map, a habit app shows a streak on one card.
3. **Is there an image tool, and does the moment need a real object or a scene?** Then generate it, for a welcome page, an empty state the user wants illustrated, or an object placed in the interface.
4. **Write it as one sentence.** Use the world and feeling from the direction and write the subject as one plain sentence before generating anything. If you cannot say it in one sentence, it is not clear yet.

These examples only show the shape of a good sentence. Do not reuse them, derive yours from the product in front of you.

- A budget app → a single paper receipt curling on a kitchen table in morning light
- A meditation app → a cup of tea steaming on a windowsill at first light
- A logistics app → one container ship seen from straight above on a calm grey sea
- A language app → a stack of handwritten flashcards on a café table in afternoon sun

Avoid the AI defaults, unless the product is literally about them. No glossy blobs, orbs, nebulas, chrome liquid, floating cubes, neon circuits, holograms, glowing brains, robots, rockets or crystal shapes.

## Moments built in code

Most moments in an app are built in SwiftUI, not generated.

- **A chart.** Swift Charts where color encodes one thing, one highlighted series over gray or one fixed color per category, a smooth `LineMark` with `.interpolationMethod(.catmullRom)` or a mirrored comparison, scrubbing with `.chartXSelection`, the selected value in a large figure above it.
- **A card shaped object.** A `RoundedRectangle` at the real object's ratio, like 1.586 to 1 for a payment card, filled with a tone shift inside one hue, a small chip, the last four digits in `.monospaced`, and a soft neutral shadow. It reads as the real thing.
- **A map.** `Map` with the route or the place as the one colored line, standard controls, everything else muted with `.mapStyle(.standard(emphasis: .muted))`.
- **A ring or a gauge.** `Gauge` or a trimmed `Circle` stroke with round caps, the progress in the accent and the track in `.fill.tertiary`.
- **Photos and avatars.** Real images from the product, with `.accessibilityIgnoresInvertColors()`.

## The app icon

The icon is out of scope for a screen redesign. When it is slop, the report describes one replacement idea in a sentence, following Apple's guidance:

- One idea from the product as one simple glyph, on a calm background, that still reads at small sizes like Settings and notifications.
- For iOS, iPadOS, macOS and watchOS, layers built in Icon Composer, so the system can render it as Liquid Glass. On iOS, iPadOS and macOS it also needs to work in the dark, tinted and clear appearances. visionOS and tvOS icons are layered image stacks made in Xcode.
- No words, no photos, no fine detail and no baked-in drop shadows. A single letter is fine when it is the brand's mark.

## Styles that work

For a welcome page or an empty state, pick one style that fits the feeling and keep it everywhere. App Store screenshots must show the app in use, so art can only frame them.

- **Painted background art.** A calm sky or landscape with one subject, painted like the backgrounds of modern Japanese animated films, crisp clouds and soft light, with open space left for text. Good for warm, hopeful, human products.
- **Cinematic photo of one object.** A single real thing in simple dramatic light on a plain field. Good for calm, serious, trustworthy products.
- **Soft stylized 3D.** One small scene or object with matte materials and gentle light. Good for playful or friendly products.
- **Product object render.** A real looking object from the product, like a payment card, a phone or a package, studio lit with true materials, used as a moment inside the interface. Good for anything that touches the physical world.
- **Engraving or print.** A monochrome engraving or woodcut in one ink on a soft tinted field, with type and color that belong to the same world. Good for products with heritage, craft or an editorial voice, when the whole app lives in it.
- **A code treatment over an image.** Rendering an image as glyphs, dots or a duotone in the app's colors, so it feels made for the screen. See [effects.md](effects.md).

What tends to fail:

- Prompts that ask for film grain, paper grain or a mottled texture. Models bake a fine checker pattern into the image.
- A print style on one image while the rest of the app is a plain system interface. It reads as a filter.
- Several subjects or a busy collage. The idea stops reading in a second.
- Purple and blue glossy abstractions of any kind.

## Objects for moments

Besides scenes, generate single objects to place into the interface, like a parcel, a coffee cup or a notebook from the product's world.

- Ask for one object, studio lit, on a plain background in the exact background color, with a soft contact shadow and nothing else in frame.
- Ask for the angle you need, like "tilted 20 degrees, seen slightly from above".
- Cut the object out if the tool can remove backgrounds, and save it as a PNG with alpha. Otherwise generate it on the exact background color of the screen in both appearances, or keep it on a surface that matches.
- Everything inside one visual tells the same story. If the list shows a payment to a café, the object is that café's receipt.

## Generate it

Look for an image generation tool among the tools you have, for example an MCP server for fal, Replicate, OpenAI images, Higgsfield or a design tool. If there is one:

- Show the user the prompt, the model and the size, and ask before running, since generation can cost money.
- Run once. Judge the result against the one sentence and the palette before trying again, and change the prompt rather than rerolling the same one.
- Save the result into the asset catalog, not a temporary URL.

If there is no tool and the screen needs a scene or an object, say so before the Visuals pass and offer to connect one. If the user skips it, leave the slot empty and put the prompt in your report, not in the view. The empty slot is a plain `.fill.tertiary` shape of the exact size and corner radius, with no text inside, so nothing unfinished can ship by accident. Tell the user which kind of service can generate it and the asset name to save it under.

## Prompt recipe

Build the prompt from these parts, in this order:

- **Subject.** The one sentence, concrete and physical.
- **Setting.** Where it is, kept simple.
- **Light and palette.** Matched to the screen. Name the background color so the edges can blend, and the direction of the light. Ask for a light and a dark version when the image sits on a background that changes with the appearance.
- **Style.** One clear direction that fits the feeling.
- **Composition.** Where the subject sits so text and controls have room, like "subject in the lower half, calm empty sky above". Leave the area under the navigation bar and the home indicator calm.
- **Exclusions.** No text, no letters, no logos, no UI, no watermark.
- **Format.** The aspect ratio of the slot at three times the point size, for @3x screens.

## Put it in the app

- Add it to the asset catalog with an Any and a Dark appearance when it needs both. Use HEIC or PNG for images and PDF or SVG with Preserve Vector Data for flat art.
- Show it with `Image("Name").resizable().scaledToFill()` in a fixed frame, clipped with `.clipShape`, so the layout does not jump.
- Give it a real `accessibilityLabel` that says what it shows, or make it `Image(decorative:)` when it only sets the mood.
- Match its edges to the background. If they do not match, fade them with `.mask(LinearGradient(colors: [.black, .clear], startPoint: .center, endPoint: .bottom))`.
- An image under a sidebar or inspector on iPad and Mac can extend under it with `.backgroundExtensionEffect()` since iOS 26.
- Keep it static or give it one slow, subtle motion that fits the subject, and none with Reduce Motion on. No parallax.

---

Adapted from unslop by Damir Sokolovsky ([@heydamir](https://x.com/heydamir)), CC BY 4.0, rewritten for SwiftUI. Keep this credit in copies and adaptations.
