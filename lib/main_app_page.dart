import 'package:ceps_app/views/main_page.dart';
import 'package:flutter/material.dart';

class MainAppPage extends StatefulWidget {
  const MainAppPage({super.key});

  @override
  State<MainAppPage> createState() => _MainAppPageState();
}

class _MainAppPageState extends State<MainAppPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "CEPs",
      theme: ThemeData(),
      home: const MainPage(),
    );
  }
}
