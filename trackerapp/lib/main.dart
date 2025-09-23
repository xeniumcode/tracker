import 'package:flutter/material.dart';
import 'package:tracker/frontend/system_info.dart';

Future<void> main() async {
  runApp(const SystemInfoApp());
}

class SystemInfoApp extends StatelessWidget {
  const SystemInfoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'System Info',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(),
      home: const SystemInfoScreen(),
    );
  }
}
