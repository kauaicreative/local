import 'package:flutter/material.dart';
import 'home_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Qclick',
      theme: ThemeData(
        // fontFamily: "Averir",
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue), // FF001E
        // colorSchemeSeed: const Color(0xff000000),
        // colorSchemeSeed: const Color(0xffFF001E),
        // colorScheme: Theme.of(context) .colorScheme .copyWith(primary: const Color(0xffFF001E)), useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Qclick'),
    );
  }
}
