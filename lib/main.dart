import 'package:custom_date_picker_example/app_theme.dart';
import 'package:custom_date_picker_example/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Custom Date Picker Example',
      home: const HomeScreen(),
      theme: AppTheme.lightTheme(context),
    );
  }
}
