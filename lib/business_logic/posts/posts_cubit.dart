import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_firebase/data/models/post.dart';
import 'package:meta/meta.dart';
part 'posts_state.dart';

class PostsCubit extends Cubit<PostsStates> {

  PostsCubit() : super(PostsInitialState());

  List<Post> posts = [];

  void getPosts() {
    print('Posts => ${posts.length}');

    FirebaseFirestore.instance
        .collection('posts')
        .get()
        .then((QuerySnapshot querySnapshot) async{
      posts.clear();
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> json = doc.data() as Map<String, dynamic>;
        Post post = Post.fromJson(json);


        var likes = await FirebaseFirestore
        .instance.collection("posts")
        .doc(post.postId)
        .collection("likes")
        .get();
        post.likesCount = likes.docs.length;
        for (var element in likes.docs) {
          if(element.id == FirebaseAuth.instance.currentUser!.uid){
            post.isLiked = true;
            break;
          }
        }
        posts.add(post);
      }
      posts.reversed;
      emit(PostsGetSuccessState());
      print('Posts => ${posts.length}');
    });
  }

  void likePost({ required String postId}){
    String userId = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore
    .instance.
    collection("posts")
    .doc(postId)
    .collection("likes")
    .doc(userId)
    .set({"userId":userId})
    .then((value) {
      emit(LikePostSuccessState());
    }).catchError((error){
      emit(LikePostFailureState(error.toString()));
    });

  }

 void unLikePost({required String postId}){
   String userId = FirebaseAuth.instance.currentUser!.uid;
   FirebaseFirestore
       .instance.
   collection("posts")
       .doc(postId)
       .collection("likes")
       .doc(userId)
       .delete()
       .then((value) {
     emit(UnLikePostSuccessState());
   }).catchError((error){
     emit(UnLikePostFailureState(error.toString()));
   });

 }

}


