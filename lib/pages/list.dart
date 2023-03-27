import 'package:flutter/material.dart';
import 'package:reminder/models/change-page-arguments.dart';
import 'package:reminder/services/db.dart';
import 'package:reminder/services/selected-month-store.dart';
import '../models/reminder.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  final String title = "Contas a Pagar";

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  var months;
  var selectedMonth;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // months = await Db().getKeys();
    selectedMonth = SelectedMonthStore().getFormattedSelectedMonth();
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
        children: [
          DropdownButtonExample(
            months: ['2017-03', '2017-04', '2017-05'],
            selectedMonth: selectedMonth,
            onSelectMonth: onSelectMonth,
          ),
          Expanded(
            child: const ReminderList(),
          ),
        ],
      ),
      floatingActionButton:
          createFloatingButton(), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void onSelectMonth(String month) {
    SelectedMonthStore().set(month);
  }

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
}

class ReminderList extends StatelessWidget {
  const ReminderList({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<ReminderModel>>(
      valueListenable: SelectedMonthStore(),
      builder: (context, value, child) {
        var completedItems = value
            .where((element) => element.isCompleted)
            .map((reminder) => createListItem(reminder, context))
            .toList();

        var notCompletedItems = value
            .where((element) => !element.isCompleted)
            .map((reminder) => createListItem(reminder, context))
            .toList();

        var completedItemsHeader = Container(
          margin:
              notCompletedItems.isEmpty ? const EdgeInsets.only(top: 24) : null,
          child: Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text('Pago'),
            ],
          ),
        );

        var notCompletedItemsHeader = Container(
          margin: const EdgeInsets.only(top: 24),
          child: Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text('À Pagar'),
            ],
          ),
        );

        List<Widget> list = [];

        if (notCompletedItems.isNotEmpty) {
          list.add(notCompletedItemsHeader);
          list.addAll(notCompletedItems);
        }

        if (completedItems.isNotEmpty) {
          list.add(completedItemsHeader);
          list.addAll(completedItems);
        }

        return ListView(children: list);
      },
    );
  }

  ListItem createListItem(ReminderModel reminder, BuildContext context) {
    return ListItem(
      reminder: reminder,
      onChange: (value) {
        toggleTheCompletedReminderState(reminder);
      },
      onRemove: (reminder) {
        removeItem(reminder);
      },
      onEdit: (reminder) {
        toEdit(context, reminder);
      },
    );
  }

  void toggleTheCompletedReminderState(ReminderModel reminder) {
    var newReminder = ReminderModel(
      title: reminder.title,
      isCompleted: !reminder.isCompleted,
      id: reminder.id,
    );

    SelectedMonthStore().edit(newReminder);
  }

  void removeItem(ReminderModel reminder) {
    SelectedMonthStore().remove(reminder);
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
      color: Colors.black54,
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
                      const Text('Pago'),
                      Checkbox(
                        value: reminder.isCompleted,
                        onChanged: (value) {
                          onChange(value!);
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
                            // style: ElevatedButton.styleFrom(
                            //     // backgroundColor: Colors.white,
                            //     ),
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
                                // style: ElevatedButton.styleFrom(
                                //     // backgroundColor: Colors.white,
                                //     ),
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

class DropdownButtonExample extends StatefulWidget {
  const DropdownButtonExample({
    super.key,
    required this.months,
    required this.selectedMonth,
    required this.onSelectMonth,
  });

  final List<String> months;
  final String selectedMonth;
  final Function(String) onSelectMonth;

  @override
  State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  String? selectedValue;

  @override
  void initState() {
    selectedValue = widget.selectedMonth;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          selectedValue = value;
          widget.onSelectMonth(value as String);
        });
      },
      items: widget.months.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
