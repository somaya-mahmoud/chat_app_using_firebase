
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:instagram_firebase/data/models/post.dart';
import 'package:meta/meta.dart';
part 'add_post_state.dart';

class AddPostCubit extends Cubit<AddPostStates> {


  AddPostCubit() : super(AddPostInitialState());

  late Post post;

  void addPost({required String postContent, required File imageFile}) {
    post = Post.newInstance(postContent: postContent);
    print(post.toJson());
    uploadImage(imageFile);
  }

  void uploadImage(File imageFile) async {
    try {
      await FirebaseStorage.instance
          .ref('postsImages/${post.postId}')
          .putFile(imageFile);
             getImageUrl();
    } on FirebaseException catch (e) {
      emit(AddPostFailureState(e.toString()));
    }
  }

  void getImageUrl() async {
    try {
      post.postImageUrl = await FirebaseStorage.instance
          .ref('postsImages/${post.postId}')
          .getDownloadURL();
            insertNewPost();
    } on FirebaseException catch (e) {
      emit(AddPostFailureState(e.toString()));
    }
  }

   void insertNewPost(){
       FirebaseFirestore.instance.collection("posts")
           .doc(post.postId)
           .set(post.toJson())
           .then((value) {
            emit(AddPostSuccessState());
       }).catchError((error){
         emit(AddPostFailureState(error.toString()));
       });

   }

}