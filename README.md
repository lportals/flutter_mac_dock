# Flutter Mac Dock

A macOS-style dock widget for Flutter with smooth magnification on hover, glassmorphism background, and animated tooltips.

**Zero external dependencies** — only requires the Flutter SDK.

<p align="center">
  <img src="https://raw.githubusercontent.com/lportals/flutter_mac_dock/main/doc/preview.gif" alt="Flutter Mac Dock Preview" width="600"/>
</p>

## Features

- 🔍 **Cosine-based magnification** — Icons smoothly scale as the cursor approaches, just like the macOS dock
- 🪟 **Glassmorphism background** — Blurred, translucent container with configurable opacity
- 💬 **Animated tooltips** — Labels appear above hovered items with a frosted-glass effect
- 🎨 **Fully customizable** — Control icon size, magnification intensity, range, colors, and more via `DockStyle`
- ➗ **Dividers** — Optional separators between item groups
- ⚡ **Zero dependencies** — Pure Flutter, no external packages required
- 📱 **Framework-agnostic** — Works with Provider, Riverpod, Bloc, or plain `setState`

## Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_mac_dock:
    git:
      url: https://github.com/lportals/flutter_mac_dock.git
```

## Quick Start

```dart
import 'package:flutter_mac_dock/flutter_mac_dock.dart';

MacDock(
  items: [
    DockItem(
      label: 'Finder',
      icon: Icon(Icons.folder, color: Colors.blue),
      onTap: () => print('Finder tapped'),
    ),
    DockItem(
      label: 'Safari',
      icon: Icon(Icons.language, color: Colors.blue),
      onTap: () => print('Safari tapped'),
    ),
    DockItem(
      label: 'Mail',
      icon: Icon(Icons.mail, color: Colors.blue),
      onTap: () => print('Mail tapped'),
    ),
  ],
)
```

## Customization

Use `DockStyle` to control the appearance:

```dart
MacDock(
  items: myItems,
  dividerIndices: [3],  // Divider after the 4th item
  style: DockStyle(
    iconSize: 56,              // Base icon size
    magnification: 1.0,        // Max magnification (100% growth)
    range: 180,                // Hover influence range in pixels
    backgroundColor: Colors.black.withOpacity(0.3),
    borderRadius: 24,
    blurSigma: 20,
    showIndicator: true,       // Selection dot below items
  ),
  onItemHover: (index) {
    // React to hover changes (e.g., update a preview)
  },
)
```

## API Reference

### `MacDock`

| Property | Type | Default | Description |
|---|---|---|---|
| `items` | `List<DockItem>` | required | The dock items to display |
| `style` | `DockStyle` | `DockStyle()` | Visual configuration |
| `dividerIndices` | `List<int>` | `[]` | Indices after which to place dividers |
| `onItemHover` | `ValueChanged<int?>?` | `null` | Hover change callback |

### `DockItem`

| Property | Type | Default | Description |
|---|---|---|---|
| `label` | `String` | required | Tooltip text |
| `icon` | `Widget` | required | The icon widget to render |
| `onTap` | `VoidCallback?` | `null` | Tap callback |
| `isSelected` | `bool` | `false` | Shows selection indicator |

### `DockStyle`

| Property | Type | Default | Description |
|---|---|---|---|
| `iconSize` | `double` | `48.0` | Base icon size |
| `magnification` | `double` | `0.8` | Max magnification factor |
| `range` | `double` | `150.0` | Hover influence distance |
| `backgroundColor` | `Color` | White 15% | Dock background color |
| `borderRadius` | `double` | `20.0` | Container border radius |
| `blurSigma` | `double` | `15.0` | Glassmorphism blur intensity |
| `showIndicator` | `bool` | `true` | Show selection dot |

## How It Works

The magnification algorithm uses a **cosine curve** to calculate the scale factor for each item based on its distance from the cursor:

```
scale = 1.0 + magnification × cos(distance / range × π/2)
```

This produces a smooth bell-curve falloff where the item directly under the cursor is maximally scaled, and the effect gradually diminishes to 1.0 at the edge of the `range`.

## License

MIT License — see [LICENSE](LICENSE) for details.

## Author

**Luis Portal** — [Portfolio](https://portfolio-lportals-projects.vercel.app/) · [LinkedIn](https://www.linkedin.com/in/lportal/) · [GitHub](https://github.com/lportals)
