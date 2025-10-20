import 'package:banda/entity/entry.dart';
import 'package:banda/repositories/entry_repository.dart';
import 'package:flutter/material.dart';

class EntryProvider extends ChangeNotifier {
  final EntryRepository _repository;

  EntryProvider(this._repository);

  Future<List<Entry>> search() async {
    return _repository.search();
  }

  Future<void> add({
    required String note,
    required double amount,
    required EntryStatus status,
    required DateTime timestamp,
    required String accountId,
    required String categoryId,
  }) async {
    await _repository.create(
      note: note,
      amount: amount,
      status: status,
      timestamp: timestamp,
      accountId: accountId,
      categoryId: categoryId,
    );
    notifyListeners();
  }

  Future<void> update({
    required String id,
    required String note,
    required double amount,
    required EntryStatus status,
    required DateTime timestamp,
    required String accountId,
    required String categoryId,
  }) async {
    await _repository.update(
      id: id,
      note: note,
      amount: amount,
      status: status,
      timestamp: timestamp,
      accountId: accountId,
      categoryId: categoryId,
    );
    notifyListeners();
  }

  Future<void> remove(String id) async {
    await _repository.delete(id);
    notifyListeners();
  }
}
