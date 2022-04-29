

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_firebase/local/my_shared.dart';
import 'package:instagram_firebase/ui/home_screen.dart';
import 'package:instagram_firebase/ui/shop_login_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
   super.initState();
   Timer(Duration(seconds:8), () {
     // MyShared.getString(key: "username").isEmpty;
     // MyShared.getString(key: "apiToken").isEmpty;
     // FirebaseAuth.instance.signOut(); for deleting current user
     if(FirebaseAuth.instance.currentUser==null){
       Navigator.of(context).pushReplacement(MaterialPageRoute(
           builder: (BuildContext context) =>  ShopLoginScreen()));
     } else {
       Navigator.of(context).pushReplacement(
           MaterialPageRoute(builder: (BuildContext context) => HomeScreen()));
     }
     }
   );
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      body:
      Container(
             alignment: Alignment.center,
                margin: EdgeInsets.symmetric(vertical: 200),
        child: Column(
                 children: [
                   Image.network(
                     "http://metaphortune.com/wp-content/uploads/2016/06/instagram.jpg",fit:BoxFit.fill,width: 100,),
                   SizedBox(height: 15,),
                   Text("Instagram",style: TextStyle(fontWeight: FontWeight.normal,fontSize: 20,color: Colors.white),

                   ),
                 ],
               ),
      ),

    );
  }


}
