import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:instagram_firebase/data/models/user.dart';
import 'package:meta/meta.dart';
part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());
  late String email;
  late String username;
  late String phone;
  late String imageUrl;
  late File imageFile;

  void register({
    required String email,
    required String password,
    required String username,
    required String phone,
    required File imageFile,}) async {
    this.email = email;
    this.phone = phone;
    this.username = username;
    this.imageFile = imageFile;

      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ).then((value) {
        uploadFile();
      },
      ).catchError((error) {
        if (error == 'weak-password') {
          print('The password provided is too weak.');
          emit(RegisterFailureState('The password provided is too weak.'));
        } else if (error == 'email-already-in-use') {
          print('The account already exists for that email.');
          emit(
              RegisterFailureState(
                  'The account already exists for that email.'));
        } else {
          emit(RegisterFailureState(error.toString()));
        }
      },
        );

    }
  

  //  اسم الصورة بيتخزن بنفس الاسم اللي بعد علامة / عشان كده انا ممكن اخزن الصورة باستخدام ال id والطريقة دي بتضمن ان مفيش يوزر هييخزن علي بيانات او صور يوزر تاني لكن مشكلتها ا اليوزر لو غير صورته الصورة القديمة بتتمسح
  // وعشان نحل المشكلة دي بنستخدم DateTime.now

  Future<void> uploadFile() async {
    try {
      await FirebaseStorage.instance
          .ref('uploads/${FirebaseAuth.instance.currentUser!.uid}')
          .putFile(imageFile);
           getImageUrl();
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
    }
  }

  Future<void> getImageUrl() async {
   FirebaseStorage.instance
        .ref('uploads/${FirebaseAuth.instance.currentUser!.uid}')
        .getDownloadURL().then((value) {
     imageUrl = value;
     saveUserData();

   });
  }


  passwordValidator(String value) {
    if (value.isEmpty) {
      return "Password Required";
    }
    if (value.length < 6) {
      return " password must be at least 6 characters ";
    }
    bool passwordValid =
    RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
        .hasMatch(value);
    if (!passwordValid) {
      return "password not valid";
    }
    return null;
  }

  emailValidator(String value) {
    if (value.isEmpty) {
      return "please Enter Email";
    }
    bool emailValid = RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(value);
    if (!emailValid) {
      return "email not valid";
    }
    return null;
  }

  phoneValidator(String value) {
    if (value.isEmpty) {
      return "please Enter Phone Number";
    }
    String pattern = r'(^(?:[+0]9)?[0-9]{11}$)';
    RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      return 'Please enter mobile number';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter valid mobile number';
    }
  }

  usernameValidator(String value) {
    if (value.isEmpty) {
      return "please Enter User Name";
    }
    return null;
  }

  void saveUserData() {

    MyUser user = MyUser(

     username: username,
     email: email,
     phone: phone,
     profileImageUrl: imageUrl,
      userId: FirebaseAuth.instance.currentUser!.uid,
   );
   FirebaseFirestore.instance.collection("flutterUsers")
       .doc(FirebaseAuth.instance.currentUser!.uid)
       .set(user.toJson()).then((value) {
           emit(RegisterSuccessState());
   }).catchError((error){
     emit(RegisterFailureState(error.toString()));
   });
  }



}




