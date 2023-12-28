import 'package:flutter/material.dart';
import 'package:malak/main_page.dart';
import 'package:malak/temp_data_provider.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future main() async {
  sqfliteFfiInit();

  databaseFactory = databaseFactoryFfi;

  runApp(
    ChangeNotifierProvider(
      create: (context) => TempDataProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}
