import 'package:flutter/material.dart';
import 'package:reminder/services/store.dart';
import '../models/reminder.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  final String title = "Contas a Pagar";

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  void toggleTheCompletedReminderState(ReminderModel reminder, int index) {
    setState(() {
      var newReminder = ReminderModel(
        title: reminder.title,
        isCompleted: !reminder.isCompleted,
      );

      Store().list().replaceRange(index, index + 1, [newReminder]);
    });
  }

  void removeItem(ReminderModel reminder) {
    setState(() {
      Store().remove(reminder);
    });
  }

  void toCreate() async {
    await Navigator.pushNamed(context, 'create');
    setState(() {});
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
    var reminders = Store().list();

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
                  onRemove: (reminder) {
                    removeItem(reminder);
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
  ListItem({
    Key? key,
    required this.reminder,
    required this.onChange,
    required this.onRemove,
  }) : super(key: key);

  final ReminderModel reminder;
  final Function(bool) onChange;
  Function(ReminderModel) onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber,
      margin: const EdgeInsets.all(24),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Flex(
              direction: Axis.horizontal,
              children: [
                Expanded(
                  child: Text(reminder.title),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Checkbox(
                        value: reminder.isCompleted,
                        onChanged: (value) {
                          onChange!(value!);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 16),
              child: Flex(
                direction: Axis.horizontal,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                            ),
                            onPressed: () => {
                              Navigator.pushNamed(context, '/change-reminder'),
                            },
                            child: const Text('Editar'),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                ),
                                onPressed: () => {
                                      onRemove(reminder),
                                    },
                                child: const Text('Excluir')),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
