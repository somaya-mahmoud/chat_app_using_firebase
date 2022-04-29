

  import 'dart:io';
  import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_firebase/business_logic/add_post/add_post_cubit.dart';
  import 'package:responsive_sizer/responsive_sizer.dart';

 class PostScreen extends StatelessWidget {
   final File imageFile;
   final TextEditingController contentController = TextEditingController();

  late AddPostCubit cubit;

   PostScreen({Key? key, required this.imageFile}) : super(key: key);

  @override
    Widget build(BuildContext context) {
    cubit = BlocProvider.of<AddPostCubit>(context);
      return BlocListener<AddPostCubit,AddPostStates>(listener:(context, state) {
        if(state is AddPostSuccessState){
          Navigator.of(context).pop();
        } else if(state is AddPostFailureState){
          print(state.errorMessage);
          SnackBar snackBar = SnackBar(content: Text(state.errorMessage),
            action: SnackBarAction(label: "OK", onPressed: () {},),);
          ScaffoldMessenger.of(context).showSnackBar(snackBar);

        }
      },child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          title: Text("New Post",style: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.bold,),
          ),
          centerTitle: true,
          actions: [
            InkWell(
              borderRadius: BorderRadius.circular(50.sp),
              onTap: () {
                cubit.addPost(postContent: contentController.text, imageFile: imageFile);
              },
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 15.sp),
                child: Text("Share",style: TextStyle(color: Colors.blue,fontSize: 18.sp),),
              ),
            ),
          ],
        ),
        body:
           Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15.sp),
                width: 30.h,
                child: Image.file(imageFile,
                  fit: BoxFit.contain,),
              ),
              Expanded(child: TextFormField(
                controller: contentController,
                style: TextStyle(color: Colors.grey,fontSize: 16.sp),
                decoration: InputDecoration(
                  hintText: "Write a Caption",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey,fontSize: 16.sp),
                ),
              )),
            ],
          ),
        ),

      );
    }


  }
