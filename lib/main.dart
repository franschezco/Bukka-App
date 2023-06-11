
import 'package:bukka/screens/starter.dart';
import 'package:flutter/material.dart';
import 'config/theme.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:page_transition/page_transition.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Bukka',
      debugShowCheckedModeBanner: false,
      theme: theme(),
       home:  AnimatedSplashScreen(
           duration: 4500,
           backgroundColor: Colors.white ,
           splash: 'assets/images/logo.png',
           nextScreen:  StarterScreen(),
           pageTransitionType: PageTransitionType.rightToLeftWithFade

       ),
    );
  }
}
