import 'package:banda/helpers/money_helper.dart';
import 'package:banda/repositories/account_repository.dart';
import 'package:banda/repositories/category_repository.dart';
import 'package:banda/repositories/entry_repository.dart';
import 'package:flutter/material.dart';

class MetricProvider extends ChangeNotifier {
  final CategoryRepository categoryRepository;
  final AccountRepository accountRepository;
  final EntryRepository entryRepository;

  MetricProvider({
    required this.categoryRepository,
    required this.entryRepository,
    required this.accountRepository,
  });

  Future<List<Map>> compute() async {
    List<Map> metrics = [];

    final entriesCount = await entryRepository.count();
    metrics.add({"name": "Total entries", "value": entriesCount.toString()});

    final entriesAmount = await entryRepository.sum();
    metrics.add({
      "name": "Total amount",
      "value": MoneyHelper.normalize(entriesAmount),
    });

    final top5Categories = await categoryRepository.dominant();
    for (var info in top5Categories) {
      metrics.add({
        "name": '${info["name"]}',
        "value": MoneyHelper.format(info["entries_amount"]),
      });
    }

    return metrics;
  }
}
