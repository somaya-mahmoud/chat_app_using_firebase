part of 'add_post_cubit.dart';

@immutable
abstract class AddPostStates {}

class AddPostInitialState extends AddPostStates {}

class AddPostSuccessState extends AddPostStates{}

class AddPostFailureState extends AddPostStates{

  late final String errorMessage;

  AddPostFailureState(this.errorMessage);
}
