import 'package:flutter/material.dart';
import 'package:reminder/models/reminder.dart';

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
      theme: ThemeData(primarySwatch: Colors.amber, backgroundColor: Colors.white),
      routes: {
        '/': (context) => const MyHomePage(),
        'create': (context) => const CreateReminder(),
      },
      initialRoute: '/',
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  final String title = "Contas a Pagar";

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return Container(
                  color: Colors.amber,
                  height: 100,
                  margin: EdgeInsets.all(24),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Flex(
                      direction: Axis.horizontal,
                      children: [
                        Expanded(child: Text('ewfwefewfef')),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Checkbox(value: true, onChanged: ((value) => {})),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {Navigator.pushNamed(context, 'create')},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class CreateReminder extends StatefulWidget {
  final String title = "Criar Lembrete";

  const CreateReminder({Key? key}) : super(key: key);

  @override
  _CreateReminderState createState() => _CreateReminderState();
}

class _CreateReminderState extends State<CreateReminder> {
  final titleController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Material(
              child: TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Título',
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 16),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () => {
                          Navigator.pop(
                            context,
                            ReminderModel(title: titleController.value.text),
                          )
                        },
                        child: const Text('Salvar'),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
