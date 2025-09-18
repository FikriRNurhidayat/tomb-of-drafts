import 'package:banda/entity/label.dart';
import 'package:banda/providers/label_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditLabelScreen extends StatefulWidget {
  const EditLabelScreen({super.key});

  @override
  State<StatefulWidget> createState() => _EditLabelScreenState();
}

class _EditLabelScreenState extends State<EditLabelScreen> {
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

  void edit(Label label) {
    setState(() {
      editId = label.id;
      editController.text = label.name;
    });
  }

  @override
  void dispose() {
    createController.dispose();
    createFocus.dispose();
    editController.dispose();
    super.dispose();
  }

  void create() {
    final value = createController.text.trim();
    if (value.isNotEmpty) {
      final labelProvider = context.read<LabelProvider>();
      labelProvider.add(name: value);
      createController.clear();
      createFocus.unfocus();
    }
  }

  void save(Label label) {
    final name = editController.text.trim();
    if (name.isNotEmpty) {
      context.read<LabelProvider>().update(id: label.id, name: name);
      setState(() => editId = null);
    }
  }

  void delete(Label label) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Please Confirm"),
          content: const Text(
            "Are you sure that you want to delete this label?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                context.read<LabelProvider>().remove(label.id);
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
    final labelProvider = context.watch<LabelProvider>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Edit labels",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
        ),
      ),
      body: FutureBuilder<List<Label>>(
        future: labelProvider.search(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const CircularProgressIndicator();
          final labels = snapshot.data!;
          return ListView(
            children: [
              Container(
                decoration: createFocus.hasFocus ? focusDecoration() : null,
                child: ListTile(
                  enabled: false,
                  leading: Icon(Icons.add),
                  title: TextField(
                    focusNode: createFocus,
                    controller: createController,
                    decoration: InputDecoration(
                      hintText: "Create new label",
                      border: InputBorder.none,
                    ),
                  ),
                  trailing: createFocus.hasFocus
                      ? IconButton(icon: Icon(Icons.check), onPressed: create)
                      : null,
                ),
              ),
              ...labels.map((label) {
                final isEditing = label.id == editId;

                return Container(
                  decoration: isEditing ? focusDecoration() : null,
                  child: ListTile(
                    leading: isEditing
                        ? GestureDetector(
                            child: Icon(Icons.delete),
                            onTap: () => delete(label),
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
                        : Text(label.name),
                    trailing: isEditing
                        ? IconButton(
                            icon: Icon(Icons.check),
                            onPressed: () => save(label),
                          )
                        : IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => edit(label),
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
