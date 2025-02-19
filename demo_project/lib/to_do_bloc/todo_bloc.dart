
import 'package:demo_project/data/todo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends HydratedBloc<TodoEvent, TodoState> {
  TodoBloc() : super(const TodoState()) {
    on<TodoStarted>(_onStarted);
    on<AddToDo>(_onAddTodo);
    on<RemoveToDo>(_onRemoveTodo);
    on<AleterToDo>(_onAlertTodo);
  }

  void _onStarted(TodoStarted event, Emitter<TodoState> emit) {
    if (state.status == TodoStatus.success) return;
    emit(state.copyWith(todos: state.todos, status: TodoStatus.success));
  }

  void _onAddTodo(AddToDo event, Emitter<TodoState> emit) {
    emit(
      state.copyWith(
        status: TodoStatus.success,
      ),
    );
    try {
      List<Todo> temp = [];
      temp.addAll(state.todos);
      temp.insert(0, event.todo);

      emit(state.copyWith(
        todos: temp,
        status: TodoStatus.success,
      ));
    } catch (e) {
      emit(
        state.copyWith(
          status: TodoStatus.error,
        ),
      );
    }
  }

  void _onRemoveTodo(RemoveToDo event, Emitter<TodoState> emit) {
    emit(
      state.copyWith(
        status: TodoStatus.loading,
      ),
    );
    try {
      state.todos.remove(event.todo);

      emit(state.copyWith(
        todos: state.todos,
        status: TodoStatus.success,
      ));
    } catch (e) {
      emit(
        state.copyWith(
          status: TodoStatus.error,
        ),
      );
    }
  }

  void _onAlertTodo(AleterToDo event, Emitter<TodoState> emit) {
    emit(
      state.copyWith(
        status: TodoStatus.loading,
      ),
    );

    try {
      state.todos[event.index].isDone == !state.todos[event.index].isDone;
      emit(state.copyWith(
        todos: state.todos,
        status: TodoStatus.success,
      ));
    } catch (e) {
      emit(
        state.copyWith(
          status: TodoStatus.error,
        ),
      );
    }
  }

  @override
  TodoState? fromJson(Map<String, dynamic> json) {
    return TodoState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(TodoState state) {
    return state.toJson();
  }
}
