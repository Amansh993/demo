import 'package:demo_project/data/todo.dart';
import 'package:demo_project/to_do_bloc/todo_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descripController = TextEditingController();

  addTodo(Todo todo) {
    context.read<TodoBloc>().add(
          AddToDo(todo),
        );
  }

  removeTodo(Todo todo) {
    context.read<TodoBloc>().add(
          RemoveToDo(todo),
        );
  }

  alterTodo(int index) {
    context.read<TodoBloc>().add(
          AleterToDo(index),
        );
  }

  addDialog() {
    Dialog errorDialog = Dialog(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromRGBO(255, 255, 255, 1),
            borderRadius: BorderRadius.circular(10),
          ),
          height: 200.h,
          width: 280.w,
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Column(
            children: [
              SizedBox(
                height: 10.h,
              ),
              Text(
                "Add To Item",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              TextFormField(
                enableInteractiveSelection: false,
                controller: titleController,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Color.fromRGBO(240, 240, 240, 1),
                  contentPadding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 0,
                      color: Colors.transparent,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 0,
                      color: Colors.transparent,
                    ),
                  ),
                  hintText: "Enter Title",
                  hintStyle: TextStyle(
                    color: Color.fromRGBO(154, 154, 154, 1),
                  ),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              TextFormField(
                enableInteractiveSelection: false,
                controller: descripController,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Color.fromRGBO(240, 240, 240, 1),
                  contentPadding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 0,
                      color: Colors.transparent,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 0,
                      color: Colors.transparent,
                    ),
                  ),
                  hintText: "Enter Description",
                  hintStyle: TextStyle(
                    color: Color.fromRGBO(154, 154, 154, 1),
                  ),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              GestureDetector(
                onTap: () {
                  addTodo(Todo(
                    title: titleController.text,
                    subTitle: descripController.text,
                  ));
                  titleController.text = "";
                  descripController.text = "";
                  Navigator.pop(context);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(154, 154, 154, 1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                      child: Text(
                    "Submit",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  )),
                ),
              ),
            ],
          ),
        ));

    return showGeneralDialog(
      barrierDismissible: true,
      barrierLabel: "de",
      context: context,
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child: errorDialog,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text("Todo App"),
          elevation: 5,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            addDialog();
          },
          child: Icon(Icons.add),
        ),
        body: BlocBuilder<TodoBloc, TodoState>(
          builder: (context, state) {
            if (state.status == TodoStatus.success) {
              return ListView.builder(
                itemCount: state.todos.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Color.fromRGBO(230, 255, 203, 1),
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Slidable(
                      key: const ValueKey(0),
                      startActionPane: ActionPane(
                        motion: ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (_) {
                              removeTodo(state.todos[index]);
                            },
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: "Delete",
                          )
                        ],
                      ),
                      child: ListTile(
                        title: Text(state.todos[index].title),
                        subtitle: Text(state.todos[index].subTitle),
                        trailing: Checkbox(
                          value: state.todos[index].isDone,
                          activeColor: Colors.black,
                          onChanged: (value) {
                            state.todos[index].isDone = value!;
                            alterTodo(index);
                          },
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (state.status == TodoStatus.initial) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Container();
            }
          },
        ));
  }
}
