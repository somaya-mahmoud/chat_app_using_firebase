import 'dart:io';
import 'package:instagram_firebase/data/models/comment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_firebase/business_logic/comment/comment_cubit.dart';
import 'package:instagram_firebase/local/my_shared.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CommentsScreen extends StatefulWidget {
  final String postId;

  const CommentsScreen({Key? key, required this.postId}) : super(key: key);

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  TextEditingController commentController = TextEditingController();
  late CommentCubit commentCubit;

  @override
  void initState() {
    super.initState();
    commentCubit = BlocProvider.of<CommentCubit>(context);
    commentCubit.comments.clear();
    commentCubit.getComments(postId: widget.postId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CommentCubit, CommentStates>(
      listener: (context, state) {
        // TODO: implement listener
        if (state is AddCommentSuccessState) {
          commentCubit.getComments(postId: widget.postId);
          commentController.clear();

        } else if (state is AddCommentFailureState) {
          SnackBar snackBar = SnackBar(content: Text(state.errorMessage),
            action: SnackBarAction(label: "OK", onPressed: () {},),);
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          title: Text(
            "Comments",
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: buildCommentListView(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.sp),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                        MyShared.getString(key: "profileImageUrl")),
                    radius: 22.sp,
                  ),
                  SizedBox(
                    width: 10.sp,
                  ),
                  Expanded(
                      child: TextFormField(
                        onFieldSubmitted: (value) {
                          commentCubit.addNewComment(
                              comment: value, postId: widget.postId);
                        },
                        controller: commentController,
                        textInputAction: TextInputAction.send,
                        style: const TextStyle(color: Colors.grey),
                        decoration: InputDecoration(
                          hintText: "Add a comment",
                          hintStyle: TextStyle(color: Colors.grey,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold),
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0.sp),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0.sp),
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 2.0.sp,
                            ),
                          ),
                        ),
                      ))
                ],
              ),
            ),
            space(),
          ],
        ),
      ),
    );
  }

  space() {
    if (Platform.isIOS) {
      return SizedBox(
        height: 10.sp,
      );
    }
    else {
      return const SizedBox(height: 0,);
    }
  }

  Widget buildCommentListView() {
    return BlocBuilder<CommentCubit, CommentStates>(
      buildWhen: (previous, current) => current is getCommentSuccessState,
      builder: (context, state) {
        return ListView.builder(
          itemCount: commentCubit.comments.length,
          itemBuilder: (context, index) {
            Comment comment = commentCubit.comments[index];
            return Padding(
              padding: EdgeInsets.all(15.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                        comment.userImageUrl.toString()),
                    radius: 18.sp,
                  ),
                  SizedBox(
                    width: 10.sp,
                  ),
                  Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                    text: comment.username,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text:
                                    comment.comment)
                              ])),
                          Text(
                            comment.commentTime ?? "",
                            style:
                            TextStyle(
                                fontSize: 15.sp, color: Colors.grey),
                          ),
                        ],
                        mainAxisAlignment: MainAxisAlignment.center,
                      ))
                ],
              ),
            );
          },
        );
      },
    );
  }
}





