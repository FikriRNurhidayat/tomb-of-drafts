import 'package:banda/entity/category.dart';
import 'package:banda/repositories/category_repository.dart';
import 'package:flutter/material.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryRepository _repository;

  CategoryProvider(this._repository);

  Future<List<Category>> search() async {
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
