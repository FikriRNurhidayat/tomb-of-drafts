import 'package:flutter/material.dart';

class TransferListScreen extends StatefulWidget {
  const TransferListScreen({super.key});

  @override
  State<StatefulWidget> createState() => _TransferListScreenState();
}

class _TransferListScreenState extends State<TransferListScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(child: const Text("Transfer"));
  }
}
