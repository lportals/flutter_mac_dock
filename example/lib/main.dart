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

  /// Sample dock items using Material icons as stand-ins for app icons.
  static const _iconConfigs = [
    (label: 'Finder', icon: Icons.folder_rounded, color: Color(0xFF5EB3F6)),
    (label: 'Safari', icon: Icons.language_rounded, color: Color(0xFF4A90D9)),
    (
      label: 'Messages',
      icon: Icons.chat_bubble_rounded,
      color: Color(0xFF6AD85E)
    ),
    (label: 'Music', icon: Icons.music_note_rounded, color: Color(0xFFFA5757)),
    (
      label: 'Photos',
      icon: Icons.photo_library_rounded,
      color: Color(0xFFF6D04A)
    ),
    (label: 'Mail', icon: Icons.mail_rounded, color: Color(0xFF5EB3F6)),
    (label: 'Maps', icon: Icons.map_rounded, color: Color(0xFF4CAF50)),
    (label: 'Settings', icon: Icons.settings_rounded, color: Color(0xFF9E9E9E)),
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
            child: MacDock(
              items: _iconConfigs.asMap().entries.map((entry) {
                final i = entry.key;
                final cfg = entry.value;
                return DockItem(
                  label: cfg.label,
                  isSelected: _selectedIndex == i,
                  icon: Container(
                    decoration: BoxDecoration(
                      color: cfg.color,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Icon(
                        cfg.icon,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                  onTap: () => setState(() => _selectedIndex = i),
                );
              }).toList(),
              dividerIndices: const [4],
              onItemHover: (index) {
                // You could show previews, update a 3D model, etc.
              },
            ),
          ),
        ],
      ),
    );
  }
}
