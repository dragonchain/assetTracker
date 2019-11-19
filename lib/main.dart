import 'dart:async';
import 'package:flutter/material.dart';

import 'homepage.dart';

Future<void> main() async {
  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      home: HomepageScreen(),
    ),
  );
}
