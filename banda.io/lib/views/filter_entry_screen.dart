import 'package:flutter/material.dart';

class FilterEntryScreen extends StatefulWidget {
  const FilterEntryScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _FilterEntryScreenState();
  }
}

class _FilterEntryScreenState extends State<FilterEntryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Filter entries",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
        ),
      ),
      body: Center(child: Text("Filter entries")),
    );
  }
}
