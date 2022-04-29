

//static => المتغير بيفضل محتفظ بقيمته طول ما الابلكيشن شغال وبقدر انادي عليه من خلال اسم الكلاس بدون ما اعمل منه اوبجكت
// يتم تعريفه مرة واحدة داخل main
//وده بيكثر استخدامه مع الداتا بيز لان مش كل ما احتاج اضيف او احذف صورة صورة او احذفها هعمل اوبجكت لان ده بيستهلك مساحة كبيرة من الداتا بيز


import 'package:shared_preferences/shared_preferences.dart';

class MyShared{
  static late SharedPreferences preferences;

  static Future<void> init()async{
    preferences = await SharedPreferences.getInstance();
  }

  static void putBoolean({required String key,required bool value})
  async {
   await preferences.setBool(key, value);
  }

  static bool getBoolean({required String key}){
   return preferences.getBool(key) ?? false;
  }

   static void putString({required String key,required String value}) async{
     await preferences.setString(key, value);
   }

   static String getString({required String key}){
    return preferences.getString(key) ?? "";
   }

}