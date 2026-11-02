# Fresh-eye review

The brief for the review after the Check step in a full run. A second agent judges the finished screen from its screenshots, without the reasons behind it, so it sees what a person will see.

## What to hand over

Give the reviewer this file and only these:

- The before and after screenshots, light, dark and `-ax`, plus any `#Preview` renders you made of states and of sections below the first screen.
- The Product and Task lines of the direction, and its closest Apple screen.
- [signs.md](signs.md) and the Checklist section of [SKILL.md](../SKILL.md).

Nothing else. Not the rest of the direction, the audit, your plan, your reasons for a change or the draft report.

## The reviewer's brief

You are reviewing a SwiftUI screen someone else redesigned. Judge the screenshots, not the code and not the intent behind them.

Start with one question. Does this screen answer this product and this task, or could it be any app in its category with the name swapped? A screen the product did not shape is a finding, ranked first, even when every check passes.

Then look at it the way the most exacting designer you know would, the one who screenshots the single wrong thing and sends it back with "what is this?". Go through signs.md and the checklist, and answer each item from a screenshot.

Hold the after screenshot next to the closest Apple screen and say the one difference in quality, like hierarchy, density, spacing, type or how the subject reads. Likeness is not the bar. A screen that copies the Apple app's layout or tint is a finding too.

Return a ranked list. Structure and hierarchy first, then spacing and layout, then color, type and symbols, then details and motion. Each item says what you would screenshot, which file shows it, and the fix in one line. Then say what you could not check, like VoiceOver, a section below the first screen or an iPad layout. If there is nothing, say "nothing" and list the files you looked at.

- A finding needs a screenshot, so name the file. A predicted failure is not a finding, and neither is a predicted pass.
- When a state you need is not in the files, render its `#Preview` if Xcode's preview tool is available, and otherwise list it under what you could not check. Do not run `sim.sh`.
- Rank by how much of the screen a finding spoils, not by how easy it is to fix.
- Do not fix anything, and do not soften a finding because the screen is nearly there.
- Platform conventions are not findings. The large title, the tab bar, glass bars and toolbar buttons, swipe actions, Settings-style rows in a settings screen and Messages' blue bubbles stay. Send back a hand-built or restyled copy of a system control, or an invented accent, never the convention itself.

## Using the findings

- Look at each finding's screenshot again before you act on it. Fix the ones that hold up, and snapshot again only when the fixes change the first screen, within the run's limit of three snapshots.
- A finding you think is intentional gets one more look. If it still stands, say why in the report. Never clear a finding by hiding the thing it points at.
- List every finding in the report with what you did about it.

---

Adapted from unslop by Damir Sokolovsky ([@heydamir](https://x.com/heydamir)), CC BY 4.0, rewritten for SwiftUI. Keep this credit in copies and adaptations. The review brief follows the one in [Stageshow](https://github.com/benjitaylor/skills) by Benji Taylor.
