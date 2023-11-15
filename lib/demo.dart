import 'package:flutter/material.dart';
import 'package:retrieve_device_info/main.dart';

// Use the classes or functions from the library

class demoApp extends StatefulWidget {
  const demoApp({Key? key}) : super(key: key);

  @override
  State<demoApp> createState() => _demoAppState();
}

class _demoAppState extends State<demoApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My App'),
      ),
      body:
          ContactSmsScreen(), // Use widgets from the retrive_device_info package
    );
  }
}
