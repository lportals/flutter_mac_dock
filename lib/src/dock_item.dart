import 'package:flutter/widgets.dart';

/// A single item to display in the [MacDock].
///
/// Each item has a [label] shown as a tooltip on hover, an [icon] widget
/// rendered inside the dock slot, and an [onTap] callback for interaction.
///
/// Example:
/// ```dart
/// DockItem(
///   label: 'Safari',
///   icon: Image.asset('assets/safari.png'),
///   onTap: () => print('Tapped Safari'),
/// )
/// ```
class DockItem {
  /// The tooltip text displayed above the item on hover.
  final String label;

  /// The widget rendered as the item's icon. Can be an [Image], [Icon],
  /// or any custom widget.
  final Widget icon;

  /// Called when the user taps this item.
  final VoidCallback? onTap;

  /// Whether this item is currently selected. When `true`, a small
  /// indicator dot is rendered below the icon.
  final bool isSelected;

  /// Creates a dock item.
  const DockItem({
    required this.label,
    required this.icon,
    this.onTap,
    this.isSelected = false,
  });
}
