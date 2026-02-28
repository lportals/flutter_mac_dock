import 'package:flutter/material.dart';

/// Visual configuration for the [MacDock] widget.
///
/// Controls sizing, magnification behavior, glassmorphism appearance, and
/// tooltip styling. All properties have sensible defaults matching a
/// macOS-style dock.
///
/// Example:
/// ```dart
/// DockStyle(
///   iconSize: 56,
///   magnification: 1.0,
///   range: 180,
///   backgroundColor: Colors.black.withOpacity(0.3),
/// )
/// ```
class DockStyle {
  /// The base size of each dock icon in logical pixels.
  /// Defaults to `48.0`.
  final double iconSize;

  /// How much icons grow when hovered. A value of `0.8` means icons can
  /// grow up to 80% larger than [iconSize]. Defaults to `0.8`.
  final double magnification;

  /// The distance in logical pixels from the cursor within which icons
  /// start to magnify. Defaults to `150.0`.
  final double range;

  /// Horizontal padding inside the dock container. Defaults to `12.0`.
  final double paddingHorizontal;

  /// Bottom padding inside the dock container. Defaults to `8.0`.
  final double paddingBottom;

  /// Horizontal margin around each dock item. Defaults to `4.0`.
  final double itemMargin;

  /// Background color of the dock. Applied behind the blur filter.
  /// Defaults to `Colors.white` at 15% opacity.
  final Color backgroundColor;

  /// Border radius of the dock container. Defaults to `20.0`.
  final double borderRadius;

  /// Blur intensity for the glassmorphism effect. Defaults to `15.0`.
  final double blurSigma;

  /// Fixed height of the dock background container. Defaults to `78.0`.
  final double dockHeight;

  /// Width of the optional divider line between item groups.
  /// Defaults to `1.0`.
  final double dividerWidth;

  /// Horizontal margin on each side of the divider. Defaults to `12.0`.
  final double dividerMargin;

  /// Color of the divider line. Defaults to white at 30% opacity.
  final Color dividerColor;

  /// Border color of the dock container.
  /// Defaults to white at 20% opacity.
  final Color borderColor;

  /// Whether to show a selection indicator dot below selected items.
  /// Defaults to `true`.
  final bool showIndicator;

  /// Color of the selection indicator dot. Defaults to `Colors.black87`.
  final Color indicatorColor;

  /// Text style for the tooltip label. If null, a default style is used.
  final TextStyle? tooltipTextStyle;

  /// Background color for the tooltip bubble.
  /// Defaults to black at 90% opacity.
  final Color tooltipBackgroundColor;

  /// Creates a dock style configuration with macOS-like defaults.
  const DockStyle({
    this.iconSize = 48.0,
    this.magnification = 0.8,
    this.range = 150.0,
    this.paddingHorizontal = 12.0,
    this.paddingBottom = 8.0,
    this.itemMargin = 4.0,
    this.backgroundColor = const Color(0x26FFFFFF),
    this.borderRadius = 20.0,
    this.blurSigma = 15.0,
    this.dockHeight = 78.0,
    this.dividerWidth = 1.0,
    this.dividerMargin = 12.0,
    this.dividerColor = const Color(0x4DFFFFFF),
    this.borderColor = const Color(0x33FFFFFF),
    this.showIndicator = true,
    this.indicatorColor = const Color(0xDE000000),
    this.tooltipTextStyle,
    this.tooltipBackgroundColor = const Color(0xE6000000),
  });
}
