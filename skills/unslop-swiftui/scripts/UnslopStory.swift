// Unslop story helpers. Copy this file into the app target to record a story video,
// and remove it after recording. It only compiles in Debug builds.
//
// Adapted from unslop by Damir Sokolovsky (@heydamir), CC BY 4.0. sim.sh record adds
// the "unslop by @heydamir" credit to the video, as the license asks.
#if DEBUG
import SwiftUI

extension EnvironmentValues {
    /// The story step currently shown, 0 for the original screen.
    var storyStep: Int {
        get { self[StoryStepKey.self] }
        set { self[StoryStepKey.self] = newValue }
    }
}

private struct StoryStepKey: EnvironmentKey {
    static let defaultValue = 0
}

/// Plays the story. Holds the original screen, advances one step at a time, then takes
/// one more step with no changes so the redlines clear on the finished screen.
/// Every view inside reads `@Environment(\.storyStep)` and picks its values from it.
struct StoryPlayer<Content: View>: View {
    /// Step names, like ["Spacing", "Color and symbols", "Type and copy", "Details"].
    var steps: [String]
    /// How long the original shows before the first step. sim.sh record starts recording
    /// three seconds after launch, so the video opens with 1.5 seconds of the original.
    var lead: Duration = .seconds(4.5)
    var hold: Duration = .seconds(1.8)
    @ViewBuilder var content: Content

    @State private var step = 0

    var body: some View {
        content
            .environment(\.storyStep, step)
            .task {
                try? await Task.sleep(for: lead)
                for next in 1...(steps.count + 1) {
                    withAnimation(.smooth(duration: 1.1)) { step = next }
                    try? await Task.sleep(for: hold)
                }
            }
    }
}

extension View {
    /// Delays this view's changes by its position, so each step runs down the screen as a wave.
    func storyWave() -> some View { modifier(StoryWave()) }

    /// A red box with a tag around a sign of slop, shown until the step that fixes it.
    func storySlop(_ tag: String, until fixedAt: Int) -> some View {
        modifier(StorySlop(tag: tag, fixedAt: fixedAt))
    }

    /// A measurement of the space above this view. Red before the step that fixes it,
    /// the primary text color during that step while the number counts to the new value, then gone.
    func storyGap(_ value: CGFloat, fixedAt: Int) -> some View {
        modifier(StoryGap(value: value, fixedAt: fixedAt))
    }

    /// Outlines this view's corners with their radius during one step.
    func storyRadius(_ value: CGFloat, from shownAt: Int) -> some View {
        modifier(StoryRadius(value: value, shownAt: shownAt))
    }
}

/// Text that changes at a step. The old words blur out and the new ones come in.
struct StorySwap: View {
    var at: Int
    var from: String
    var to: String

    @Environment(\.storyStep) private var step

    var body: some View {
        let changed = step >= at
        Text(verbatim: changed ? to : from)
            .id(changed)
            .transition(.blurReplace)
    }
}

private struct StoryWave: ViewModifier {
    @Environment(\.storyStep) private var step
    @State private var delay = 0.0

    func body(content: Content) -> some View {
        content
            .onGeometryChange(for: Double.self) { proxy in
                let frame = proxy.frame(in: .global)
                return Double(frame.minY + frame.minX * 0.3) / 2400
            } action: { delay = $0 }
            .animation(.smooth(duration: 1.1).delay(delay), value: step)
    }
}

private let redline = Color(red: 1, green: 0.23, blue: 0.19)

private struct StorySlop: ViewModifier {
    var tag: String
    var fixedAt: Int
    @Environment(\.storyStep) private var step

    func body(content: Content) -> some View {
        let shown = step < fixedAt
        content.overlay(alignment: .topLeading) {
            Rectangle()
                .strokeBorder(redline, lineWidth: 1.5)
                .overlay(alignment: .topLeading) {
                    Text(verbatim: tag)
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 4)
                        .padding(.vertical, 2)
                        .background(redline)
                        .fixedSize()
                        .offset(y: -18)
                }
                .padding(-4)
                .opacity(shown ? 1 : 0)
                .allowsHitTesting(false)
        }
    }
}

private struct StoryGap: ViewModifier {
    var value: CGFloat
    var fixedAt: Int
    @Environment(\.storyStep) private var step

    func body(content: Content) -> some View {
        let color = step >= fixedAt ? Color.primary : redline
        content.overlay(alignment: .topTrailing) {
            HStack(spacing: 4) {
                Text(value, format: .number.precision(.fractionLength(0)))
                    .font(.caption2.monospacedDigit().weight(.semibold))
                    .contentTransition(.numericText(value: value))
                    .fixedSize()
                Rectangle().frame(width: 1)
            }
            .foregroundStyle(color)
            .frame(height: value)
            .offset(y: -value)
            .padding(.trailing, 4)
            .opacity(step <= fixedAt ? 1 : 0)
            .allowsHitTesting(false)
        }
    }
}

private struct StoryRadius: ViewModifier {
    var value: CGFloat
    var shownAt: Int
    @Environment(\.storyStep) private var step

    func body(content: Content) -> some View {
        content.overlay(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: value)
                .strokeBorder(redline, style: StrokeStyle(lineWidth: 1.5, dash: [4, 3]))
                .overlay(alignment: .topLeading) {
                    Text(value, format: .number.precision(.fractionLength(0)))
                        .font(.caption2.monospacedDigit().weight(.semibold))
                        .foregroundStyle(redline)
                        .contentTransition(.numericText(value: value))
                        .fixedSize()
                        .offset(x: 4, y: -16)
                }
                .opacity(step == shownAt ? 1 : 0)
                .allowsHitTesting(false)
        }
    }
}
#endif
