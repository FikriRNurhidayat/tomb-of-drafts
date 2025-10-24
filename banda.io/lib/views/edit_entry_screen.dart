import 'package:banda/decorations/input_styles.dart';
import 'package:banda/entity/account.dart';
import 'package:banda/entity/category.dart';
import 'package:banda/entity/entry.dart';
import 'package:banda/entity/label.dart';
import 'package:banda/helpers/date_helper.dart';
import 'package:banda/providers/account_provider.dart';
import 'package:banda/providers/category_provider.dart';
import 'package:banda/providers/entry_provider.dart';
import 'package:banda/providers/label_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditEntryScreen extends StatefulWidget {
  final Entry? entry;

  const EditEntryScreen({super.key, this.entry});

  @override
  State<EditEntryScreen> createState() => _EditEntryScreenState();
}

class _EditEntryScreenState extends State<EditEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();

  String? _id;
  String? _note;
  EntryStatus? _status;
  double? _amount;
  String? _categoryId;
  String? _accountId;
  DateTime? _date;
  TimeOfDay? _time;

  @override
  void initState() {
    super.initState();

    if (widget.entry != null) {
      final entry = widget.entry!;
      _id = entry.id;
      _note = entry.note;
      _status = entry.status;
      _categoryId = entry.categoryId;
      _accountId = entry.accountId;
      _amount = entry.amount;
      _date = DateTime(
        entry.timestamp.year,
        entry.timestamp.month,
        entry.timestamp.day,
      );
      _time = TimeOfDay.fromDateTime(entry.timestamp);

      _dateController.text = DateHelper.formatDate(_date!);
      _timeController.text = DateHelper.formatTime(_time!);
    }
  }

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

      if (_id == null) {
        entryProvider.add(
          note: _note!,
          amount: _amount!,
          status: _status!,
          categoryId: _categoryId!,
          accountId: _accountId!,
          timestamp: timestamp,
        );
      }

      if (_id != null) {
        entryProvider.update(
          id: _id!,
          note: _note!,
          amount: _amount!,
          status: _status!,
          categoryId: _categoryId!,
          accountId: _accountId!,
          timestamp: timestamp,
        );
      }

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
    _dateController.text = DateHelper.formatDate(choosenDate);
  }

  void _pickTime() async {
    final TimeOfDay? choosenTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (!mounted || choosenTime == null) return;

    _time = choosenTime;
    _timeController.text = DateHelper.formatTime(choosenTime);
  }

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categoryProvider = context.watch<CategoryProvider>();
    final accountProvider = context.watch<AccountProvider>();
    final labelProvider = context.watch<LabelProvider>();

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
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(onPressed: _submit, icon: Icon(Icons.check)),
          ),
        ],
      ),
      body: FutureBuilder(
        future: Future.wait([
          categoryProvider.search(),
          accountProvider.search(),
          labelProvider.search(),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final categories = snapshot.data![0] as List<Category>;
          final accounts = snapshot.data![1] as List<Account>;
          final labels = snapshot.data![2] as List<Label>;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                spacing: 16,
                children: [
                  TextFormField(
                    decoration: InputStyles.field(
                      labelText: "Note",
                      hintText: "Enter note...",
                    ),
                    initialValue: _note,
                    onSaved: (value) => _note = value ?? '',
                    validator: (value) =>
                        value == null || value.isEmpty ? "Enter note" : null,
                  ),
                  TextFormField(
                    decoration: InputStyles.field(
                      labelText: "Amount",
                      hintText: "Enter amount...",
                    ),
                    initialValue: _amount?.toInt().toString(),
                    keyboardType: TextInputType.numberWithOptions(
                      signed: true,
                      decimal: true,
                    ),
                    onSaved: (value) => _amount = double.tryParse(value!),
                    validator: (value) =>
                        value == null || value.isEmpty ? "Enter amount" : null,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          readOnly: true,
                          controller: _dateController,
                          onTap: () => _pickDate(),
                          decoration: InputStyles.field(
                            labelText: "Date",
                            hintText: "Select date...",
                          ),
                          validator: (value) => value == null || value.isEmpty
                              ? "Select date"
                              : null,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          readOnly: true,
                          controller: _timeController,
                          onTap: () => _pickTime(),
                          decoration: InputStyles.field(
                            labelText: "Time",
                            hintText: "Select time...",
                          ),
                          validator: (value) => value == null || value.isEmpty
                              ? "Select time"
                              : null,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField(
                          decoration: InputStyles.field(
                            labelText: "Status",
                            hintText: "Select status...",
                          ),
                          initialValue: _status,
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
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField(
                          decoration: InputStyles.field(
                            labelText: "Category",
                            hintText: "Select category...",
                          ),
                          initialValue: _categoryId,
                          items: categories
                              .where((category) => !category.readonly)
                              .map((c) {
                                return DropdownMenuItem(
                                  value: c.id,
                                  child: Text(
                                    c.name,
                                    style: TextStyle(
                                      fontFamily: theme
                                          .textTheme
                                          .headlineSmall!
                                          .fontFamily,
                                      fontWeight:
                                          theme.textTheme.bodySmall!.fontWeight,
                                    ),
                                  ),
                                );
                              })
                              .toList(),
                          onChanged: (value) => _categoryId = value ?? '',
                        ),
                      ),
                    ],
                  ),
                  DropdownButtonFormField(
                    decoration: InputStyles.field(
                      labelText: "Account",
                      hintText: "Select account...",
                    ),
                    initialValue: _accountId,
                    items: accounts.map((i) {
                      return DropdownMenuItem(
                        value: i.id,
                        child: Text(
                          "${i.holderName}: ${i.name}",
                          style: TextStyle(
                            fontFamily:
                                theme.textTheme.headlineSmall!.fontFamily,
                            fontWeight: theme.textTheme.bodySmall!.fontWeight,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) => _accountId = value ?? '',
                  ),
                  FormField<List<String>>(
                    initialValue: const [],
                    validator: (values) => values == null || values.isEmpty
                        ? 'Pick at least one'
                        : null,
                    builder: (state) {
                      return Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: labels.map((label) {
                          final selected = state.value!.contains(label.id);
                          return FilterChip(
                            label: Text(label.name),
                            selected: selected,
                            onSelected: (bool value) {
                              final current = List<String>.from(state.value!);
                              if (value) {
                                current.add(label.id);
                              } else {
                                current.remove(label.id);
                              }
                              state.didChange(current);
                            },
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
