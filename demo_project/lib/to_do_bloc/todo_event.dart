part of 'todo_bloc.dart';

@immutable
abstract class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object?> get props => [];
}

class TodoStarted extends TodoEvent {}

class AddToDo extends TodoEvent {
  final Todo todo;
  const AddToDo(this.todo);

  @override
  List<Object?> get props => [todo];
}

class RemoveToDo extends TodoEvent {
  final Todo todo;
  const RemoveToDo(this.todo);

  @override
  List<Object?> get props => [todo];
}

class AleterToDo extends TodoEvent {
  final int index;
  const AleterToDo(this.index);

  @override
  List<Object?> get props => [index];
}
