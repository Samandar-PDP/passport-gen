import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:passport_gen/screen/main_screen.dart';

void main() {
  runApp(PassportApp());
}
class PassportApp extends StatelessWidget {
  const PassportApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: const MainScreen(),
    );
  }
}
