import 'package:banda/views/edit_account_screen.dart';
import 'package:banda/views/edit_entry_screen.dart';
import 'package:banda/views/edit_category_screen.dart';
import 'package:banda/views/edit_label_screen.dart';
import 'package:banda/views/edit_transfer_screen.dart';
import 'package:banda/views/list_account_screen.dart';
import 'package:banda/views/list_entry_screen.dart';
import 'package:banda/views/list_transfer_screen.dart';
import 'package:banda/views/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class TabScreen {
  final String text;
  final Icon icon;
  final Widget child;

  TabScreen({required this.text, required this.icon, required this.child});
}

class Screen {
  final String title;
  final IconData icon;
  final Widget? child;
  final Widget Function(BuildContext)? fabBuilder;
  final List<TabScreen>? tabs;

  Screen({
    required this.title,
    required this.icon,
    this.child,
    this.tabs,
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
      tabs: <TabScreen>[
        TabScreen(
          text: "Entry",
          icon: Icon(Icons.book),
          child: ListEntryScreen(),
        ),
        TabScreen(
          text: "Transfer",
          icon: Icon(Icons.sync_alt),
          child: ListTransferScreen(),
        ),
        TabScreen(
          text: "Account",
          icon: Icon(Icons.wallet),
          child: ListAccountScreen(),
        ),
      ],
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
                    builder: (_) => const EditEntryScreen(),
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
                    builder: (_) => const EditTransferScreen(),
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
                    builder: (_) => const EditAccountScreen(),
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
      child: SettingScreen(),
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

    if (screen.tabs != null) {
      return DefaultTabController(
        initialIndex: 0,
        length: screen.tabs!.length,
        child: Scaffold(
          body: TabBarView(
            children: screen.tabs!.map((tab) => tab.child).toList(),
          ),
          appBar: AppBar(
            title: Text(
              screen.title,
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            centerTitle: true,
            bottom: TabBar(
              tabs: screen.tabs!
                  .map((tab) => Tab(icon: tab.icon, text: tab.text))
                  .toList(),
            ),
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
        ),
      );
    }

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
