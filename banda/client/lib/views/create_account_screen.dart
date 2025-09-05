import 'package:banda/entity/account.dart';
import 'package:banda/providers/account_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();

  String? name;
  String? holderName;
  String? kind;

  void submit() {
    final accountProvider = context.read<AccountProvider>();

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      accountProvider.add(name: name!, holderName: holderName!, kind: kind!);
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("KONTOL")));
    }
  }

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
          "Enter account details",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Form(
              key: _formKey,
              child: Column(
                spacing: 16,
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Account name",
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (value) => name = value ?? '',
                    validator: (value) => value == null || value.isEmpty
                        ? "Enter account name"
                        : null,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Account holder name",
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (value) => holderName = value ?? '',
                    validator: (value) => value == null || value.isEmpty
                        ? "Enter account holder name"
                        : null,
                  ),
                  DropdownButtonFormField(
                    onChanged: (value) => kind = value ?? '',
                    validator: (value) => value == null || value.isEmpty
                        ? "Choose account type"
                        : null,
                    items: AccountKind.values.map((v) {
                      return DropdownMenuItem(
                        value: v.label,
                        child: Text(v.label),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: "Type of account",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: submit,
                    child: const Text("Add"),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
