import 'package:flutter/material.dart';
import '../models/reminder.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  final String title = "Contas a Pagar";

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List<ReminderModel> reminders = [];

  void addReminder(ReminderModel reminder) {
    setState(() {
      reminders.add(reminder);
    });
  }

  void toggleTheCompletedReminderState(ReminderModel reminder, int index) {
    setState(() {
      var newReminder = ReminderModel(
        title: reminder.title,
        isCompleted: !reminder.isCompleted,
      );

      reminders.replaceRange(index, index + 1, [newReminder]);
    });
  }

  void toCreate() async {
    final reminder = await Navigator.pushNamed(context, 'create') as ReminderModel;

    addReminder(reminder);
  }

  FloatingActionButton createFloatingButton() {
    return FloatingActionButton(
      onPressed: () => toCreate(),
      tooltip: 'Adicionar',
      child: const Icon(Icons.add),
    );
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
              itemCount: reminders.length,
              itemBuilder: (context, index) {
                var reminder = reminders[index];

                return ListItem(
                  reminder: reminder,
                  onChange: (value) {
                    toggleTheCompletedReminderState(reminder, index);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: createFloatingButton(), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class ListItem extends StatelessWidget {
  const ListItem({
    Key? key,
    required this.reminder,
    required this.onChange,
  }) : super(key: key);

  final ReminderModel reminder;
  final Function(bool)? onChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber,
      height: 100,
      margin: const EdgeInsets.all(24),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Flex(
          direction: Axis.horizontal,
          children: [
            Expanded(child: Text(reminder.title)),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Checkbox(
                  value: reminder.isCompleted,
                  onChanged: (value) {
                    onChange!(value!);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
