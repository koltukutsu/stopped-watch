import 'package:flutter/material.dart';
import 'package:stopped_watch/color_schemes.g.dart';
import 'package:stopped_watch/ui/main_page.dart';

import 'count_down_timer-page.dart';
import 'count_up_timer_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      home: const MainPage(),
    );
  }
}

