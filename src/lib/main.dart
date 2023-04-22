import 'package:flutter/material.dart';
import 'package:seventv_for_whatsapp/screens/browser.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var theme = ThemeData.from(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0x00f49236), brightness: Brightness.dark),
        useMaterial3: true);

    return MaterialApp(
      title: '7TV for WhatsApp',
      theme: theme,
      home: const Browser(),
    );
  }
}
