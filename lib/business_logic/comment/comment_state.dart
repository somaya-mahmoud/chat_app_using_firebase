part of 'comment_cubit.dart';

@immutable
abstract class CommentStates {}

class CommentInitialState extends CommentStates {}

class AddCommentSuccessState extends CommentStates{}

class AddCommentFailureState extends CommentStates{

  late final String errorMessage;

  AddCommentFailureState(this.errorMessage);
}
class getCommentSuccessState extends CommentStates{}

class getCommentFailureState extends CommentStates{

  late final String errorMessage;

  getCommentFailureState(this.errorMessage);
}
