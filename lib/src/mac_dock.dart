import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';

import 'dock_item.dart';
import 'dock_style.dart';
import 'dock_tooltip.dart';

/// A macOS-style dock widget with smooth magnification on hover.
///
/// Items scale up as the cursor approaches them, creating the iconic
/// macOS dock "fish-eye" effect. The dock features a glassmorphism
/// background with blur, optional dividers between item groups, and
/// animated tooltips.
///
/// {@tool snippet}
/// A simple dock with icons and a divider after the third item:
///
/// ```dart
/// MacDock(
///   items: [
///     DockItem(label: 'Finder', icon: Icon(Icons.folder)),
///     DockItem(label: 'Safari', icon: Icon(Icons.language)),
///     DockItem(label: 'Mail', icon: Icon(Icons.mail)),
///     DockItem(label: 'Settings', icon: Icon(Icons.settings)),
///   ],
///   dividerIndices: [2],
///   style: const DockStyle(magnification: 0.8),
/// )
/// ```
/// {@end-tool}
class MacDock extends StatefulWidget {
  /// The list of items to display in the dock.
  final List<DockItem> items;

  /// Visual configuration for the dock. See [DockStyle] for available
  /// options. If null, default macOS-like styling is applied.
  final DockStyle style;

  /// Indices after which a vertical divider is rendered.
  ///
  /// For example, `[2]` places a divider after the third item (index 2).
  final List<int> dividerIndices;

  /// Called when the hovered item changes. Receives the item index or
  /// `null` when the cursor exits the dock.
  final ValueChanged<int?>? onItemHover;

  /// Creates a macOS-style magnifying dock.
  const MacDock({
    super.key,
    required this.items,
    this.style = const DockStyle(),
    this.dividerIndices = const [],
    this.onItemHover,
  });

  @override
  State<MacDock> createState() => _MacDockState();
}

class _MacDockState extends State<MacDock> {
  double? _hoverX;
  int? _lastHoveredIndex;

  DockStyle get _s => widget.style;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final parentWidth = constraints.maxWidth;

        // Build a flat list of "segments" that alternate between items
        // and optional dividers, so we can calculate positions uniformly.
        final segments = _buildSegments();

        // Calculate the static width of each segment to find the dock center.
        final totalStaticWidth = _paddingWidth +
            segments.fold<double>(0, (sum, seg) => sum + seg.staticWidth);

        final dockStaticStart = (parentWidth - totalStaticWidth) / 2;

        // Calculate center X for each item segment (ignoring dividers).
        final itemCenters = <int, double>{};
        double cursor = dockStaticStart + _s.paddingHorizontal;
        for (final seg in segments) {
          if (seg.itemIndex != null) {
            itemCenters[seg.itemIndex!] = cursor + seg.staticWidth / 2;
          }
          cursor += seg.staticWidth;
        }

        // Calculate the dynamic (magnified) width of the dock background.
        double totalDynamicWidth = _paddingWidth;
        for (final seg in segments) {
          if (seg.itemIndex != null) {
            final scale = _calculateScale(itemCenters[seg.itemIndex!]!);
            totalDynamicWidth += (_s.iconSize * scale) + (_s.itemMargin * 2);
          } else {
            totalDynamicWidth += seg.staticWidth;
          }
        }

        // Find the closest item to the cursor for tooltip display.
        final closestIndex = _findClosestItem(itemCenters);

        return MouseRegion(
          onHover: (event) {
            setState(() => _hoverX = event.localPosition.dx);
            final newClosest = _findClosestItem(itemCenters);
            if (newClosest != _lastHoveredIndex) {
              _lastHoveredIndex = newClosest;
              widget.onItemHover?.call(newClosest);
            }
          },
          onExit: (_) {
            setState(() {
              _hoverX = null;
              _lastHoveredIndex = null;
            });
            widget.onItemHover?.call(null);
          },
          child: Stack(
            alignment: Alignment.bottomCenter,
            clipBehavior: Clip.none,
            children: [
              // Glassmorphism background
              _buildBackground(totalDynamicWidth),

              // Icon layer
              Padding(
                padding: EdgeInsets.only(bottom: _s.paddingBottom),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: _buildItemWidgets(
                    itemCenters,
                    closestIndex,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Layout helpers
  // ---------------------------------------------------------------------------

  double get _paddingWidth => _s.paddingHorizontal * 2;

  /// Calculates the magnification scale for an item based on cursor distance.
  ///
  /// Uses a cosine curve for smooth falloff: items at the cursor position
  /// scale maximally, and the effect diminishes smoothly to 1.0 at [range].
  double _calculateScale(double itemCenterX) {
    if (_hoverX == null) return 1.0;
    final distance = (_hoverX! - itemCenterX).abs();
    if (distance > _s.range) return 1.0;
    final normalizedDist = (distance / _s.range).clamp(0.0, 1.0);
    final factor = math.cos(normalizedDist * math.pi / 2);
    return 1.0 + (_s.magnification * factor);
  }

  /// Finds the index of the item closest to the cursor, or null.
  int? _findClosestItem(Map<int, double> itemCenters) {
    if (_hoverX == null) return null;
    int? closest;
    double minDist = double.infinity;
    for (final entry in itemCenters.entries) {
      final dist = (_hoverX! - entry.value).abs();
      if (dist < minDist) {
        minDist = dist;
        closest = entry.key;
      }
    }
    return closest;
  }

  /// Builds a flat list of segments (items + dividers) for position calculation.
  List<_Segment> _buildSegments() {
    final segments = <_Segment>[];
    final dividerSet = widget.dividerIndices.toSet();
    final itemWidth = _s.iconSize + (_s.itemMargin * 2);

    for (int i = 0; i < widget.items.length; i++) {
      segments.add(_Segment(
        itemIndex: i,
        staticWidth: itemWidth,
      ));
      if (dividerSet.contains(i)) {
        segments.add(_Segment(
          itemIndex: null,
          staticWidth: _s.dividerWidth + (_s.dividerMargin * 2),
        ));
      }
    }
    return segments;
  }

  // ---------------------------------------------------------------------------
  // Widget builders
  // ---------------------------------------------------------------------------

  /// Builds the glassmorphism dock background.
  Widget _buildBackground(double width) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOutCubic,
      height: _s.dockHeight,
      width: width,
      decoration: BoxDecoration(
        color: _s.backgroundColor,
        borderRadius: BorderRadius.circular(_s.borderRadius),
        border: Border.all(color: _s.borderColor, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 40,
            spreadRadius: 5,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_s.borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: _s.blurSigma,
            sigmaY: _s.blurSigma,
          ),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }

  /// Builds the row of item widgets with optional dividers.
  List<Widget> _buildItemWidgets(
    Map<int, double> itemCenters,
    int? closestIndex,
  ) {
    final widgets = <Widget>[];
    final dividerSet = widget.dividerIndices.toSet();

    for (int i = 0; i < widget.items.length; i++) {
      final item = widget.items[i];
      final scale = _calculateScale(itemCenters[i]!);

      widgets.add(
        _MacDockItemWidget(
          item: item,
          scale: scale,
          showTooltip: closestIndex == i && scale > 1.2,
          style: _s,
        ),
      );

      // Insert divider after this item if requested.
      if (dividerSet.contains(i)) {
        widgets.add(
          Container(
            width: _s.dividerWidth,
            height: 40,
            margin: EdgeInsets.symmetric(
              horizontal: _s.dividerMargin,
              vertical: 12,
            ),
            color: _s.dividerColor,
          ),
        );
      }
    }
    return widgets;
  }
}

// -----------------------------------------------------------------------------
// Internal widgets
// -----------------------------------------------------------------------------

/// Renders a single dock item with smooth scale animation and tooltip.
class _MacDockItemWidget extends StatelessWidget {
  final DockItem item;
  final double scale;
  final bool showTooltip;
  final DockStyle style;

  const _MacDockItemWidget({
    required this.item,
    required this.scale,
    required this.showTooltip,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeOutCubic,
      tween: Tween<double>(end: scale),
      builder: (context, animScale, child) {
        final animSize = style.iconSize * animScale;

        return Container(
          margin: EdgeInsets.symmetric(horizontal: style.itemMargin),
          width: animSize,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              // Tooltip
              Positioned(
                bottom: animSize + 20,
                child: DockTooltip(
                  text: item.label,
                  visible: showTooltip,
                  backgroundColor: style.tooltipBackgroundColor,
                  textStyle: style.tooltipTextStyle,
                ),
              ),

              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon container
                  GestureDetector(
                    onTap: item.onTap,
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Container(
                        width: animSize,
                        height: animSize,
                        // antiAliasWithSaveLayer provides smoother sub-pixel edge rendering
                        // which is crucial when scaling icons during magnification.
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        decoration: ShapeDecoration(
                          // RoundedSuperellipseBorder mathematically matches Apple's
                          // continuous superellipse shape used in macOS and iOS icons.
                          // It prevents the "pinched" look that simple ContinuousRectangleBorder
                          // produces. A radius of ~28% of the width matches the Apple ratio.
                          shape: RoundedSuperellipseBorder(
                            borderRadius:
                                BorderRadius.circular(animSize * 0.28),
                          ),
                          shadows: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 10 * animScale,
                              offset: Offset(0, 5 * animScale),
                            ),
                            if (item.isSelected)
                              BoxShadow(
                                color: Colors.white.withValues(alpha: 0.2),
                                blurRadius: 20,
                                spreadRadius: -2,
                              ),
                          ],
                        ),
                        child: item.icon,
                      ),
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Selection indicator dot
                  if (style.showIndicator)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: item.isSelected ? 4 : 0,
                      height: 4,
                      decoration: BoxDecoration(
                        color: item.isSelected
                            ? style.indicatorColor
                            : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Internal helper representing a layout segment (item or divider).
class _Segment {
  final int? itemIndex;
  final double staticWidth;

  const _Segment({required this.itemIndex, required this.staticWidth});
}
