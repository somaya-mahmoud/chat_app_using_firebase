

  import 'package:flutter/material.dart';
  import 'package:flutter_bloc/flutter_bloc.dart';
  import 'package:instagram_firebase/business_logic/login/login_cubit.dart';
  import 'package:responsive_sizer/responsive_sizer.dart';
  import 'package:instagram_firebase/ui/home_screen.dart';
  import 'package:instagram_firebase/ui/register_screen.dart';
  import 'package:instagram_firebase/ui/reusable_components.dart';

  class ShopLoginScreen extends StatefulWidget {

    @override
    _ShopLoginScreenState createState() => _ShopLoginScreenState();
  }

  class _ShopLoginScreenState extends State<ShopLoginScreen> {
  late LoginCubit cubit;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  bool isPasswordVisible = false;
   var formKey = GlobalKey<FormState>();
    @override
    Widget build(BuildContext context) {
      cubit = BlocProvider.of<LoginCubit>(context);
     // cubit = context.read<LoginCubit>();
      return BlocListener<LoginCubit, LoginStates>(
  listener: (context, state) {
    if(state is LoginSuccessState){
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen(),));
    }else if(state is LoginFailureState){
      print(state.errorMessage);
      SnackBar snackBar = SnackBar(content: Text(state.errorMessage),action: SnackBarAction(label: "OK", onPressed: () {

      },),);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  },
  child: Scaffold(
        body: Form(
          key: formKey,
            child:
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 22.sp),
          //margin: EdgeInsets.only(bottom: 60),
          child: ListView(
            shrinkWrap: true,
            //crossAxisAlignment:CrossAxisAlignment.start,
            //mainAxisAlignment:MainAxisAlignment.center,
            children: [
               Text("Login",
              style: TextStyle(fontSize: 28.sp,fontWeight: FontWeight.bold),),
              SizedBox(height: 15.sp,),
              Text("Login now to browse our hot offers",
              style: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.bold,
              color: Colors.grey[400]),
              ),
              SizedBox(height: 30.sp,),

                 myTextFormField(controller: emailController, validator:(value) => cubit.emailValidator(value.toString()) ,
                      prefixIcon: Icons.email,
                      keyboardType:TextInputType.emailAddress,
                      label: "Email Address"),


              SizedBox(height: 16.sp,),
              myTextFormField(controller: passwordController, validator:(value) => cubit.passwordValidator(value.toString()) ,
                  obsecureText:isPasswordVisible,
                  prefixIcon: Icons.lock,
                  suffixIcon: myIconWidget(),
                  label: "Password"),
              SizedBox(height: 26.sp,),
              myShopButtonWidget(onPressed: () {
                if (formKey.currentState!.validate()) {
                 cubit.login(email: emailController.text, password: passwordController.text);
                }
              }, texts: "Login"),
              SizedBox(height: 10.sp,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account ?? ",style:
                    TextStyle(fontSize: 15.sp,fontWeight: FontWeight.bold),),
                  TextButton(onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => RegisterScreen(),));
                  }, child: Text(
                    "REGISTER",style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.sp,
                    color: Colors.blue,
                  ),
                  )),
                ],
              ),

            ],
          ),
        )),
      ),
);

    }

    Widget myIconWidget(){
      return InkWell(
        onTap: () {
          isPasswordVisible = !isPasswordVisible;
          setState(() {

          });
        },
        child: isPasswordVisible ? Icon(Icons.visibility_off
        ,size: 22.sp,):Icon(Icons.visibility,size: 22.sp,),
      );
    }
  }
