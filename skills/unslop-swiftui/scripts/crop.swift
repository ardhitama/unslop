// Crops a simulator recording to a square video, ready to post.
//
//   xcrun swift crop.swift <in.mov> <out.mp4> <trim seconds> [x,y,size]
//
// x, y and size are in pixels of the recording. Without them the top square of the
// screen is kept. The output is 1080 by 1080, or the crop size when that is smaller.
// It also saves three frames next to the video, <out>-frame-1.png to -3.png, from the
// start, the middle and the end, so the result can be checked without playing it.
//
// Every video carries a small "unslop by @heydamir" credit in the corner, since unslop
// is CC BY 4.0 and asks for it.
import AVFoundation
import CoreText
import ImageIO
import QuartzCore
import UniformTypeIdentifiers

func fail(_ message: String) -> Never {
    FileHandle.standardError.write(Data("crop.swift: \(message)\n".utf8))
    exit(1)
}

let arguments = CommandLine.arguments
guard arguments.count >= 4, let trim = Double(arguments[3]) else {
    fail("usage: crop.swift <in.mov> <out.mp4> <trim seconds> [x,y,size]")
}
let input = URL(fileURLWithPath: arguments[1])
let output = URL(fileURLWithPath: arguments[2])

let asset = AVURLAsset(url: input)
guard let track = try await asset.loadTracks(withMediaType: .video).first else {
    fail("\(input.path) has no video track.")
}
let (naturalSize, transform) = try await track.load(.naturalSize, .preferredTransform)
let duration = try await asset.load(.duration)
let screen = naturalSize.applying(transform)
let screenWidth = abs(screen.width)

let crop: (x: Double, y: Double, size: Double)
if arguments.count >= 5 {
    let parts = arguments[4].split(separator: ",").compactMap { Double($0) }
    guard parts.count == 3, parts[2] > 0 else { fail("--crop must be x,y,size in pixels, like 0,240,1206.") }
    crop = (parts[0], parts[1], parts[2])
} else {
    crop = (0, 0, screenWidth)
}
let screenHeight = abs(screen.height)
guard crop.x >= 0, crop.y >= 0, crop.x + crop.size <= screenWidth, crop.y + crop.size <= screenHeight else {
    fail("the crop \(Int(crop.x)),\(Int(crop.y)),\(Int(crop.size)) falls outside the \(Int(screenWidth)) by \(Int(screenHeight)) recording.")
}

// H.264 needs even dimensions.
let side = (min(1080, crop.size) / 2).rounded(.down) * 2
let scale = side / crop.size
let place = transform
    .concatenating(CGAffineTransform(translationX: -crop.x, y: -crop.y))
    .concatenating(CGAffineTransform(scaleX: scale, y: scale))

let layer = AVMutableVideoCompositionLayerInstruction(assetTrack: track)
layer.setTransform(place, at: .zero)
let instruction = AVMutableVideoCompositionInstruction()
instruction.timeRange = CMTimeRange(start: .zero, duration: duration)
instruction.layerInstructions = [layer]
let composition = AVMutableVideoComposition()
composition.renderSize = CGSize(width: side, height: side)
composition.frameDuration = CMTime(value: 1, timescale: 60)
composition.instructions = [instruction]

// The credit, burned into the bottom trailing corner. Core Animation's origin is the bottom left.
let frame = CGRect(x: 0, y: 0, width: side, height: side)
let video = CALayer()
video.frame = frame
// Drawn into an image, since a CATextLayer never draws its text in an offline export.
func creditImage(height: CGFloat) -> CGImage? {
    let scale: CGFloat = 2
    let pixelHeight = (height * scale).rounded()
    let font = CTFontCreateWithName("Menlo-Regular" as CFString, pixelHeight * 0.48, nil)
    let text = NSAttributedString(string: "unslop by @heydamir", attributes: [
        NSAttributedString.Key(kCTFontAttributeName as String): font,
        NSAttributedString.Key(kCTForegroundColorFromContextAttributeName as String): true,
    ])
    let line = CTLineCreateWithAttributedString(text)
    var ascent: CGFloat = 0, descent: CGFloat = 0
    let textWidth = CGFloat(CTLineGetTypographicBounds(line, &ascent, &descent, nil))
    let pixelWidth = (textWidth + pixelHeight).rounded()
    guard let space = CGColorSpace(name: CGColorSpace.sRGB),
          let context = CGContext(
              data: nil, width: Int(pixelWidth), height: Int(pixelHeight), bitsPerComponent: 8,
              bytesPerRow: 0, space: space, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
          )
    else { return nil }
    let bounds = CGRect(x: 0, y: 0, width: pixelWidth, height: pixelHeight)
    context.addPath(CGPath(roundedRect: bounds, cornerWidth: pixelHeight / 2, cornerHeight: pixelHeight / 2, transform: nil))
    context.setFillColor(CGColor(gray: 0, alpha: 0.5))
    context.fillPath()
    context.setFillColor(CGColor(gray: 1, alpha: 0.9))
    context.textPosition = CGPoint(x: pixelHeight / 2, y: (pixelHeight - ascent - descent) / 2 + descent)
    CTLineDraw(line, context)
    return context.makeImage()
}
guard let creditPicture = creditImage(height: (side * 0.04).rounded()) else { fail("cannot draw the credit.") }
let credit = CALayer()
credit.contents = creditPicture
let creditSize = CGSize(width: CGFloat(creditPicture.width) / 2, height: CGFloat(creditPicture.height) / 2)
credit.frame = CGRect(origin: CGPoint(x: side - creditSize.width - side * 0.03, y: side * 0.03), size: creditSize)
let canvas = CALayer()
canvas.frame = frame
canvas.addSublayer(video)
canvas.addSublayer(credit)
composition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: video, in: canvas)

guard let session = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality) else {
    fail("this Mac cannot export \(input.path).")
}
session.videoComposition = composition
let start = CMTime(seconds: trim, preferredTimescale: 600)
guard start < duration else { fail("the recording is shorter than the \(trim) seconds to trim.") }
session.timeRange = CMTimeRange(start: start, end: duration)
try? FileManager.default.removeItem(at: output)
do {
    try await session.export(to: output, as: .mp4)
} catch {
    fail("export failed: \(error.localizedDescription)")
}

let result = AVURLAsset(url: output)
let length = try await result.load(.duration).seconds
let frames = AVAssetImageGenerator(asset: result)
frames.requestedTimeToleranceBefore = .zero
frames.requestedTimeToleranceAfter = .zero
let base = output.deletingPathExtension().path
for (index, share) in [0.05, 0.5, 0.97].enumerated() {
    let time = CMTime(seconds: length * share, preferredTimescale: 600)
    let (image, _) = try await frames.image(at: time)
    let url = URL(fileURLWithPath: "\(base)-frame-\(index + 1).png")
    guard let destination = CGImageDestinationCreateWithURL(url as CFURL, UTType.png.identifier as CFString, 1, nil) else {
        fail("cannot write \(url.path).")
    }
    CGImageDestinationAddImage(destination, image, nil)
    guard CGImageDestinationFinalize(destination) else { fail("cannot write \(url.path).") }
}
