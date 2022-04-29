import 'dart:async';
import 'dart:math';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging_platform_interface/firebase_messaging_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:instagram_firebase/business_logic/add_post/add_post_cubit.dart';
import 'package:instagram_firebase/business_logic/chatting/chatting_cubit.dart';
import 'package:instagram_firebase/business_logic/comment/comment_cubit.dart';
import 'package:instagram_firebase/business_logic/login/login_cubit.dart';
import 'package:instagram_firebase/business_logic/posts/posts_cubit.dart';
import 'package:instagram_firebase/business_logic/story/add_story_cubit.dart';
import 'package:instagram_firebase/business_logic/users/users_cubit.dart';
import 'package:instagram_firebase/local/my_shared.dart';
import 'package:instagram_firebase/ui/maps_screen.dart';
import 'package:instagram_firebase/ui/splash_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:instagram_firebase/ui/shop_login_screen.dart';
import 'business_logic/registration/register_cubit.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await MyShared.init();
  runApp(DevicePreview(builder: (context) =>  MyApp(),
  enabled: !kReleaseMode,
   // enabled: kDebugMode,
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  @override
  Widget build(BuildContext context) {
    FirebaseMessaging.instance.getToken().then((value) => print('FCM Token => $value'));

    return MultiBlocProvider(providers: [
      BlocProvider(create: (context) => LoginCubit(),),
      BlocProvider(create: (context) => RegisterCubit(),),
      BlocProvider(create: (context) => AddPostCubit(),),
      BlocProvider(create: (context) => PostsCubit(),),
      BlocProvider(create: (context) => CommentCubit(),),
      BlocProvider(create: (context) => AddStoryCubit(),),
      BlocProvider(create: (context) => UsersCubit(),),
      BlocProvider(create: (context) => ChattingCubit(),),
    ], child:MaterialApp(
      //  debugShowCheckedModeBanner: false,
      //useInheritedMediaQuery: true,
      // locale: DevicePreview.locale(context),
      // builder: DevicePreview.appBuilder,
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: ResponsiveSizer(builder: (p0, p1, p2) => //ShopLoginScreen(),
         // SplashScreen(),
        MapsScreen(),
      ),

    ),
    );
  }

  @override
  void initState() {
    super.initState();
    initNotifications(context);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    // Timer.periodic(Duration(milliseconds: 5000), (timer) {
    //   displayNotification();
    // });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification!.title}');
        print('Message also contained a notification: ${message.notification!.body}');
      }
      displayNotification(
        title: message.notification!.title!,
        body: message.notification!.body!,
        id:message.hashCode,
      );
    });
  }
  void initNotifications(context) async {
    // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    // FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) {

      },);

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (payload)async {
        if (payload != null) {
          debugPrint('notification payload: $payload');
        }
        await Navigator.push(
          context,
          MaterialPageRoute<void>(builder: (context) => SplashScreen()),
        );
      },);
    final bool? result = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    await Firebase.initializeApp();

    print("Handling a background message: ${message.messageId}");

    displayNotification(
      title: message.notification!.title!,
      body: message.notification!.body!,
      id:message.hashCode,
    );
  }
  void displayNotification({required String title,required String body,required int id}) async{
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails('your channel id', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        id,
      title,
      body,
      platformChannelSpecifics,
        payload: 'item x',
    );
  }

}

void onDidReceiveLocalNotification(int id, String? title, String? body, String? payload) {


}



