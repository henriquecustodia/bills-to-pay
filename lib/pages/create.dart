import 'package:flutter/material.dart';
import 'package:reminder/models/change-page-arguments.dart';
import 'package:reminder/services/selected-month-store.dart';
import '../models/reminder.dart';

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
    late ReminderModel reminder;

    if (isEditMode(context)) {
      ChangePageArguments args = getRouteArgs(context);
      reminder = getReminderById(args);
      setData(reminder);
    }

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
                        onPressed: () {
                          if (isEditMode(context)) {
                            SelectedMonthStore().edit(
                              ReminderModel(
                                title: titleController.value.text,
                                isCompleted: reminder.isCompleted,
                                id: reminder.id,
                              ),
                            );
                          } else {
                            SelectedMonthStore().add(
                              ReminderModel(title: titleController.value.text),
                            );
                          }

                          Navigator.pop(context);
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

  void setData(ReminderModel reminder) {
    titleController.value = titleController.value.copyWith(
      text: reminder.title,
      selection: TextSelection.collapsed(offset: reminder.title.length),
    );
  }

  ReminderModel getReminderById(ChangePageArguments args) {
    var reminder = SelectedMonthStore().getById(args.id);
    return reminder;
  }

  ChangePageArguments getRouteArgs(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ChangePageArguments;
    return args;
  }

  bool isEditMode(BuildContext context) => ModalRoute.of(context)!.settings.arguments != null;
}
