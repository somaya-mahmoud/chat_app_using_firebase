import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_firebase/data/models/user.dart';
import 'package:instagram_firebase/local/my_shared.dart';
import 'package:meta/meta.dart';

part 'users_state.dart';

class UsersCubit extends Cubit<UsersStates> {

  UsersCubit() : super(UsersInitialState());

   List<MyUser> users = [];
   void getUsers(){
     FirebaseFirestore.instance
         .collection("flutterUsers")
         .get()
         .then((value) {
           handleUsersData(value);
     }).catchError((error)=> emit(GetUserFailureState(error.toString())));
   }

  void handleUsersData(QuerySnapshot<Map<String, dynamic>> value) {
     users.clear();
     for (var element in value.docs) {
       var user = MyUser.fromJson(element.data());
     //  if(user.profileImageUrl!= MyShared.getString(key: "profileImageUrl")){
       //element.id
       if( user.userId== FirebaseAuth.instance.currentUser!.uid){
        continue;
       }
       users.add(user);
     }

     emit(GetUsersSuccessState());
   }

}
