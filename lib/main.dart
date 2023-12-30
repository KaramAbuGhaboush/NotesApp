import 'package:flutter/material.dart';
import 'package:notes_app/add_note_page.dart';
import 'package:notes_app/main_page.dart';
import 'package:notes_app/temp_data_provider.dart';
import 'package:notes_app/update_note_page.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future main() async {
  sqfliteFfiInit();

  databaseFactory = databaseFactoryFfi;

  runApp(
    ChangeNotifierProvider(
      create: (context) => TempDataProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MainPage(),
      theme: MyAppThemes.lightTheme,
      darkTheme: MyAppThemes.darkTheme,
      themeMode: ThemeMode.dark,
      routes: {
        '/main_page': (context) => const MainPage(),
        '/add_note_page': (context) => const AddNotePage(),
        '/update_note_page': (context) => const UpdateNotePage(),
      },
    );
  }
}

class MyAppColors {
  static const yellow = Color(0xFFFFD700);
  static const black = Color(0xFF252525);
  static const white = Color(0xFFf2f2f3);
}

class MyAppThemes {
  static final lightTheme = ThemeData(
    primaryColor: MyAppColors.yellow,
    cardColor: MyAppColors.white,
    brightness: Brightness.light,
  );

  static final darkTheme = ThemeData(
    primaryColor: MyAppColors.yellow,
    cardColor: MyAppColors.black,
    brightness: Brightness.dark,
  );
}
