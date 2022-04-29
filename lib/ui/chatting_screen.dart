

  import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_firebase/business_logic/chatting/chatting_cubit.dart';
import 'package:instagram_firebase/data/models/message.dart';
import 'package:instagram_firebase/data/models/user.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

  class ChattingScreen extends StatefulWidget {
  final MyUser user;
    const ChattingScreen({Key? key,required this.user}) : super(key: key);

    @override
    _ChattingScreenState createState() => _ChattingScreenState();
  }

  class _ChattingScreenState extends State<ChattingScreen> {

  final TextEditingController messageController = TextEditingController();
  final ScrollController _controller = ScrollController();
  late ChattingCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of<ChattingCubit>(context);
     //  cubit.messages.clear();
    cubit.getMessage(widget.user.userId??"");
    cubit.listenToMessage(widget.user.userId??"");
  }

// بتشتغل وانا بعمل باك واخرج من الاسكرين اللي انا فيها
  @override
  void dispose() {
    super.dispose();
    cubit.messages.clear();
  }

  @override
    Widget build(BuildContext context) {
      return BlocListener<ChattingCubit, ChattingStates>(
    listener: (context, state) {
    // if(state is SendingMessageSuccessState){
    //   messageController.clear();
    // }
  },
  child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: Colors.black,
          title: Row(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 20,
                    child: Container(
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(colors: [
                            Color(0xff833ab4),
                            Color(0xfffd1d1d),
                            Color(0xfffcb045),
                          ])),
                    ),
                  ),
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.user.profileImageUrl ?? "https://wirepicker.com/wp-content/uploads/2021/09/android-vs-ios_1200x675.jpg"),
                    radius: 18,
                  ),
                ],
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  widget.user.username ?? "Somaya Mahmoud",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        body:  Column(
          children: [
            buildChattingListView(),
            buildFloatingActionButton(),
            buildMessageTextFormField(),

          ],
        ),
      ),
);
    }

   Widget buildChattingListView() {
      return Expanded(
        child: BlocBuilder<ChattingCubit, ChattingStates>(
          buildWhen: (previous, current) => current is GetMessageSuccessState,
      builder: (context, state) {
          return ListView.builder(itemBuilder: (context, index) {
            Message message = cubit.messages[index];
         if(message.senderId==FirebaseAuth.instance.currentUser!.uid){
           return buildSendingMessage(message.message??"");
         }else{
           return buildReceivingMessage(message.message??"");
         }

        }, controller: _controller,
        itemCount: cubit.messages.length,
        );
  },
),
      );
   }

   Widget buildSendingMessage(String message){
      return Container(
        alignment: Alignment.centerRight,
        child: Container(
         // width: double.infinity,
          margin: EdgeInsets.only(top: 10.sp,bottom: 10.sp,right: 15.sp,left: 20.w),
          padding: EdgeInsets.symmetric(vertical: 15.sp,
          horizontal: 10.sp),
         // alignment: Alignment.centerRight,
          child: Text(message,style: TextStyle(color: Colors.black,fontSize: 18.sp),),
          decoration: BoxDecoration(
            color: Colors.blueGrey,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.sp),
              topRight: Radius.circular(15.sp),
              bottomLeft: Radius.circular(15.sp),
            ),
          ),
        ),
      );
   }

   Widget buildReceivingMessage(String message){
      return Container(
        alignment: Alignment.centerLeft,
        child: Container(
         // width: double.infinity,
          margin: EdgeInsets.only(top: 10.sp,bottom: 10.sp,right: 25.w,left: 10.sp),
          padding: EdgeInsets.symmetric(vertical: 15.sp,
          horizontal: 10.sp),
          //alignment: Alignment.centerLeft,
          child: Text(message,style: TextStyle(color: Colors.black,fontSize: 18.sp),),
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.sp),
              topRight: Radius.circular(15.sp),
              bottomRight: Radius.circular(15.sp),
            ),
          ),
        ),
      );
   }

   Widget buildMessageTextFormField() {
      return Container(
        margin: EdgeInsets.all(15.sp),
        padding: EdgeInsets.all(10.sp),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
          color: Colors.grey,
        ),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: messageController,
                style: TextStyle(color: Colors.black,fontSize: 17.sp),
                decoration: InputDecoration(
                  hintText: "Write Your Message",
                  hintStyle: TextStyle(color: Colors.black,fontSize: 15.sp),
                  border: InputBorder.none,
                ),
              ),
            ),
            IconButton(onPressed: () {
               sendMessage();
            }, icon: Icon(Icons.send,size: 25.sp,)),
          ],
        ),
      );
   }

   void sendMessage(){
   String messageContent = messageController.text;
   String userId = FirebaseAuth.instance.currentUser!.uid;
   String time = DateTime.now().toString();

   Message message = Message(
     messageId: time + userId,
     senderId: userId,
     receiverId: widget.user.userId,
     message: messageContent,
     time: time,
   );
   cubit.sendMessage(message);
   messageController.clear();
   }

   Widget buildFloatingActionButton(){

return Container(
  color: Colors.black,
  alignment: Alignment.bottomRight,
    child: FloatingActionButton.small(onPressed: () {
      _scrollDown();
    },
      backgroundColor: Colors.black,
      child: Icon(Icons.arrow_downward,color: Colors.grey,),
    ),

);
  }

    void _scrollDown() {
      _controller.jumpTo(_controller.position.maxScrollExtent);
    }
  }
