import 'dart:ui';
import 'package:flutter/material.dart';

/// A glassmorphic tooltip bubble with a small downward-pointing triangle.
///
/// Used internally by [MacDock] to display item labels on hover. The tooltip
/// fades in/out based on the [visible] flag.
class DockTooltip extends StatelessWidget {
  /// The text to display in the tooltip.
  final String text;

  /// Whether the tooltip is currently visible.
  final bool visible;

  /// Background color of the tooltip bubble.
  final Color backgroundColor;

  /// Optional text style override. If null, a default white style is used.
  final TextStyle? textStyle;

  /// Creates a dock tooltip.
  const DockTooltip({
    super.key,
    required this.text,
    required this.visible,
    this.backgroundColor = const Color(0xE6000000),
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedOpacity(
        duration: Duration.zero,
        opacity: visible ? 1.0 : 0.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.1),
                      width: 0.5,
                    ),
                  ),
                  child: Text(
                    text,
                    style: textStyle ??
                        const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
              ),
            ),
            CustomPaint(
              size: const Size(10, 5),
              painter: _TrianglePainter(
                color: backgroundColor.withValues(alpha: 0.85),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Paints a small downward-pointing triangle, used as the tooltip arrow.
class _TrianglePainter extends CustomPainter {
  /// The fill color of the triangle.
  final Color color;

  _TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
