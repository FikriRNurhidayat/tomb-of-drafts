import 'package:banda/views/create_account_screen.dart';
import 'package:banda/views/create_entry_screen.dart';
import 'package:banda/views/create_transfer_screen.dart';
import 'package:banda/views/edit_category_screen.dart';
import 'package:banda/views/edit_label_screen.dart';
import 'package:banda/views/list_entry_screen.dart';
import 'package:banda/views/list_transfer_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class Screen {
  final String title;
  final IconData icon;
  final Widget child;
  final Widget Function(BuildContext)? fabBuilder;

  Screen({
    required this.title,
    required this.icon,
    required this.child,
    this.fabBuilder,
  });
}

class _MainScreenState extends State<MainScreen> {
  int _current = 0;

  final List<Screen> _screens = [
    Screen(
      title: "Home",
      icon: Icons.home,
      child: Center(child: Text("Home")),
    ),
    Screen(
      title: "Ledger",
      icon: Icons.book,
      child: ListEntryScreen(),
      fabBuilder: (context) {
        return SpeedDial(
          shape: const CircleBorder(),
          spacing: 16,
          spaceBetweenChildren: 8,
          activeIcon: Icons.close,
          children: [
            SpeedDialChild(
              child: const Icon(Icons.book),
              label: "Entry",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (_) => const CreateEntryScreen(),
                  ),
                );
              },
            ),
            SpeedDialChild(
              child: const Icon(Icons.sync_alt),
              label: "Transfer",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (_) => const CreateTransferScreen(),
                  ),
                );
              },
            ),
            SpeedDialChild(
              child: const Icon(Icons.category),
              label: "Category",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (_) => const EditCategoryScreen(),
                  ),
                );
              },
            ),
            SpeedDialChild(
              child: const Icon(Icons.category),
              label: "Label",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (_) => const EditLabelScreen(),
                  ),
                );
              },
            ),
            SpeedDialChild(
              child: const Icon(Icons.wallet),
              label: "Account",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (_) => const CreateAccountScreen(),
                  ),
                );
              },
            ),
          ],
          child: const Icon(Icons.add),
        );
      },
    ),
    Screen(
      title: "Settings",
      icon: Icons.settings,
      child: Center(child: Text("Settings")),
    ),
  ];

  List<Widget> _menu() {
    return _screens
        .map(
          (screen) => NavigationDestination(
            icon: Icon(screen.icon),
            label: screen.title,
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screen = _screens[_current];

    return Scaffold(
      body: screen.child,
      appBar: AppBar(
        title: Text(
          screen.title,
          style: theme.textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: NavigationBar(
        labelTextStyle: WidgetStateProperty.all(
          TextStyle(fontFamily: theme.textTheme.headlineSmall!.fontFamily),
        ),
        selectedIndex: _current,
        destinations: _menu(),
        onDestinationSelected: (value) {
          setState(() {
            _current = value;
          });
        },
      ),
      floatingActionButton: screen.fabBuilder?.call(context),
    );
  }
}
