import 'package:banda/entity/category.dart';
import 'package:banda/providers/category_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditCategoryScreen extends StatefulWidget {
  const EditCategoryScreen({super.key});

  @override
  State<StatefulWidget> createState() => _EditCategoryScreenState();
}

class _EditCategoryScreenState extends State<EditCategoryScreen> {
  String? editId;
  final createController = TextEditingController();
  final createFocus = FocusNode();
  final editController = TextEditingController();
  final editFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    createFocus.addListener(() {
      setState(() {});
    });
  }

  void edit(Category category) {
    setState(() {
      editId = category.id;
      editController.text = category.name;
    });
  }

  @override
  void dispose() {
    createController.dispose();
    createFocus.dispose();
    super.dispose();
  }

  void create() {
    final value = createController.text.trim();
    if (value.isNotEmpty) {
      final categoryProvider = context.read<CategoryProvider>();
      categoryProvider.add(name: value);
      createController.clear();
      createFocus.unfocus();
    }
  }

  void save(Category category) {
    final name = editController.text.trim();
    if (name.isNotEmpty) {
      context.read<CategoryProvider>().update(id: category.id, name: name);
      setState(() => editId = null);
    }
  }

  void delete(Category category) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Please Confirm"),
          content: const Text(
            "Are you sure that you want to delete this category? It will remove all entries on this category.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                context.read<CategoryProvider>().remove(category.id);
                setState(() => editId = null);

                Navigator.of(context).pop();
              },
              child: const Text("Yes"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("No"),
            ),
          ],
        );
      },
    );
  }

  Decoration focusDecoration() {
    final theme = Theme.of(context);

    return BoxDecoration(
      border: Border(
        top: BorderSide(color: theme.colorScheme.surfaceBright),
        bottom: BorderSide(color: theme.colorScheme.surfaceBright),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = context.watch<CategoryProvider>();

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
      body: FutureBuilder<List<Category>>(
        future: categoryProvider.search(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final categories = snapshot.data!;
          return ListView(
            children: [
              Container(
                decoration: createFocus.hasFocus ? focusDecoration() : null,
                child: ListTile(
                  leading: Icon(Icons.add),
                  title: TextField(
                    focusNode: createFocus,
                    controller: createController,
                    decoration: InputDecoration(
                      hintText: "Create new category",
                      border: InputBorder.none,
                    ),
                  ),
                  trailing: createFocus.hasFocus
                      ? IconButton(icon: Icon(Icons.check), onPressed: create)
                      : null,
                ),
              ),
              ...categories.map((category) {
                final isEditing = category.id == editId;

                return Container(
                  decoration: isEditing ? focusDecoration() : null,
                  child: ListTile(
                    leading: category.deletable && isEditing
                        ? GestureDetector(
                            child: Icon(Icons.delete),
                            onTap: () => delete(category),
                          )
                        : Icon(Icons.label),
                    title: isEditing
                        ? TextField(
                            decoration: null,
                            focusNode: editFocus,
                            controller: editController,
                            keyboardType: TextInputType.text,
                            autofocus: true,
                          )
                        : Text(category.name),
                    trailing: isEditing
                        ? IconButton(
                            icon: Icon(Icons.check),
                            onPressed: () => save(category),
                          )
                        : IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => edit(category),
                          ),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}
