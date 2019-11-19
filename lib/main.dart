import 'dart:async';
import 'package:flutter/material.dart';

import 'welcome_screen.dart';

Future<void> main() async {
  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      home: WelcomeScreen(),
    ),
  );
}
