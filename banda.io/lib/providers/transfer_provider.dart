import 'package:banda/entity/transfer.dart';
import 'package:banda/repositories/transfer_repository.dart';
import 'package:flutter/material.dart';

class TransferProvider extends ChangeNotifier {
  final TransferRepository _repository;

  TransferProvider(this._repository);

  Future<List<Transfer>> search() async {
    return _repository.search();
  }

  Future<void> add({
    required double amount,
    required DateTime timestamp,
    required String fromId,
    required String toId,
  }) async {
    await _repository.create(
      amount: amount,
      timestamp: timestamp,
      fromId: fromId,
      toId: toId,
    );
    notifyListeners();
  }

  Future<void> remove(String id) async {
    await _repository.delete(id);
    notifyListeners();
  }
}
