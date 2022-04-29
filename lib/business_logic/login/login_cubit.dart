import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_firebase/data/models/user.dart';
import 'package:instagram_firebase/local/my_shared.dart';
import 'package:meta/meta.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginStates> {

  LoginCubit() : super(LoginInitialState());

  void login({required String email, required String password}) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      getUserDate();
      emit(LoginSuccessState());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        emit(LoginFailureState('No user found for that email.'));
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        emit(LoginFailureState('Wrong password provided for that user.'));
      }
    } catch (error) {
      emit(LoginFailureState(error.toString()));
    }
  }

  emailValidator(String value) {
    if (value.isEmpty) {
      return "Email Required";
    }
    bool emailValid = RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(value);
    if (!emailValid) {
      return "email not valid";
    }
    else {
      return null;
    }
  }

  passwordValidator(String value) {
    if (value.isEmpty) {
      return "Password must be at least 6 characters";
    } else {
      return null;
    }
  }
  void getUserDate(){
    FirebaseFirestore.instance
        .collection("flutterUsers")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get().then((value) {
          if(value.data()==null) return;
       var user = MyUser.fromJson(value.data());
       saveUserData(user);
    },
    );
  }

  void saveUserData(MyUser user){
    MyShared.putString(key: "user", value: jsonEncode(user));


    MyShared.putString(key: "username", value: user.username??"");
    MyShared.putString(key: "profileImageUrl", value: user.profileImageUrl??"");

    emit(LoginSuccessState());

  }
}
