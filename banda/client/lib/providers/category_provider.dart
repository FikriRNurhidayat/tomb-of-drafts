import 'package:banda/entity/category.dart';
import 'package:banda/services/category_service.dart';
import 'package:flutter/material.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryService _service;

  CategoryProvider(this._service);

  Future<List<Category>> search() async {
    return _service.search();
  }

  Future<void> add({required String name}) async {
    await _service.create(name: name);
    notifyListeners();
  }

  Future<void> remove(String id) async {
    await _service.delete(id);
    notifyListeners();
  }
}
