import 'package:banda/providers/category_provider.dart';
import 'package:banda/services/category_service.dart';
import 'package:banda/views/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  final categoryService = await CategoryService.build();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CategoryProvider(categoryService))
      ],
      child: const BandaApp()
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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}
