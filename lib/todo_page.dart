

import 'package:flutter/material.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ToDo extends StatefulWidget {
  const ToDo({Key? key}) : super(key: key);

  @override
  State<ToDo> createState() => _ToDoState();
}

class _ToDoState extends State<ToDo> {
  TextEditingController taskController = TextEditingController();
  TextEditingController UpdateTaskController = TextEditingController();

  Box? box;

  @override
  void initState() {
    box = Hive.box("todos");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("To Do App"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          Text("Your Tasks",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          TextField(
            controller: taskController,
            decoration: InputDecoration(
              hintText: "Add your new todo",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
            ),
          ),
          ElevatedButton.icon(
              onPressed: () {
                var todos = taskController.text;
                if (!todos.toString().isEmpty) {
                  box!.add(todos);
                }
              },
              icon: Icon(Icons.add_task),
              label: Text("ADD")),
          Expanded(
              child: ValueListenableBuilder(
                  valueListenable: box!.listenable(),
                  builder: ((context, value, child) {
                    return ListView.builder(
                        itemCount: box!.keys.toList().length,
                        itemBuilder: ((context, index) {
                          return InkWell(
                            onTap: () => showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      content: SizedBox(
                                        height: 100,
                                        width: double.infinity,
                                        child: Column(
                                          children: [
                                            TextField(
                                              controller: UpdateTaskController,
                                              decoration: InputDecoration(
                                                  hintText: box!
                                                      .getAt(index)
                                                      .toString()),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                ElevatedButton(
                                                    onPressed: () {
                                                      if (!UpdateTaskController
                                                          .text.isEmpty) {
                                                        box!.putAt(
                                                            index,
                                                            UpdateTaskController
                                                                .text);
                                                      }
                                                    },
                                                    child: Text("Update")),
                                                ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            primary:
                                                                Colors.red),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text("Cancel"))
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    )),
                            child: Card(
                              elevation: 2,
                              child: ListTile(
                                title: Text(box!.getAt(index).toString()),
                                trailing: InkWell(
                                    onTap: () {
                                      box!.deleteAt(index);
                                    },
                                    child: Icon(Icons.delete)),
                              ),
                            ),
                          );
                        }));
                  })))
        ]),
      ),
    );
  }
}
