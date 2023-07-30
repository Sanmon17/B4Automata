import 'package:flutter/material.dart';
import 'homepage.dart';
import 'package:device_preview/device_preview.dart';
import 'fa.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => MyApp(), // Wrap your app
    ),
  );
}

class MyApp extends StatelessWidget {
  final FA faInstance = FA();
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // useInheritedMediaQuery: true,
      // locale: DevicePreview.locale(context),
      // theme: ThemeData.light(),
      // darkTheme: ThemeData.dark(),
      builder: DevicePreview.appBuilder,
      debugShowCheckedModeBanner: false,
      home: Homepage(faInstance: faInstance),
    );
  }
}
