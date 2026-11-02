# References

Pick the closest Apple screen from the table below when you write the direction, and look at all of these before the Visuals pass. Take their qualities, never their subject, palette or layout, so every product still gets its own screen.

## Apple's own apps

The best reference for an app on Apple platforms is the platform itself. Open these on a device or in the simulator and study the quality named, not the look.

| App | What to study |
| --- | --- |
| Weather | The content is the moment. The sky behind the forecast shows the real weather, and the chrome is plain text over it |
| Fitness | A signature used everywhere, the three rings, with rounded figures on black and color that always means the same ring |
| Wallet | Real objects drawn in code. Cards at their true ratio, with their own material, stacked like a real wallet |
| Stocks | One main chart per screen, scrubbable, with color reserved for up and down |
| Health | Each category keeps one color and one symbol across every screen, so color carries meaning |
| Maps | Liquid Glass done right. Controls float over the content in glass, and the map stays the subject |
| Photos | Content first. The interface gets out of the way, and the photos fill the screen edge to edge |
| Journal | A warm, personal character inside a fully native structure, without a single custom bar |
| Settings | The convention for lists, sections, footers and icon tiles. Use it for settings, not for the whole app |

What they share: one subject per screen, system structure everyone already knows, color that always means something, and a detail only that app has.

## The closest Apple screen

The direction names the Apple screen whose task is closest to the one being unslopped, and the Check step holds the result next to it. It is the bar for quality, never for likeness. Compare how the subject reads, the hierarchy, the density, the spacing and the care in the details. Never copy its layout, tint or type, since every product still gets its own screen.

| The screen | Closest Apple screen | Hold it to |
| --- | --- | --- |
| A dashboard of figures and a chart | Health, Summary. Stocks, one symbol | One answer first, figures whole, one chart that is clearly the biggest thing |
| A list of things people open | Mail, the inbox. Reminders, a list | One line people scan by, one line of detail, a trailing date, swipe actions |
| Transactions or activity | Wallet, a card's Latest Transactions | Who, one line of context, the amount trailing, grouped by day |
| Settings and preferences | Settings | Grouped sections, footers that explain, icon tiles by category |
| The detail of one thing | Contacts, a contact. Wallet, a pass | Its identity first, its actions next, then its facts in groups |
| A library of media | Photos, Library. Music, Library | Content edge to edge, chrome out of the way |
| Progress toward a goal | Fitness, Summary | One signature that always means the same thing |
| A task on a map | Maps | Glass controls over the map, a sheet with detents |
| Creating or editing something | Calendar, New Event. Reminders, Details | Form sections, Cancel and the action in the toolbar |
| A conversation | Messages | Bubbles, the composer, timestamps only where time passes |
| Writing or reflection | Journal. Notes | A warm character inside a fully native structure |

Settings and Contacts ship on the iOS simulator with content, so for a settings screen or a list of people a screenshot is a real reference. Launch one with `xcrun simctl launch booted com.apple.Preferences` or `com.apple.MobileAddressBook`, then `xcrun simctl io booted screenshot unslop/apple.png`. Most other Apple apps open empty in the simulator or on a What's New sheet, so compare against what you know of them, or against a screenshot the user shares.

## Finished screens by Damir Sokolovsky

These come from the original web version of unslop. They are web screens, but the qualities carry over to apps and welcome pages.

| File | What it shows | Why it works |
| --- | --- | --- |
| [unslop-dashboard-after.webp](refs/unslop-dashboard-after.webp) | A finance dashboard with two rendered payment cards and a revenue chart drawn as soft colored curves over a mirrored grey comparison | Quiet chrome, and all the color lives in two moments, a real looking object and a chart where every color means a series |
| [unslop-hero-after.webp](refs/unslop-hero-after.webp) | An invoicing hero with a paper plane drawn in digits and currency signs, small notes pinned to it, and the product rising from below | The visual is made of the product's own material, money, so it is the moment and the signature at once. Text sits on calm sky |
| [beacon-engraving.webp](refs/beacon-engraving.webp) | An incident monitoring hero drawn as one blue engraving of a lighthouse on a rocky coast, with a serif headline in the same ink | A print style working because the whole page is in it. One ink, one paper tone, and the headline sits in the calm sky |
| [meadow-3d.webp](refs/meadow-3d.webp) | A footer as a soft 3D meadow with a few matte crystal shapes and a huge wordmark standing behind the hills | Friendly stylized 3D with a restrained palette, type that becomes part of the scene, and quiet links on the open sky |
| [story-dashboard-frames.webp](refs/story-dashboard-frames.webp) | Eight frames from the story video, a vibecoded dashboard unslopping itself in about 10 seconds | Everything morphs in place in a wave, red redlines measure the slop and turn white when fixed, copy rolls, and the frame is square and cropped close |

What they share with Apple's apps: one clear subject per screen, quiet chrome around it, color that carries meaning, and a visual that can be explained in one sentence.

---

Adapted from unslop by Damir Sokolovsky ([@heydamir](https://x.com/heydamir)), CC BY 4.0, rewritten for SwiftUI. Keep this credit in copies and adaptations.
