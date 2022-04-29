part of 'posts_cubit.dart';

@immutable
abstract class PostsStates {}

class PostsInitialState extends PostsStates {}

class PostsGetSuccessState extends PostsStates {}

class PostsGetFailureState extends PostsStates {}

class LikePostSuccessState extends PostsStates{}

class LikePostFailureState extends PostsStates{
  late final String errorMessage;

  LikePostFailureState(this.errorMessage);
}

class UnLikePostSuccessState extends PostsStates{}

class UnLikePostFailureState extends PostsStates{
  late final String errorMessage;
  UnLikePostFailureState(this.errorMessage);
}
