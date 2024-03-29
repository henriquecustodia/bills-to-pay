import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reminder/services/db.dart';
import 'package:reminder/services/selected-month-store.dart';
import 'pages/create.dart';
import 'pages/list.dart';

void main() async {
  runApp(const MyApp());
  await SelectedMonthStore().init();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contas a Pagar',
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(),
      ),
      routes: {
        '/': (context) => const ListPage(),
        'create': (context) => const CreateReminder(),
        '/change': (context) => const CreateReminder(),
      },
      initialRoute: '/',
    );
  }
}
