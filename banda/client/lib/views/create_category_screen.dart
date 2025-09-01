import 'package:flutter/material.dart';

class CreateCategoryScreen extends StatefulWidget {
  const CreateCategoryScreen({super.key});

  @override
  State<StatefulWidget> createState() => _CreateCategoryScreenState();
}

class _CreateCategoryScreenState extends State<CreateCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Edit categories",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
        ),
      ),
      body: ListView(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: theme.colorScheme.surface),
                bottom: BorderSide(color: theme.colorScheme.surface),
              ),
            ),
            child: ListTile(
              leading: Icon(Icons.add),
              title: TextField(
                decoration: InputDecoration(
                  hintText: "Create new category",
                  border: InputBorder.none,
                ),
              ),
              trailing: null,
            ),
          ),
          Container(
            decoration: null,
            child: ListTile(
              leading: Icon(Icons.label),
              title: Text("Food"),
              trailing: Icon(Icons.edit),
            ),
          ),
          Container(
            decoration: null,
            child: ListTile(
              leading: Icon(Icons.label),
              title: Text("Grocery"),
              trailing: Icon(Icons.edit),
            ),
          ),
          Container(
            decoration: null,
            child: ListTile(
              leading: Icon(Icons.label),
              title: Text("Snacks"),
              trailing: Icon(Icons.edit),
            ),
          ),
        ],
      ),
    );
  }
}
