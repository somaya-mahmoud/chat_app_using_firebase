part of 'chatting_cubit.dart';

@immutable
abstract class ChattingStates {}

class ChattingInitialState extends ChattingStates {}


class SendingMessageSuccessState extends ChattingStates{}


class SendingMessageFailureState extends ChattingStates{

  late String errorMessage;

  SendingMessageFailureState(this.errorMessage);
}


class GetMessageSuccessState extends ChattingStates{}

class GetMessageFailureState extends ChattingStates{

  late String errorMessage;

  GetMessageFailureState(this.errorMessage);
}