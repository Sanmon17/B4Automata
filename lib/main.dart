import 'package:flutter/material.dart';
import 'homepage.dart';
import 'package:device_preview/device_preview.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => const MyApp(), // Wrap your app
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // useInheritedMediaQuery: true,
      // locale: DevicePreview.locale(context),
      // theme: ThemeData.light(),
      // darkTheme: ThemeData.dark(),
      // builder: DevicePreview.appBuilder,
      debugShowCheckedModeBanner: false,
      home: Homepage(),
    );
  }
}
