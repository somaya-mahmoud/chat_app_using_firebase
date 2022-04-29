// 1- create user account(auth).
// 2- upload image(storage).
// 3- get image url(storage).
// 4-save user data (Firestore).
// Firestore دي عبارة عن الداتا بيز اللي بنحط فيها ال strings,bools,ints,doubles أما ال storage دي اللي بنخزن عليها الفايلات زي الصور وهكذا

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_firebase/business_logic/registration/register_cubit.dart';
import 'package:instagram_firebase/ui/reusable_components.dart';
import 'package:flutter/material.dart';
import 'package:instagram_firebase/ui/shop_login_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:firebase_storage/firebase_storage.dart';

class RegisterScreen extends StatefulWidget {


  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  bool isPasswordVisible = false;
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  late RegisterCubit cubit;

  @override
  Widget build(BuildContext context) {
    cubit = BlocProvider.of<RegisterCubit>(context);
    return BlocListener<RegisterCubit, RegisterStates>(
      listener: (context, state) {
        if (state is RegisterSuccessState) {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => ShopLoginScreen(),));
        } else if (state is RegisterFailureState) {
          print(state.errorMessage);
          SnackBar snackBar = SnackBar(content: Text(state.errorMessage),
            action: SnackBarAction(label: "OK", onPressed: () {},),);
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
        // TODO: implement listener
      },
      child: Scaffold(
        body: SafeArea(
          child: Form(
            key: formKey,
            child: Container(
              padding: EdgeInsets.all(10),
              child: ListView(
                children: [
                  Column(
                    children: [
                      Container(
                          margin: EdgeInsets.only(top: 80, right: 110),
                          child: Text("REGISTER", style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 45,
                              color: Colors.black),)),
                      SizedBox(height: 20,),
                      Text("Register now to browse our hot offers",
                        style: TextStyle(fontWeight: FontWeight.normal,
                            fontSize: 20,
                            color: Colors.grey),),
                      SizedBox(
                        height: 18,
                      ),
                      buildProfileImage(),
                      SizedBox(
                        height: 18.sp,
                      ),
                      myTextFormField(controller: nameController,
                          validator: (value) =>
                              cubit.usernameValidator(value.toString()),

                          prefixIcon: Icons.email,
                          label: "Name",
                          keyboardType: TextInputType.name),
                      SizedBox(height: 15,),
                      myTextFormField(controller: emailController,
                          validator: (value) =>
                              cubit.emailValidator(value.toString()),
                          prefixIcon: Icons.person,
                          label: "Email Address",
                          keyboardType: TextInputType.emailAddress),
                      SizedBox(height: 15,),
                      myTextFormField(controller: passwordController,
                          validator: (value) =>
                              cubit.passwordValidator(value.toString()),
                          obsecureText: isPasswordVisible,
                          prefixIcon: Icons.lock,
                          suffixIcon: myIconWidget(),
                          label: "Password"),
                      SizedBox(height: 15,),
                      myTextFormField(controller: phoneController,
                          validator: (value) =>
                              cubit.phoneValidator(value.toString()),
                          prefixIcon: Icons.phone,
                          label: "Phone",
                          keyboardType: TextInputType.phone),
                      SizedBox(height: 15,),
                      myButtonWidget(onPressed: () {
                        register();
                      }, texts: "REGISTER"),

                    ],
                  ),
                ],
              ),


            ),
          ),
        ),

      ),
    );
  }


    void register() {
      if (image == null) {
        SnackBar snackBar = SnackBar(content: Text("Select image!"),
          action: SnackBarAction(label: "OK", onPressed: () {},),);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      }
      if (formKey.currentState!.validate()) {
        cubit.register(
          email: emailController.text,
          password: passwordController.text,
          phone: phoneController.text,
          username: nameController.text,
          imageFile: File(image!.path),

        );
      }
    }

  Widget myIconWidget() {
    return InkWell(
      onTap: () {
        isPasswordVisible = !isPasswordVisible;
        setState(() {

        });
      },
      child: isPasswordVisible ? Icon(Icons.visibility_off
          , size: 22) : Icon(Icons.visibility, size: 22),
    );
  }

  XFile ? image;
  buildProfileImage(){
    return InkWell(
      onTap: () async {
        final ImagePicker _picker = ImagePicker();
        image = await _picker.pickImage(source: ImageSource.gallery);
        setState(() {

        });
      },
      child: image == null
          ? CircleAvatar(
          radius: 25.sp,
          child: Icon(
            Icons.person,
            size: 33.sp,
          ))
          : Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(35.sp),
          child: Image.file(
            File(image!.path),
            fit: BoxFit.fill,
            width: 35.sp,
            height: 35.sp,
          ),
        ),
      ),
    );
  }
}