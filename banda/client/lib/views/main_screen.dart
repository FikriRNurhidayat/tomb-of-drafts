import 'package:banda/routes.dart';
import 'package:banda/views/create_account_screen.dart';
import 'package:banda/views/create_entry_screen.dart';
import 'package:banda/views/edit_category_screen.dart';
import 'package:banda/views/list_account_screen.dart';
import 'package:banda/views/list_ledger_screen.dart';
import 'package:banda/views/transfer_list_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _current = 0;

  final List<String> _titles = [
    "Ledger",
    "Transfer",
    "Account",
    "Category",
    "Label",
    "Trash",
    "Settings",
  ];

  final List<Widget> _views = [
    ListLedgerScreen(),
    TransferListScreen(),
    ListAccountScreen(),
    Center(child: Text("Category")),
    Center(child: Text("Label")),
    Center(child: Text("Trash")),
    Center(child: Text("Settings")),
  ];

  final List<Widget> _menu = [
    NavigationDrawerDestination(
      icon: Icon(Icons.receipt),
      label: const Text("Ledger"),
    ),
    NavigationDrawerDestination(
      icon: Icon(Icons.sync_alt),
      label: const Text("Transfer"),
    ),
    NavigationDrawerDestination(
      icon: Icon(Icons.wallet),
      label: const Text("Account"),
    ),
    NavigationDrawerDestination(
      icon: Icon(Icons.category),
      label: const Text("Category"),
    ),
    NavigationDrawerDestination(
      icon: Icon(Icons.label),
      label: const Text("Label"),
    ),
    NavigationDrawerDestination(
      icon: Icon(Icons.delete),
      label: const Text("Trash"),
    ),
    NavigationDrawerDestination(
      icon: Icon(Icons.settings),
      label: const Text("Settings"),
    ),
  ];

  FloatingActionButton? fab(BuildContext context) {
    final title = _titles[_current];

    // TODO: Please, refactor!
    switch (title) {
      case "Ledger":
        return FloatingActionButton(
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
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _views[_current],
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        title: Text(_titles[_current]),
      ),
      drawer: NavigationDrawer(
        header: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Text(
                "Banda.io",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        onDestinationSelected: (selected) {
          final route = Routes.values[selected];

          Navigator.of(context).pop();

          switch (route) {
            case Routes.category:
              Navigator.push(
                context,
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (_) => EditCategoryScreen(),
                ),
              );
              break;
            case Routes.account:
            case Routes.ledger:
            case Routes.transfer:
            case Routes.label:
            case Routes.trash:
            case Routes.settings:
              setState(() {
                _current = selected;
              });

              break;
          }
        },
        selectedIndex: _current,
        children: _menu,
      ),
      floatingActionButton: fab(context),
    );
  }
}
