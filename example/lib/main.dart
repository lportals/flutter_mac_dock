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

  static const _iconConfigs = [
    (label: 'Finder', imagePath: 'assets/finder.webp'),
    (label: 'Chrome', imagePath: 'assets/chrome.jpg'),
    (label: 'Notes', imagePath: 'assets/notes.png'),
    (label: 'Settings', imagePath: 'assets/settings.jpg'),
    (label: 'Email', imagePath: 'assets/email.png'),
    (label: 'GitHub', imagePath: 'assets/github.png'),
    (label: 'X / Twitter', imagePath: 'assets/xlogo.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Image.asset(
              'assets/macos_ventura.jpg',
              fit: BoxFit.cover,
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
                style: const DockStyle(
                  indicatorColor: Colors.white,
                  magnification: 0.5,
                ),
                items: _iconConfigs.asMap().entries.map((entry) {
                  final i = entry.key;
                  final cfg = entry.value;
                  return DockItem(
                    label: cfg.label,
                    isSelected: _selectedIndex == i,
                    icon: Image.asset(
                      cfg.imagePath,
                      fit: BoxFit.cover,
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
