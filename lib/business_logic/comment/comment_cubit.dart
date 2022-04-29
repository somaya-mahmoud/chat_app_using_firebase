
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_firebase/data/models/comment.dart';
import 'package:bloc/bloc.dart';
import 'package:instagram_firebase/local/my_shared.dart';
import 'package:meta/meta.dart';

part 'comment_state.dart';

class CommentCubit extends Cubit<CommentStates> {

  CommentCubit() : super(CommentInitialState());


  void addNewComment({required String comment,required String postId}){
    String userId = FirebaseAuth.instance.currentUser!.uid;
    String time = DateTime.now().toString();
    Comment commentData = Comment(
      comment: comment,
      commentId: time+userId,
      commentTime: time,
      userId: userId,
      username: MyShared.getString(key: "username"),
      userImageUrl: MyShared.getString(key: "profileImageUrl"),
    );

    FirebaseFirestore.instance
        .collection("posts")
        .doc(postId)
         .collection("comments")
         .doc(commentData.commentId)
          .set(commentData.toJson())
    .then((value) {
      emit(AddCommentSuccessState());
    }).catchError((error){
      emit(AddCommentFailureState(error.toString()));
    });

  }

  void getComments({required String postId}){
    FirebaseFirestore.instance
        .collection("posts")
        .doc(postId)
        .collection("comments")
        .get()
        .then((value) => handleCommentsResponse(value))
        .catchError((error){
      emit(AddCommentFailureState(error.toString()));
    });

  }
  List<Comment> comments = [];
  handleCommentsResponse(QuerySnapshot<Map<String, dynamic>> value) {
    comments.clear();
    for (var element in value.docs) {
      Comment comment = Comment.fromJson(element.data());
      comments.add(comment);
    }
    emit(getCommentSuccessState());
  }


}



