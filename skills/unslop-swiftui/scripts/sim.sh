#!/usr/bin/env bash
# Build a SwiftUI app for an iOS or iPadOS simulator and capture what people see.
#
#   sim.sh snapshot [options] [-- launch arguments]
#     Saves <out>/<name>-light.png, <name>-dark.png and <name>-ax.png. The last one
#     is light mode at the largest accessibility text size, to check Dynamic Type.
#
#   sim.sh record [options] [-- launch arguments]
#     Records the screen for --seconds and saves a square <out>/<name>.mp4 cropped
#     with --crop, plus three frames to check it, <name>-frame-1.png to -3.png.
#     Launch the app into its story view, for example `-- -UnslopStory`.
#
# Options
#   --scheme NAME          Scheme to build. Default: the project's name.
#   --project PATH         .xcodeproj to build. Default: the only one in the current folder.
#   --workspace PATH       .xcworkspace to build instead of a project.
#   --device NAME          Simulator name from `xcrun simctl list devices available`, like
#                          "iPhone 17 Pro".
#                          Default: the booted iPhone, otherwise the newest available iPhone.
#   --out DIR              Output folder. Default: unslop
#   --name NAME            File name prefix. Default: shot for snapshot, story for record
#   --wait SECONDS         Time to let the screen settle before a screenshot. Default: 3
#   --seconds SECONDS      Recording length. Default: 15
#   --crop X,Y,SIZE        Square to keep from the recording, in pixels. Default: the top
#                          square of the screen.
#   --dark | --light       Appearance for record. Default: the simulator's current one.
#   --no-build             Install the last build instead of building again.
set -euo pipefail

usage() { awk 'NR > 1 && /^#/ { sub(/^# ?/, ""); print; next } NR > 1 { exit }' "$0"; exit "${1:-0}"; }
fail() { echo "sim.sh: $*" >&2; exit 1; }

command="${1:-}"
[[ "$command" == snapshot || "$command" == record ]] || usage 1
shift

scheme="" project="" workspace="" device="" out="unslop" name="" wait_seconds=3
seconds=15 crop="" appearance="" build=1 launch_args=()
while (($#)); do
  case "$1" in
    --scheme) scheme="$2"; shift 2 ;;
    --project) project="$2"; shift 2 ;;
    --workspace) workspace="$2"; shift 2 ;;
    --device) device="$2"; shift 2 ;;
    --out) out="$2"; shift 2 ;;
    --name) name="$2"; shift 2 ;;
    --wait) wait_seconds="$2"; shift 2 ;;
    --seconds) seconds="$2"; shift 2 ;;
    --crop) crop="$2"; shift 2 ;;
    --dark) appearance=dark; shift ;;
    --light) appearance=light; shift ;;
    --no-build) build=0; shift ;;
    -h | --help) usage ;;
    --) shift; launch_args=("$@"); break ;;
    *) fail "unknown option $1. Run sim.sh --help for usage." ;;
  esac
done
[[ -n "$name" ]] || { [[ "$command" == snapshot ]] && name=shot || name=story; }

# Project or workspace.
if [[ -z "$project" && -z "$workspace" ]]; then
  workspaces=(*.xcworkspace) projects=(*.xcodeproj)
  if [[ -e "${workspaces[0]}" && ${#workspaces[@]} -eq 1 ]]; then
    workspace="${workspaces[0]}"
  elif [[ -e "${projects[0]}" && ${#projects[@]} -eq 1 ]]; then
    project="${projects[0]}"
  else
    fail "no single .xcworkspace or .xcodeproj in $(pwd). Pass --project or --workspace."
  fi
fi
if [[ -n "$workspace" ]]; then
  container=(-workspace "$workspace")
  [[ -n "$scheme" ]] || scheme="$(basename "$workspace" .xcworkspace)"
else
  container=(-project "$project")
  [[ -n "$scheme" ]] || scheme="$(basename "$project" .xcodeproj)"
fi

# Simulator. Later runtimes are listed last, so the last match is the newest.
devices="$(xcrun simctl list devices available)"
udid_of() { awk -v prefix="    $1 (" 'index($0, prefix) == 1' <<<"$devices" | tail -1 | grep -oE '[0-9A-F-]{36}' || true; }
if [[ -n "$device" ]]; then
  udid="$(udid_of "$device")"
  [[ -n "$udid" ]] || fail "no available simulator named \"$device\". See xcrun simctl list devices available."
else
  udid="$(grep -E '^    iPhone.*\(Booted\)' <<<"$devices" | head -1 | grep -oE '[0-9A-F-]{36}' || true)"
  [[ -n "$udid" ]] || udid="$(grep -E '^    iPhone' <<<"$devices" | tail -1 | grep -oE '[0-9A-F-]{36}' || true)"
  [[ -n "$udid" ]] || fail "no iPhone simulator available. Add one in Xcode > Window > Devices and Simulators."
fi
xcrun simctl boot "$udid" 2>/dev/null || true
xcrun simctl bootstatus "$udid" -b >/dev/null

# Build, then read where the app landed and its bundle identifier.
destination="id=$udid"
if ((build)); then
  echo "Building $scheme for $(awk -v id="$udid" 'index($0, id) { sub(/^ +/, ""); sub(/ \(.*/, ""); print; exit }' <<<"$devices")"
  xcodebuild "${container[@]}" -scheme "$scheme" -configuration Debug -destination "$destination" build -quiet \
    || fail "the build failed. Fix the errors above and run again."
fi
settings="$(xcodebuild "${container[@]}" -scheme "$scheme" -configuration Debug -destination "$destination" -showBuildSettings -json 2>/dev/null)" \
  || fail "could not read build settings for scheme $scheme."
setting() { plutil -extract "$1.buildSettings.$2" raw -o - - <<<"$settings" 2>/dev/null || true; }
app="" bundle=""
for index in 0 1 2 3 4 5 6 7 8 9; do
  [[ "$(setting "$index" WRAPPER_EXTENSION)" == app ]] || continue
  app="$(setting "$index" TARGET_BUILD_DIR)/$(setting "$index" WRAPPER_NAME)"
  bundle="$(setting "$index" PRODUCT_BUNDLE_IDENTIFIER)"
  break
done
[[ -n "$bundle" && -d "$app" ]] || fail "scheme $scheme has no built app target. Build it once in Xcode or drop --no-build."
xcrun simctl install "$udid" "$app"

# Put the simulator back the way it was when the script ends.
previous_appearance="$(xcrun simctl ui "$udid" appearance)"
previous_size="$(xcrun simctl ui "$udid" content_size)"
restore() {
  [[ "$previous_appearance" == light || "$previous_appearance" == dark ]] && xcrun simctl ui "$udid" appearance "$previous_appearance"
  [[ "$previous_size" == unknown || "$previous_size" == unsupported ]] || xcrun simctl ui "$udid" content_size "$previous_size"
  xcrun simctl status_bar "$udid" clear 2>/dev/null || true
}
trap restore EXIT
xcrun simctl status_bar "$udid" override --time 9:41 --batteryState charged --batteryLevel 100 \
  --cellularMode active --cellularBars 4 --wifiBars 3 2>/dev/null || true

launch() {
  xcrun simctl terminate "$udid" "$bundle" 2>/dev/null || true
  xcrun simctl launch "$udid" "$bundle" ${launch_args[@]+"${launch_args[@]}"} >/dev/null
}

mkdir -p "$out"

if [[ "$command" == snapshot ]]; then
  shoot() { # appearance, content size, file suffix
    xcrun simctl ui "$udid" appearance "$1"
    xcrun simctl ui "$udid" content_size "$2"
    launch
    sleep "$wait_seconds"
    xcrun simctl io "$udid" screenshot --type png "$out/$name-$3.png" >/dev/null 2>&1
    echo "$out/$name-$3.png"
  }
  shoot light large light
  shoot dark large dark
  shoot light accessibility-extra-extra-extra-large ax
  exit 0
fi

# record
[[ -n "$appearance" ]] && xcrun simctl ui "$udid" appearance "$appearance"
raw="$out/$name.raw.mov"
# Launch first and give a freshly installed Debug build about three seconds to draw, so
# the recording opens on the original screen. StoryPlayer holds it for 4.5 seconds.
launch
sleep 3
xcrun simctl io "$udid" recordVideo --codec h264 --force "$raw" >/dev/null 2>&1 &
recorder=$!
sleep "$seconds"
kill -INT "$recorder"
wait "$recorder" || true
[[ -s "$raw" ]] || fail "the recording is empty. Check that the simulator window is not minimized and try again."

# The first half second can be blank while the recorder starts, so it is trimmed.
# Without --crop, crop.swift keeps the top square of the screen.
xcrun swift -suppress-warnings "$(dirname "$0")/crop.swift" "$raw" "$out/$name.mp4" 0.5 ${crop:+"$crop"} \
  || fail "cropping failed. The raw recording is kept at $raw."
rm -f "$raw"
echo "$out/$name.mp4"
