

  import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_firebase/business_logic/story/add_story_cubit.dart';
import 'package:instagram_firebase/data/models/story.dart';
  import 'package:story_view/controller/story_controller.dart';
  import 'package:story_view/story_view.dart';
  import 'package:story_view/widgets/story_view.dart';

 class StoryScreen extends StatefulWidget {
    List<Story> storiesDetails;
    StoryScreen(this.storiesDetails, {Key? key}) : super(key: key);

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
   final controller = StoryController();

    @override
    Widget build(BuildContext context) {
    List<StoryItem> stories = [];
    for (var element in widget.storiesDetails) {
      stories.add(StoryItem.pageImage(
          url: element.storyImageUrl!, controller: controller));
    }

    return StoryView(
      onStoryShow: (s) {
        //notifyServer(s)
      },
      repeat: false,
      onComplete:(){
        Navigator.pop(context);
      },
      storyItems: stories,
      controller: controller,
      onVerticalSwipeComplete: (direction) {
        if(direction==Direction.down){
          Navigator.pop(context);
        }
      },
    );



    }
}
