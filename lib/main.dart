import 'package:flutter/material.dart';
import 'package:flutter_memory_game/pages/game_page_view.dart';
import 'package:flutter_memory_game/pages/home_page_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memory Game',
      theme: ThemeData(
        
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      routes: {
        '/home': (context) => const HomePage(),
        '/game': (context) => const GamePage(),
      },
      initialRoute: '/home',
    );
  }
}

