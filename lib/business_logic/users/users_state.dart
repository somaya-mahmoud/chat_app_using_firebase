part of 'users_cubit.dart';

@immutable
abstract class UsersStates {}

class UsersInitialState extends UsersStates {}

class GetUsersSuccessState extends UsersStates{}

class GetUserFailureState extends UsersStates{

  late final String errorMessage;

  GetUserFailureState(this.errorMessage);
}
