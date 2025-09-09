import 'package:banda/providers/account_provider.dart';
import 'package:banda/providers/transfer_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateTransferScreen extends StatefulWidget {
  const CreateTransferScreen({super.key});

  @override
  State<CreateTransferScreen> createState() => _CreateTransferScreenState();
}

class _CreateTransferScreenState extends State<CreateTransferScreen> {
  final _formKey = GlobalKey<FormState>();
  final _timestampController = TextEditingController();

  double? _amount;
  String? _fromId;
  String? _toId;
  DateTime? _timestamp;

  void _submit() {
    final transferProvider = context.read<TransferProvider>();

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      transferProvider.add(
        amount: _amount!,
        timestamp: _timestamp!,
        fromId: _fromId!,
        toId: _toId!,
      );

      Navigator.pop(context);
    }
  }

  void _pickTimestamp() async {
    final now = DateTime.now();
    final DateTime? choosenDate = await showDatePicker(
      context: context,
      initialDate: _timestamp ?? now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (!mounted || choosenDate == null) return;

    final TimeOfDay? choosenTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(now),
    );

    if (!mounted || choosenTime == null) return;

    _timestampController.text = DateTime(
      choosenDate.year,
      choosenDate.month,
      choosenDate.day,
      choosenTime.hour,
      choosenTime.minute,
    ).toIso8601String();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accountProvider = context.watch<AccountProvider>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Enter entry details",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
        ),
      ),
      body: FutureBuilder(
        future: accountProvider.search(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Error");
          }

          if (!snapshot.hasData) {
            return Text("No data");
          }

          final accounts = snapshot.data!;

          return Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.all(8),
                child: Form(
                  key: _formKey,
                  child: Column(
                    spacing: 16,
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.money),
                          labelText: "Amount",
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.numberWithOptions(
                          signed: true,
                          decimal: true,
                        ),
                        onSaved: (value) => _amount = double.tryParse(value!),
                        validator: (value) => value == null || value.isEmpty
                            ? "Enter amount"
                            : null,
                      ),
                      TextFormField(
                        readOnly: true,
                        controller: _timestampController,
                        onTap: () => _pickTimestamp(),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.calendar_today),
                          labelText: "Timestamp",
                          border: OutlineInputBorder(),
                        ),
                        onSaved: (val) {
                          if (_timestampController.text.isNotEmpty) {
                            _timestamp = DateTime.parse(
                              _timestampController.text,
                            );
                          }
                        },
                        validator: (value) => value == null || value.isEmpty
                            ? "Enter timestamp"
                            : null,
                      ),
                      DropdownButtonFormField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.wallet),
                          labelText: "From",
                          border: OutlineInputBorder(),
                        ),
                        items: accounts.map((i) {
                          return DropdownMenuItem(
                            value: i.id,
                            child: Text("${i.holderName}: ${i.name}"),
                          );
                        }).toList(),
                        onChanged: (value) => _fromId = value ?? '',
                      ),
                      DropdownButtonFormField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.wallet),
                          labelText: "To",
                          border: OutlineInputBorder(),
                        ),
                        items: accounts.map((i) {
                          return DropdownMenuItem(
                            value: i.id,
                            child: Text("${i.holderName}: ${i.name}"),
                          );
                        }).toList(),
                        onChanged: (value) => _toId = value ?? '',
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SafeArea(
                  top: false,
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
                        onPressed: _submit,
                        child: const Text("Add"),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
