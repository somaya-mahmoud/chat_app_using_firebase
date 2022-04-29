import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:instagram_firebase/data/models/story.dart';
import 'package:instagram_firebase/local/my_shared.dart';
import 'package:meta/meta.dart';
part 'add_story_state.dart';

class AddStoryCubit extends Cubit<AddStoryStates> {


  AddStoryCubit() : super(AddStoryInitialState());

  void addStories(List<File> paths) async {
    int counter =1;
    for (var element in paths) {
      print('Add story $counter');
      await addStory(element);
      print('Story $counter added');
      counter++;
    }
  }

  Future<bool> addStory(File file) async {
    String ref =
        'stories/${FirebaseAuth.instance.currentUser!.uid + DateTime.now().toString()}';
    await _uploadImage(file, ref);
    String storyImageUrl = await _getImageUrl(ref);
    print('storyImageUrl => $storyImageUrl');
    await _insertStoryData(storyImageUrl);
    return true;
  }

  Future<bool> _uploadImage(File imageFile, String ref) async {
    try {
      await FirebaseStorage.instance.ref(ref).putFile(imageFile);

      return true;
    } on FirebaseException catch (e) {
      emit(AddStoryFailureState(e.toString()));
    }
    return false;
  }

  Future<String> _getImageUrl(String ref) async {
    String imageUrl = await FirebaseStorage.instance.ref(ref).getDownloadURL();
    return imageUrl;
  }

  Future<bool> _insertStoryData(String storyImageUrl) async {
    Story story = Story(
      username: MyShared.getString(key: "username"),
      userId: FirebaseAuth.instance.currentUser!.uid,
      userImageUrl: MyShared.getString(key: "profileImageUrl"),
      storyImageUrl: storyImageUrl,
      storyTime: DateTime.now().millisecondsSinceEpoch.toString(),
    );
    FirebaseFirestore.instance
        .collection("stories")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set(story.toJson());

    FirebaseFirestore.instance
        .collection("stories")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("myStories")
        .doc(story.storyTime)
        .set(story.toJson())
        .then((value) {


      emit(AddStorySuccessState());
      getHomeStories();
      return true;
    }).catchError((error) {
      emit(AddStoryFailureState(error.toString()));
    });

    return false;
  }

  List<Story> storiesDetails = [];

  List<Story> homeStories = [];

  void getHomeStories() {
    FirebaseFirestore.instance.collection("stories").get().then((value) {
      homeStories.clear();
      for (var element in value.docs) {
        Story story = Story.fromJson(element.data());

        const int day = 86400000;
        int currentMillis = DateTime.now().millisecondsSinceEpoch;
        int storyMillis = int.tryParse(story.storyTime!) ?? 0;
        int betweenMillis = currentMillis - storyMillis;
        bool isLessThanDay = betweenMillis < day;
        print('currentMillis $currentMillis');
        print('storyMillis $storyMillis');
        print('day $day');
        print('betweenMillis $betweenMillis');
        print('isLessThanDay $isLessThanDay');

        if (isLessThanDay) {
          homeStories.add(story);
        }
        else{
          // delete story from firestore after 24 hours
          FirebaseFirestore.instance.collection("stories").doc(story.userId).delete();
        }

      }
      emit(GetHomeStoriesSuccessState());
    });
  }

  void getStoriesDetails(String userId) {
    FirebaseFirestore.instance
        .collection("stories")
        .doc(userId)
        .collection("myStories")
        .get()
        .then((value) {
      print('story docs => ${value.docs.length}');
      storiesDetails.clear();
      for (var element in value.docs) {
        Story story = Story.fromJson(element.data());
        const int day = 86400000;
        int currentMillis = DateTime.now().millisecondsSinceEpoch;
        int storyMillis = int.tryParse(story.storyTime!) ?? 0;
        int betweenMillis = currentMillis - storyMillis;
        bool isLessThanDay = betweenMillis < day;
        print('currentMillis $currentMillis');
        print('storyMillis $storyMillis');
        print('day $day');
        print('betweenMillis $betweenMillis');
        print('isLessThanDay $isLessThanDay');

        if (isLessThanDay) {
          storiesDetails.add(story);
        }
        else{
          print('Deleted');
          FirebaseFirestore.instance.collection("stories").doc(userId)
              .collection("myStories").doc(story.storyTime).delete()
          .then((value) {
            emit(DeleteStoriesSuccessState());
            print('deleted successfully');
          }).catchError((error){
            emit(DeleteStoriesFailureState(error.toString()));
            print('deleted failed');
          });
        }
      }
      print(storiesDetails.length);
      emit(GetStoriesDetailsSuccessState(storiesDetails));
    });
  }


}





