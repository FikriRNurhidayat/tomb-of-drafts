import 'package:banda/entity/account.dart';
import 'package:banda/entity/category.dart';
import 'package:banda/entity/entry.dart';
import 'package:banda/providers/account_provider.dart';
import 'package:banda/providers/category_provider.dart';
import 'package:banda/providers/entry_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CreateEntryScreen extends StatefulWidget {
  const CreateEntryScreen({super.key});

  @override
  State<CreateEntryScreen> createState() => _CreateEntryScreenState();
}

class _CreateEntryScreenState extends State<CreateEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _dateFormatter = DateFormat("d MMMM yyyy");

  String? _note;
  EntryStatus? _status;
  double? _amount;
  String? _categoryId;
  String? _accountId;
  DateTime? _date;
  TimeOfDay? _time;

  void _submit() {
    final entryProvider = context.read<EntryProvider>();

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final timestamp = DateTime(
        _date!.year,
        _date!.month,
        _date!.day,
        _time!.hour,
        _time!.minute,
      );

      entryProvider.add(
        note: _note!,
        amount: _amount!,
        status: _status!,
        categoryId: _categoryId!,
        accountId: _accountId!,
        timestamp: timestamp,
      );

      Navigator.pop(context);
    }
  }

  void _pickDate() async {
    final now = DateTime.now();
    final DateTime? choosenDate = await showDatePicker(
      context: context,
      initialDate: _date ?? now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (!mounted || choosenDate == null) return;

    _date = choosenDate;
    _dateController.text = _dateFormatter.format(choosenDate);
  }

  void _pickTime() async {
    final TimeOfDay? choosenTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (!mounted || choosenTime == null) return;

    _time = choosenTime;
    _timeController.text = "${choosenTime.hour}:${choosenTime.minute}";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categoryProvider = context.watch<CategoryProvider>();
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
        future: Future.wait([
          categoryProvider.search(),
          accountProvider.search(),
        ]),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Error");
          }

          if (!snapshot.hasData) {
            return Text("No data");
          }

          final categories = snapshot.data![0] as List<Category>;
          final accounts = snapshot.data![1] as List<Account>;

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
                          labelText: "Note",
                          border: OutlineInputBorder(),
                        ),
                        onSaved: (value) => _note = value ?? '',
                        validator: (value) => value == null || value.isEmpty
                            ? "Enter note"
                            : null,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
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
                        controller: _dateController,
                        onTap: () => _pickDate(),
                        decoration: InputDecoration(
                          labelText: "Date",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? "Select date"
                            : null,
                      ),
                      TextFormField(
                        readOnly: true,
                        controller: _timeController,
                        onTap: () => _pickTime(),
                        decoration: InputDecoration(
                          labelText: "Time",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? "Select time"
                            : null,
                      ),
                      DropdownButtonFormField(
                        decoration: InputDecoration(
                          labelText: "Status",
                          border: OutlineInputBorder(),
                        ),
                        items: EntryStatus.values.map((c) {
                          return DropdownMenuItem(
                            value: c,
                            child: Text(
                              c.label,
                              style: TextStyle(
                                fontFamily:
                                    theme.textTheme.headlineSmall!.fontFamily,
                                fontWeight:
                                    theme.textTheme.bodySmall!.fontWeight,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) => _status = value,
                      ),
                      DropdownButtonFormField(
                        decoration: InputDecoration(
                          labelText: "Category",
                          border: OutlineInputBorder(),
                        ),
                        items: categories.map((c) {
                          return DropdownMenuItem(
                            value: c.id,
                            child: Text(
                              c.name,
                              style: TextStyle(
                                fontFamily:
                                    theme.textTheme.headlineSmall!.fontFamily,
                                fontWeight:
                                    theme.textTheme.bodySmall!.fontWeight,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) => _categoryId = value ?? '',
                      ),
                      DropdownButtonFormField(
                        decoration: InputDecoration(
                          labelText: "Account",
                          border: OutlineInputBorder(),
                        ),
                        items: accounts.map((i) {
                          return DropdownMenuItem(
                            value: i.id,
                            child: Text(
                              "${i.holderName}: ${i.name}",
                              style: TextStyle(
                                fontFamily:
                                    theme.textTheme.headlineSmall!.fontFamily,
                                fontWeight:
                                    theme.textTheme.bodySmall!.fontWeight,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) => _accountId = value ?? '',
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
