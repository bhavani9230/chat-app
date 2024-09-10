// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:we_chat_app/authentication/login.dart';


// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   if(kIsWeb){
//   Firebase.initializeApp(
//     options: const FirebaseOptions(
//        apiKey: "AIzaSyD3Oc14FC3Lt85ihoGsWZ_YE-DE0Qib1ps",
//   authDomain: "wechatapp-b8634.firebaseapp.com",
//   projectId: "wechatapp-b8634",
//   storageBucket: "wechatapp-b8634.appspot.com",
//   messagingSenderId: "251373079558",
//   appId: "1:251373079558:web:4e2fb27954a47609f8c787",
//   measurementId: "G-BNSFCRXE4W")
//   );}else {
//     Firebase.initializeApp();
//   }
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         // This is the theme of your application.
//         //
//         // TRY THIS: Try running your application with "flutter run". You'll see
//         // the application has a purple toolbar. Then, without quitting the app,
//         // try changing the seedColor in the colorScheme below to Colors.green
//         // and then invoke "hot reload" (save your changes or press the "hot
//         // reload" button in a Flutter-supported IDE, or press "r" if you used
//         // the command line to start the app).
//         //
//         // Notice that the counter didn't reset back to zero; the application
//         // state is not lost during the reload. To reset the state, use hot
//         // restart instead.
//         //
//         // This works for code too, not just values: Most code changes can be
//         // tested with just a hot reload.
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//            home: MyHomepage()
      
//     );
//   }
// }

// class MyHomepage extends StatefulWidget {
//   const MyHomepage({super.key});

//   @override
//   State<MyHomepage> createState() => _MyHomepageState();
// }

// class _MyHomepageState extends State<MyHomepage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: LoginForm(),
//     );
//   }
// }


import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:we_chat_app/API/apis.dart';
import 'package:we_chat_app/authentication/login.dart';
import 'package:we_chat_app/mainscreens/chat_members.dart';


//global object for accessing device screen size
late Size mq;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyD3Oc14FC3Lt85ihoGsWZ_YE-DE0Qib1ps",
          authDomain: "wechatapp-b8634.firebaseapp.com",
          projectId: "wechatapp-b8634",
          storageBucket: "wechatapp-b8634.appspot.com",
          messagingSenderId: "251373079558",
          appId: "1:251373079558:web:4e2fb27954a47609f8c787",
          measurementId: "G-BNSFCRXE4W"
        ),
      );
    } else {
      await Firebase.initializeApp();
    }
    runApp(const MyApp());
  } catch (e) {
    print('Error initializing Firebase: $e');
    // Optional: Show an error screen or handle the error as needed
  }
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'We Chat',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 1,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
              color: Colors.black, fontWeight: FontWeight.normal, fontSize: 19),
          backgroundColor: Colors.white,
        )),
        home:FirebaseAuth.instance.currentUser != null  ? ChatMembers():
        LoginForm());
  }
}

