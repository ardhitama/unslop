# Effects

Code treatments that turn an image into something made for this app. They are optional. Use one only when it fits the feeling in the direction, on the main visual only, like a welcome page or an empty state, and never as decoration on other elements.

## Contents

- Glyphs, with a full implementation
- Halftone dots
- Dithering
- Duotone
- Performance

## Glyphs

Draw the image as a grid of characters, brightness picking the character. It works best when the characters come from the product's own material, so the image is literally made of what the product deals with.

- Money, budgets, invoices: `. : 1 7 4 0 8 $ %`
- Code, developer tools: `. : / { } < > = #`
- Music: note names like `c d e g a` and `♭ ♯`
- Writing, reading: lowercase letters of a word from the product
- Data, monitoring: `. · : | + ▪`

Keep the cell between 6 and 10 points, use the `.monospaced` design, and color the glyphs from the image or from the palette. Let a few cells change slowly over time so the picture feels alive, and stop that with Reduce Motion on.

### Implementation

```swift
import SwiftUI

struct GlyphCell {
    var x: Int
    var y: Int
    var light: Double
    var color: Color
    var seed: Double
}

/// Samples the image once into a grid. Call it when the image loads, never per frame.
func glyphCells(from image: CGImage, columns: Int, rows: Int) -> [GlyphCell] {
    let bytesPerRow = columns * 4
    var pixels = [UInt8](repeating: 0, count: rows * bytesPerRow)
    let drawn = pixels.withUnsafeMutableBytes { buffer -> Bool in
        guard let space = CGColorSpace(name: CGColorSpace.sRGB),
              let context = CGContext(
                  data: buffer.baseAddress, width: columns, height: rows, bitsPerComponent: 8,
                  bytesPerRow: bytesPerRow, space: space,
                  bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
              )
        else { return false }
        context.interpolationQuality = .medium
        context.draw(image, in: CGRect(x: 0, y: 0, width: columns, height: rows))
        return true
    }
    guard drawn else { return [] }

    var cells: [GlyphCell] = []
    cells.reserveCapacity(columns * rows)
    for y in 0..<rows {
        for x in 0..<columns {
            let i = y * bytesPerRow + x * 4
            let red = Double(pixels[i]) / 255, green = Double(pixels[i + 1]) / 255, blue = Double(pixels[i + 2]) / 255
            cells.append(GlyphCell(
                x: x, y: y,
                light: 0.2126 * red + 0.7152 * green + 0.0722 * blue,
                color: Color(red: red, green: green, blue: blue),
                seed: .random(in: 0...1)
            ))
        }
    }
    return cells
}

struct GlyphImage: View {
    let cells: [GlyphCell]
    let columns: Int
    let rows: Int
    var characters = Array(".:17408$%")
    /// On a light background, bright cells would draw near-white glyphs on white, so the ramp inverts.
    var onLightBackground = false
    var cell: CGFloat = 8
    var stepsPerSecond: Double = 8

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var isVisible = true

    var body: some View {
        TimelineView(.animation(minimumInterval: 1 / stepsPerSecond, paused: reduceMotion || !isVisible)) { timeline in
            let step = Double(Int(timeline.date.timeIntervalSinceReferenceDate * stepsPerSecond))
            Canvas { context, _ in
                // Resolve each character once per frame, not once per cell.
                let glyphs = characters.map {
                    context.resolve(Text(String($0)).font(.system(size: cell + 1, weight: .medium, design: .monospaced)))
                }
                for item in cells {
                    let light = onLightBackground ? 1 - item.light : item.light
                    guard light >= 0.06 else { continue }
                    let jitter = sin(item.seed * 999 + step) > 0.92 ? 1 : 0
                    let pick = min(characters.count - 1, Int(light * Double(characters.count)) + jitter)
                    var glyph = glyphs[pick]
                    glyph.shading = .color(item.color)
                    context.draw(glyph, at: CGPoint(x: (CGFloat(item.x) + 0.5) * cell, y: (CGFloat(item.y) + 0.5) * cell))
                }
            }
        }
        .frame(width: CGFloat(columns) * cell, height: CGFloat(rows) * cell)
        .onScrollVisibilityChange { isVisible = $0 }
        .accessibilityHidden(true)
    }
}
```

On a light background, set `onLightBackground` and shade the glyphs with one ink color from the palette instead of the image's own colors. Sample the grid from the image's `cgImage` at the size you show, like 48 columns for a 384 point wide slot with 8 point cells, and keep the cells in the view's model or `@State` so they are not sampled again.

## Halftone dots

Dots on a grid whose size follows brightness. Suits editorial, print and crafted feelings. Same sampling as glyphs, but in the `Canvas` fill a circle with a radius of `light * cell / 2` in one ink color on the background, with `context.fill(Path(ellipseIn: rect), with: .color(ink))`.

## Dithering

An ordered dither into two or three colors from the palette. Suits retro, technical and playful feelings. Compute it once when the image loads into a small bitmap, then show that with `.interpolation(.none)` scaled up so the pixels stay crisp. Never per frame.

## Duotone

Map the image's brightness onto two colors, the background and the accent or the primary text color. The simplest way to make any image belong to the palette, with no shader.

```swift
ZStack {
    Color(.systemBackground)
    Color.accentColor
        .mask {
            Image("Scene")
                .resizable()
                .scaledToFill()
                .luminanceToAlpha()
        }
}
.clipShape(.rect(cornerRadius: 24))
.accessibilityHidden(true)
```

This maps light areas to the accent, which suits a dark background. On a light background, add `.colorInvert()` before `.luminanceToAlpha()` so dark areas take the accent instead. For finer control, a Metal shader through `.colorEffect` does the same per pixel.

## Performance

These effects broke on older devices before, so keep to these rules.

- Read pixels once when the image loads. Never sample the image inside the `Canvas` or the `TimelineView`.
- Resolve text once per frame with `context.resolve` and draw it many times.
- Animate at 8 to 12 steps per second through `TimelineView(.animation(minimumInterval:paused:))`, not 60, and change only a small share of cells per step.
- Pause when the view is off screen with `.onScrollVisibilityChange`, and when Reduce Motion is on.
- Test on the oldest device the app supports, not only the simulator on a Mac.

---

Adapted from unslop by Damir Sokolovsky ([@heydamir](https://x.com/heydamir)), CC BY 4.0, rewritten for SwiftUI. Keep this credit in copies and adaptations.
