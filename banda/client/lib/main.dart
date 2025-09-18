import 'package:banda/providers/account_provider.dart';
import 'package:banda/providers/category_provider.dart';
import 'package:banda/providers/entry_provider.dart';
import 'package:banda/providers/label_provider.dart';
import 'package:banda/providers/transfer_provider.dart';
import 'package:banda/repositories/account_repository.dart';
import "package:banda/repositories/category_repository.dart";
import 'package:banda/repositories/entry_repository.dart';
import 'package:banda/repositories/label_repository.dart';
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
  final labelRepository = await LabelRepository.build();

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
        ChangeNotifierProvider(create: (_) => LabelProvider(labelRepository)),
      ],
      child: const BandaApp(),
    ),
  );
}

class BandaApp extends StatelessWidget {
  const BandaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final light = ThemeData.light();
    final dark = ThemeData.dark();

    return MaterialApp(
      title: 'Banda.io',
      debugShowCheckedModeBanner: false,
      theme: light.copyWith(
        textTheme: light.textTheme.apply(fontFamily: 'RobotoCondensed').copyWith(
          headlineLarge: light.textTheme.headlineLarge!.copyWith( fontFamily: 'RobotoCondensed',),
          headlineMedium: light.textTheme.headlineMedium!.copyWith( fontFamily: 'RobotoCondensed',),
          headlineSmall: light.textTheme.headlineSmall!.copyWith( fontFamily: 'Eczar',),
          displayLarge: light.textTheme.displayLarge!.copyWith( fontFamily: 'RobotoCondensed',),
          displayMedium: light.textTheme.displayMedium!.copyWith( fontFamily: 'RobotoCondensed',),
          displaySmall: light.textTheme.displaySmall!.copyWith( fontFamily: 'Eczar',),
          titleLarge: light.textTheme.titleLarge!.copyWith(fontFamily: 'Eczar'),
          titleMedium: light.textTheme.titleMedium!.copyWith( fontFamily: 'RobotoCondensed',),
          titleSmall: light.textTheme.titleSmall!.copyWith( fontFamily: 'RobotoCondensed',),
          bodyLarge: light.textTheme.bodyLarge!.copyWith(fontFamily: 'Eczar'),
          bodyMedium: light.textTheme.bodyMedium!.copyWith( fontFamily: 'RobotoCondensed',),
          bodySmall: light.textTheme.bodySmall!.copyWith( fontFamily: 'RobotoCondensed',),
          labelLarge: light.textTheme.labelLarge!.copyWith(fontFamily: 'Eczar'),
          labelMedium: light.textTheme.labelMedium!.copyWith( fontFamily: 'RobotoCondensed',),
          labelSmall: light.textTheme.labelSmall!.copyWith( fontFamily: 'RobotoCondensed',),
        ),
      ),
      darkTheme: dark.copyWith(
        textTheme: dark.textTheme.apply(fontFamily: 'RobotoCondensed').copyWith(
          headlineLarge: dark.textTheme.headlineLarge!.copyWith( fontFamily: 'RobotoCondensed',),
          headlineMedium: dark.textTheme.headlineMedium!.copyWith( fontFamily: 'RobotoCondensed',),
          headlineSmall: dark.textTheme.headlineSmall!.copyWith( fontFamily: 'Eczar',),
          displayLarge: dark.textTheme.displayLarge!.copyWith( fontFamily: 'RobotoCondensed',),
          displayMedium: dark.textTheme.displayMedium!.copyWith( fontFamily: 'RobotoCondensed',),
          displaySmall: dark.textTheme.displaySmall!.copyWith( fontFamily: 'Eczar',),
          titleLarge: dark.textTheme.titleLarge!.copyWith(fontFamily: 'Eczar'),
          titleMedium: dark.textTheme.titleMedium!.copyWith( fontFamily: 'RobotoCondensed',),
          titleSmall: dark.textTheme.titleSmall!.copyWith( fontFamily: 'RobotoCondensed',),
          bodyLarge: dark.textTheme.bodyLarge!.copyWith(fontFamily: 'Eczar'),
          bodyMedium: dark.textTheme.bodyMedium!.copyWith( fontFamily: 'RobotoCondensed',),
          bodySmall: dark.textTheme.bodySmall!.copyWith( fontFamily: 'RobotoCondensed',),
          labelLarge: dark.textTheme.labelLarge!.copyWith(fontFamily: 'Eczar'),
          labelMedium: dark.textTheme.labelMedium!.copyWith( fontFamily: 'RobotoCondensed',),
          labelSmall: dark.textTheme.labelSmall!.copyWith( fontFamily: 'RobotoCondensed',),
        ),
      ),
      themeMode: ThemeMode.light,
      home: const MainScreen(),
    );
  }
}
