import 'package:banda/providers/account_provider.dart';
import 'package:banda/providers/category_provider.dart';
import 'package:banda/providers/entry_provider.dart';
import 'package:banda/providers/transfer_provider.dart';
import 'package:banda/repositories/account_repository.dart';
import "package:banda/repositories/category_repository.dart";
import 'package:banda/repositories/entry_repository.dart';
import 'package:banda/repositories/transfer_repository.dart';
import 'package:banda/views/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final categoryRepository = await CategoryRepository.build();
  final entryRepository = await EntryRepository.build();
  final accountRepository = await AccountRepository.build();
  final transferRepository = await TransferRepository.build();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CategoryProvider(categoryRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => AccountProvider(accountRepository),
        ),
        ChangeNotifierProvider(create: (_) => EntryProvider(entryRepository)),
        ChangeNotifierProvider(
          create: (_) => TransferProvider(transferRepository),
        ),
      ],
      child: const BandaApp(),
    ),
  );
}

class BandaApp extends StatelessWidget {
  const BandaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Banda.io',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      home: const MainScreen(),
    );
  }
}
