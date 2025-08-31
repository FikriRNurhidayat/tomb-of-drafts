// import 'package:banda/entity/category.dart';
// import 'package:banda/providers/category_provider.dart';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

class LedgerCreateScreen extends StatefulWidget {
  const LedgerCreateScreen({super.key});

  @override
  State<LedgerCreateScreen> createState() => _LedgerCreateScreenState();
}

class _LedgerCreateScreenState extends State<LedgerCreateScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? selectedCategory;
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  void _saveLedgerEntry() {
    if (selectedCategory == null ||
        _noteController.text.isEmpty ||
        _amountController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('All fields are required')));
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Ledger saved')));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // final categoryProvider = context.watch<CategoryProvider>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Center(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: _noteController,
                  decoration: InputDecoration(hintText: "Note"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
