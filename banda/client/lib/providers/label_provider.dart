import 'package:banda/entity/label.dart';
import 'package:banda/repositories/label_repository.dart';
import 'package:flutter/material.dart';

class LabelProvider extends ChangeNotifier {
  final LabelRepository _repository;

  LabelProvider(this._repository);

  Future<List<Label>> search() async {
    return _repository.search();
  }

  Future<void> add({required String name}) async {
    await _repository.create(name: name);
    notifyListeners();
  }

  Future<void> update({required String id, required String name}) async {
    await _repository.update(id: id, name: name);
    notifyListeners();
  }

  Future<void> remove(String id) async {
    await _repository.delete(id);
    notifyListeners();
  }
}
