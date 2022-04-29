import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_firebase/data/models/message.dart';
import 'package:meta/meta.dart';
part 'chatting_state.dart';

class ChattingCubit extends Cubit<ChattingStates> {
   List<Message> messages = [];
  ChattingCubit() : super(ChattingInitialState());

   void sendMessage(Message message) async{

    await FirebaseFirestore.instance
    .collection("flutterUsers")
    .doc(message.senderId)
    .collection("chats")
    .doc(message.receiverId)
    .collection("messages")
    .doc(message.messageId)
    .set(message.toJson());

 await FirebaseFirestore.instance
    .collection("flutterUsers")
    .doc(message.receiverId)
    .collection("chats")
    .doc(message.senderId)
    .collection("messages")
    .doc(message.messageId)
    .set(message.toJson());
     emit(SendingMessageSuccessState());
   }

   void getMessage(String receiverId){
     // before using realTime
      FirebaseFirestore.instance
                .collection("flutterUsers")
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection("chats")
                .doc(receiverId)
                .collection("messages")
               .get()
               .then((value) {
                 messages.clear();
                for (var element in value.docs) {
                  Message message = Message.fromJson(element.data());
                  messages.add(message);
                }
                emit(GetMessageSuccessState());
          });



   }

   void listenToMessage(String receiverId){
     //using realTime:
     FirebaseFirestore.instance
         .collection("flutterUsers")
         .doc(FirebaseAuth.instance.currentUser!.uid)
         .collection("chats")
         .doc(receiverId)
         .collection("messages")
          .orderBy("time")
          .limitToLast(1)
         .snapshots()
         .listen((event) {
         // messages.clear();
         Message message = Message.fromJson(event.docs[0].data());
        if(messages.last.time!=message.time){
          messages.add(message);

        }else{
          messages.last = message;
        }
       emit(GetMessageSuccessState());
     });
   }
}
