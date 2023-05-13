import 'package:flutter/material.dart';

class AppNavigationBar extends StatefulWidget {
  const AppNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onSelectItem,
  });

  final int selectedIndex;
  final void Function(int)? onSelectItem;

  @override
  State<AppNavigationBar> createState() => _AppNavigationBarState();
}

class _AppNavigationBarState extends State<AppNavigationBar> {
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.selectedIndex;
  }

  @override
  void didUpdateWidget(covariant AppNavigationBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedIndex != oldWidget.selectedIndex) {
      selectedIndex = widget.selectedIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      // App NavigationBar should get first focus.
      autofocus: true,
      child: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
          widget.onSelectItem!(index);
        },
        destinations: appBarDestinations,
      ),
    );
  }
}

const List<NavigationDestination> appBarDestinations = [
  NavigationDestination(
    label: 'Color',
    icon: Icon(Icons.format_paint_outlined),
    selectedIcon: Icon(Icons.format_paint),
  ),
  NavigationDestination(
    label: 'Elevation',
    icon: Icon(Icons.invert_colors_on_outlined),
    selectedIcon: Icon(Icons.opacity),
  )
];
