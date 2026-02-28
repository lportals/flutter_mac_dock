import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_mac_dock/flutter_mac_dock.dart';

void main() {
  group('MacDock', () {
    testWidgets('renders items correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MacDock(
              items: [
                DockItem(
                  label: 'Test Item 1',
                  icon: const Icon(Icons.star),
                ),
                DockItem(
                  label: 'Test Item 2',
                  icon: const Icon(Icons.home),
                ),
              ],
            ),
          ),
        ),
      );

      // The dock should render both items.
      expect(find.byType(MacDock), findsOneWidget);
    });

    testWidgets('renders with divider', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MacDock(
              items: [
                DockItem(label: 'A', icon: const Icon(Icons.abc)),
                DockItem(label: 'B', icon: const Icon(Icons.bed)),
                DockItem(label: 'C', icon: const Icon(Icons.cake)),
              ],
              dividerIndices: const [1],
            ),
          ),
        ),
      );

      expect(find.byType(MacDock), findsOneWidget);
    });

    testWidgets('calls onTap when item is tapped', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MacDock(
              items: [
                DockItem(
                  label: 'Tappable',
                  icon: const Icon(Icons.touch_app),
                  onTap: () => tapped = true,
                ),
              ],
            ),
          ),
        ),
      );

      await tester.tap(find.byType(GestureDetector).first);
      expect(tapped, isTrue);
    });
  });

  group('DockItem', () {
    test('defaults isSelected to false', () {
      final item = DockItem(
        label: 'Test',
        icon: const Icon(Icons.star),
      );
      expect(item.isSelected, isFalse);
    });
  });

  group('DockStyle', () {
    test('has correct default values', () {
      const style = DockStyle();
      expect(style.iconSize, 48.0);
      expect(style.magnification, 0.8);
      expect(style.range, 150.0);
      expect(style.borderRadius, 20.0);
      expect(style.blurSigma, 15.0);
      expect(style.showIndicator, isTrue);
    });
  });
}
