import 'package:flutter/material.dart';
import 'package:reminder/models/change-page-arguments.dart';
import 'package:reminder/services/store.dart';
import '../models/reminder.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  final String title = "Contas a Pagar";

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  void toCreate() async {
    await Navigator.pushNamed(context, 'create');
  }

  FloatingActionButton createFloatingButton() {
    return FloatingActionButton(
      onPressed: () => toCreate(),
      tooltip: 'Adicionar',
      child: const Icon(Icons.add),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: const [
          Expanded(
            child: ReminderList(),
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
    required this.onEdit,
    required this.onRemove,
  }) : super(key: key);

  final ReminderModel reminder;
  final Function(bool) onChange;
  final Function(ReminderModel) onEdit;
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
                              onEdit(reminder),
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

class ReminderList extends StatelessWidget {
  const ReminderList({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<ReminderModel>>(
      valueListenable: Store(),
      builder: (context, value, child) {
        return ListView.builder(
          itemCount: value.length,
          itemBuilder: (context, index) {
            var reminder = value[index];

            return ListItem(
              reminder: reminder,
              onChange: (value) {
                toggleTheCompletedReminderState(reminder, index);
              },
              onRemove: (reminder) {
                removeItem(reminder);
              },
              onEdit: (reminder) {
                toEdit(context, reminder);
              },
            );
          },
        );
      },
    );
  }

  void toggleTheCompletedReminderState(ReminderModel reminder, int index) {
    var newReminder = ReminderModel(
      title: reminder.title,
      isCompleted: !reminder.isCompleted,
      id: reminder.id,
    );

    Store().edit(newReminder);
  }

  void removeItem(ReminderModel reminder) {
    Store().remove(reminder);
  }

  void toEdit(BuildContext context, ReminderModel reminder) async {
    await Navigator.pushNamed(
      context,
      '/change',
      arguments: ChangePageArguments(
        id: reminder.id!,
      ),
    );
  }
}
