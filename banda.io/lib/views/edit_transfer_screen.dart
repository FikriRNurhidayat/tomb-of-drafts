import 'package:banda/decorations/input_styles.dart';
import 'package:banda/providers/account_provider.dart';
import 'package:banda/providers/transfer_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditTransferScreen extends StatefulWidget {
  const EditTransferScreen({super.key});

  @override
  State<EditTransferScreen> createState() => _EditTransferScreenState();
}

class _EditTransferScreenState extends State<EditTransferScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _dateFormatter = DateFormat("d MMMM yyyy");

  double? _amount;
  String? _fromId;
  String? _toId;
  DateTime? _date;
  TimeOfDay? _time;

  void _submit() {
    final transferProvider = context.read<TransferProvider>();

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final timestamp = DateTime(
        _date!.year,
        _date!.month,
        _date!.day,
        _time!.hour,
        _time!.minute,
      );

      transferProvider.add(
        amount: _amount!,
        timestamp: timestamp,
        fromId: _fromId!,
        toId: _toId!,
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

  _validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return "Amount is required";
    }

    final amount = double.tryParse(value);
    if (amount == null) {
      return "Amount is incorrect";
    }

    if (amount <= 0) {
      return "Amount MUST be positive.";
    }

    return null;
  }

  _validateAccount(String? sourceId, String? targetId) {
    if (sourceId == null || sourceId.isEmpty) {
      return "You need to specify on which accounts you want to transfer.";
    }

    if (sourceId == targetId) {
      return "You can't transfer to the same account.";
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final accountProvider = context.watch<AccountProvider>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Enter transfer details",
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
        future: accountProvider.search(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final accounts = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                spacing: 16,
                children: [
                  TextFormField(
                    decoration: InputStyles.field(
                      hintText: "Enter amount...",
                      labelText: "Amount",
                    ),
                    keyboardType: TextInputType.numberWithOptions(
                      signed: true,
                      decimal: true,
                    ),
                    onSaved: (value) => _amount = double.tryParse(value!),
                    validator: (value) => _validateAmount(value),
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
                  DropdownButtonFormField(
                    decoration: InputStyles.field(
                      labelText: "From",
                      hintText: "Select source account...",
                    ),
                    items: accounts.map((i) {
                      return DropdownMenuItem(
                        value: i.id,
                        child: Text("${i.holderName}: ${i.name}"),
                      );
                    }).toList(),
                    validator: (value) => _validateAccount(value, _toId),
                    onChanged: (value) => _fromId = value ?? '',
                  ),
                  DropdownButtonFormField(
                    decoration: InputStyles.field(
                      labelText: "To",
                      hintText: "Select target account...",
                    ),
                    validator: (value) => _validateAccount(value, _fromId),
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
          );
        },
      ),
    );
  }
}
