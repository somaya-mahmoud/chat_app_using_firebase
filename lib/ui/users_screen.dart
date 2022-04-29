


  import 'package:flutter/material.dart';
  import 'package:flutter_bloc/flutter_bloc.dart';
  import 'package:instagram_firebase/business_logic/users/users_cubit.dart';
import 'package:instagram_firebase/data/models/user.dart';
import 'package:instagram_firebase/ui/chatting_screen.dart';
  import 'package:responsive_sizer/responsive_sizer.dart';


class UsersScreen extends StatefulWidget {
    const UsersScreen({Key? key}) : super(key: key);

    @override
    _UsersScreenState createState() => _UsersScreenState();
  }

  class _UsersScreenState extends State<UsersScreen> {
  late UsersCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of<UsersCubit>(context);
    cubit.getUsers();
  }

  @override
    Widget build(BuildContext context) {
    return BlocConsumer<UsersCubit,UsersStates>(
      buildWhen: (previous, current) => current is GetUsersSuccessState,
      builder: (context, state) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text("Chats"),
        ),
        body: ListView.builder(itemBuilder: (context, index) => buildChatItem(index),
        itemCount: cubit.users.length,
        ),
      );
    }, listener: (context, state) {

    },);
       
    }
  Widget buildChatItem(int index){
    MyUser user = cubit.users[index];
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ChattingScreen(user: user),));
      },
      child: Container(
        margin: EdgeInsets.all(15.sp),
        child: Row(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  radius: 26,
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
                  backgroundImage: NetworkImage(user.profileImageUrl ?? "https://wirepicker.com/wp-content/uploads/2021/09/android-vs-ios_1200x675.jpg"),
                  radius: 23,
                ),
              ],
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: Text(
                user.username ?? "Somaya Mahmoud",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
  }
  

