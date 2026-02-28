import 'package:flutter/material.dart';
import 'package:flutter_mac_dock/flutter_mac_dock.dart';

/// Example app demonstrating the [MacDock] widget.
void main() => runApp(const MacDockExampleApp());

/// Root widget for the example app.
class MacDockExampleApp extends StatelessWidget {
  const MacDockExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Mac Dock Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: const DockExampleScreen(),
    );
  }
}

/// A screen that places the MacDock at the bottom of a dark background,
/// mimicking a macOS desktop.
class DockExampleScreen extends StatefulWidget {
  const DockExampleScreen({super.key});

  @override
  State<DockExampleScreen> createState() => _DockExampleScreenState();
}

class _DockExampleScreenState extends State<DockExampleScreen> {
  int? _selectedIndex;

  /// Sample dock items using actual image assets
  static const _iconConfigs = [
    (label: 'GitHub', imagePath: 'assets/github.png'),
    (label: 'Email', imagePath: 'assets/email.png'),
    (label: 'LinkedIn', imagePath: 'assets/linkedin.png'),
    (label: 'X / Twitter', imagePath: 'assets/xlogo.png'),
    (label: 'Taskagotchi', imagePath: 'assets/taskagotchi.png'),
    (label: 'Viste', imagePath: 'assets/viste.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF2C2C3E),
                  Color(0xFF1C1C2E),
                  Color(0xFF0D0D14),
                ],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.desktop_mac_rounded,
                    size: 80,
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Hover over the dock below',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.3),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Dock pinned to the bottom
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 120, // Provide some headroom for magnification
              child: MacDock(
                items: _iconConfigs.asMap().entries.map((entry) {
                  final i = entry.key;
                  final cfg = entry.value;
                  return DockItem(
                    label: cfg.label,
                    isSelected: _selectedIndex == i,
                    icon: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        cfg.imagePath,
                        fit: BoxFit.cover,
                      ),
                    ),
                    onTap: () => setState(() => _selectedIndex = i),
                  );
                }).toList(),
                dividerIndices: const [3],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
