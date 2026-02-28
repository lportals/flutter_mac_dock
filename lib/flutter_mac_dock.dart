/// A macOS-style dock widget for Flutter with smooth magnification on hover.
///
/// This package provides the [MacDock] widget that recreates the iconic
/// macOS dock magnification effect. Icons smoothly scale up as the cursor
/// approaches, with a glassmorphism background and animated tooltips.
///
/// ## Quick Start
///
/// ```dart
/// import 'package:flutter_mac_dock/flutter_mac_dock.dart';
///
/// MacDock(
///   items: [
///     DockItem(label: 'Finder', icon: Icon(Icons.folder)),
///     DockItem(label: 'Safari', icon: Icon(Icons.language)),
///     DockItem(label: 'Settings', icon: Icon(Icons.settings)),
///   ],
/// )
/// ```
library;

export 'src/dock_item.dart';
export 'src/dock_style.dart';
export 'src/mac_dock.dart';
