import 'package:flutter/material.dart';
import 'pages/create.dart';
import 'pages/list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contas a Pagar',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        backgroundColor: Colors.white,
      ),
      routes: {
        '/': (context) => const ListPage(),
        'create': (context) => const CreateReminder(),
      },
      initialRoute: '/',
    );
  }
}
