part of 'add_story_cubit.dart';

@immutable
abstract class AddStoryStates {}

class AddStoryInitialState extends AddStoryStates {}

 class AddStorySuccessState extends AddStoryStates{}

 class AddStoryFailureState extends AddStoryStates{

   late final String errorMessage;

   AddStoryFailureState(this.errorMessage);


}

class GetHomeStoriesSuccessState extends AddStoryStates{}

class GetHomeStoriesFailureState extends AddStoryStates{

  late final String errorMessage;

  GetHomeStoriesFailureState(this.errorMessage);
}
class DeleteStoriesSuccessState extends AddStoryStates{}

class DeleteStoriesFailureState extends AddStoryStates{

  late final String errorMessage;

  DeleteStoriesFailureState(this.errorMessage);
}

class GetStoriesDetailsSuccessState extends AddStoryStates{
 late final List<Story> storiesDetails;

 GetStoriesDetailsSuccessState(this.storiesDetails);
}

class GetStoriesDetailsFailureState extends AddStoryStates{
  late String errorMessage;

  GetStoriesDetailsFailureState(this.errorMessage);
}






