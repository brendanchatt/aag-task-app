import 'package:flutter/material.dart';

import 'UI/home_screen.dart';

class AAGTaskApp extends StatelessWidget {
  const AAGTaskApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AAG Task App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
      ),
      home: HomeScreen(),
    );
  }
}
