import 'package:banda/routes.dart';
import 'package:banda/views/create_account_screen.dart';
import 'package:banda/views/create_entry_screen.dart';
import 'package:banda/views/create_transfer_screen.dart';
import 'package:banda/views/edit_category_screen.dart';
import 'package:banda/views/edit_label_screen.dart';
import 'package:banda/views/list_account_screen.dart';
import 'package:banda/views/list_entry_screen.dart';
import 'package:banda/views/list_transfer_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _current = 0;

  final List<String> _titles = [
    "Overview",
    "Ledger",
    "Transfer",
    "Settings",
    "Category",
    "Label",
    "Trash",
  ];

  final List<Widget> _views = [
    Center(child: Text("Home")),
    ListEntryScreen(),
    ListTransferScreen(),
    Center(child: Text("Settings")),
    ListAccountScreen(),
    Center(child: Text("Category")),
    Center(child: Text("Label")),
    Center(child: Text("Trash")),
  ];

  final List<Widget> _menu = [
    NavigationDestination(icon: Icon(Icons.home), label: "Home"),
    NavigationDestination(icon: Icon(Icons.book), label: "Ledger"),
    NavigationDestination(icon: Icon(Icons.sync_alt), label: "Transfer"),
    NavigationDestination(icon: Icon(Icons.settings), label: "Settings"),
  ];

  FloatingActionButton? fab(BuildContext context) {
    final title = _titles[_current];

    switch (title) {
      case "Ledger":
        return FloatingActionButton(
          mini: true,
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                fullscreenDialog: true,
                builder: (_) => const CreateEntryScreen(),
              ),
            );
          },
        );
      case "Account":
        return FloatingActionButton(
          mini: true,
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                fullscreenDialog: true,
                builder: (_) => const CreateAccountScreen(),
              ),
            );
          },
        );
      case "Transfer":
        return FloatingActionButton(
          mini: true,
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                fullscreenDialog: true,
                builder: (_) => const CreateTransferScreen(),
              ),
            );
          },
        );
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: _views[_current],
      appBar: AppBar(
        title: Text(_titles[_current], style: theme.textTheme.headlineSmall, textAlign: TextAlign.center),
        centerTitle: true,
      ),
      bottomNavigationBar: NavigationBar(
        destinations: _menu,
        onDestinationSelected: (value) {
          setState(() {
            _current = value;
          });
        },
      ),
      floatingActionButton: fab(context),
    );
  }
}
