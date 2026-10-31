# Story video

How to build and record the story video, a short square video where the screen unslops itself. Read the Story video section of [SKILL.md](../SKILL.md) first, and look at [refs/story-dashboard-frames.webp](refs/story-dashboard-frames.webp), eight frames from the original web version in order.

SwiftUI already morphs. When a value depends on state and the state changes inside an animation, padding, spacing, frames, colors, corner radii, shadows and opacity all animate from the old value to the new one in place. So a story is one view whose values depend on a step number.

## 1. Add the helper

Copy [scripts/UnslopStory.swift](../scripts/UnslopStory.swift) into the app target. It only compiles in Debug builds and gives you:

- `@Environment(\.storyStep)`, the step shown, 0 for the original screen.
- `StoryPlayer(steps:)`, which holds the original for 4.5 seconds, advances one step at a time with `.smooth`, then takes one more step with no changes so the redlines clear on the finished screen.
- `.storyWave()`, which delays a view's changes by its position, so a step runs down the screen as a wave.
- `StorySwap(at:from:to:)`, text that blurs out and is replaced at a step.
- `.storySlop(_:until:)`, a red box with a tag on a sign of slop until the step that fixes it.
- `.storyGap(_:fixedAt:)`, a red measurement of the space above a view, whose number counts to the new value and turns to the primary text color at the step that fixes it.
- `.storyRadius(_:from:)`, a dashed red outline of a view's corners with their radius during one step.

## 2. Build the story view

Make a copy of the original screen as `StoryView` in its own file, with its sample data. Keep the original values as they are, they are step 0.

```swift
#if DEBUG
struct StoryView: View {
    var body: some View {
        StoryPlayer(steps: ["Spacing", "Color and symbols", "Type and copy", "Details"]) {
            StoryScreen()
        }
    }
}

private struct StoryScreen: View {
    @Environment(\.storyStep) private var step

    var body: some View {
        VStack(alignment: .leading, spacing: step >= 1 ? 16 : 13) {
            StorySwap(at: 3, from: "Welcome back, Alex! 👋", to: "October")
                .font(step >= 3 ? .largeTitle.bold() : .system(size: 28, weight: .black))
                .storySlop("Greeting", until: 3)
            BalanceCard()
                .padding(step >= 1 ? 20 : 21)
                .background(step >= 2 ? Color(.secondarySystemGroupedBackground) : Color.purple.opacity(0.4))
                .clipShape(.rect(cornerRadius: step >= 4 ? 24 : 28))
                .shadow(color: .purple.opacity(step >= 2 ? 0 : 0.6), radius: 24)
                .storyGap(step >= 1 ? 16 : 13, fixedAt: 1)
                .storyRadius(step >= 4 ? 24 : 28, from: 4)
                .storyWave()
        }
    }
}
#endif
```

- **Steps.** Three to five, merging passes so each one changes something you can see, like `Spacing`, `Color and symbols`, `Type and copy`, `Details`. A new chart or visual goes into the last step.
- **Each step only changes values.** `step >= 2 ? newValue : oldValue` on every modifier that changes. The conditions add up, so step 3 still has the values of steps 1 and 2. Change values, never structure, so SwiftUI can animate them. Keep the same views in the same order in every step.
- **What does not animate, and how to handle it.**
  - A gradient that becomes a solid color: put the gradient on its own layer and fade its opacity to 0 over the solid color underneath.
  - Text whose words change, an emoji that becomes a symbol, a new font design: `StorySwap`. At most eight swaps in a story. Twenty swaps blurring at once read as a cut between two pictures. Weight, size and color changes animate on their own, so they never need a swap.
  - An emoji that becomes an SF Symbol: stack both in a `ZStack` in the same frame and crossfade their opacity. That is not a swap.
  - Things that disappear, like a `New ✨` badge: fade the opacity to 0 and set the frame to zero height in the same step, so the space closes smoothly.
  - Things that appear, like a legend: reserve their space from step 0 and fade the opacity in.
  - A hand-built tab bar that becomes a system `TabView` cannot morph, since it is a structure change. Restyle the custom bar toward the system look instead, and say in the report that the shipped code uses `TabView`.
- **Wave.** Add `.storyWave()` to the blocks of the screen, like the header, each card and the list, not every text.
- **Redlines.** Choose them well, they are what people watch.
  - `.storyGap` on four to six blocks of the main vertical stack, not on every row.
  - `.storyRadius` on two to four cards or buttons whose corners change.
  - `.storySlop` on at most five of the clearest signs, apart from each other, with short tags like `Gradient text` or `Emoji icon`. It is optional.

## 3. Launch into it

In the app's `App`, show the story when the app is launched with `-UnslopStory`:

```swift
WindowGroup {
    #if DEBUG
    if ProcessInfo.processInfo.arguments.contains("-UnslopStory") {
        StoryView()
    } else {
        ContentView()
    }
    #else
    ContentView()
    #endif
}
```

## 4. Record

From the folder that holds the project:

```bash
<skill folder>/scripts/sim.sh record -- -UnslopStory
```

It builds, launches the app into the story, records the simulator screen, trims the app opening, and saves a square `unslop/story.mp4` at up to 1080 by 1080 with a small `unslop by @heydamir` credit in the corner, as the license asks. It needs only Xcode.

- **Seconds.** Recording starts 3 seconds after launch. The original holds for 4.5 seconds from the moment the view appears, and each step holds for 1.8, including the final clean one. A fresh install can take 2 or 3 seconds to draw, so the default of 15 seconds suits four steps with room to spare, and the clean screen simply holds longer at the end. For more steps, add 1.8 seconds each with `--seconds`. If the video opens on a blank screen, the app took longer to draw, so raise `lead` in `StoryPlayer`.
- **Camera.** `--crop x,y,size` picks the square to keep, in pixels of the simulator screen, which is three times the points on most iPhones. By default it keeps the top square of the screen. Crop close on where the most visible change happens, usually the title and the first cards, like `--crop 0,300,1206` on an iPhone 17 Pro.
- **Appearance.** `--dark` or `--light` sets it for the recording.
- **Check it.** Next to the video it saves `story-frame-1.png` to `-3.png`, from the start, the middle and the end. Look at all three before you hand it over. Checking the video does not count toward the snapshot limit of a run.

## 5. Clean up

The story view is a presentation piece. The clean result ships as normal code in the app, with system components and without `storyStep`. Delete `UnslopStory.swift`, `StoryView` and the launch argument branch after recording, or keep them out of the commit.

---

Adapted from unslop by Damir Sokolovsky ([@heydamir](https://x.com/heydamir)), CC BY 4.0, rewritten for SwiftUI. Keep this credit in copies and adaptations.
