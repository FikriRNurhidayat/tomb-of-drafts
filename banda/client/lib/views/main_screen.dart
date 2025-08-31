import 'package:banda/views/ledger_create_screen.dart';
import 'package:banda/views/ledger_list_screen.dart';
import 'package:banda/views/transfer_list_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _current = 0;
  final List<Widget> _views = [
    LedgerListScreen(),
    TransferListScreen(),
    Center(child: Text("Account")),
  ];

  final List<NavigationDestination> _destinations = [
    NavigationDestination(icon: Icon(Icons.receipt), label: "Ledger"),
    NavigationDestination(icon: Icon(Icons.sync_alt), label: "Transfer"),
    NavigationDestination(icon: Icon(Icons.wallet), label: "Account"),
  ];

  FloatingActionButton? _buildFloatingActionButtons(BuildContext context) {
    switch (_current) {
      case 0:
        return FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LedgerCreateScreen()),
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
      floatingActionButton: _buildFloatingActionButtons(context),
      bottomNavigationBar: NavigationBar(
        destinations: _destinations,
        selectedIndex: _current,
        onDestinationSelected: (selected) {
          setState(() {
            _current = selected;
          });
        },
      ),
    );
  }
}
