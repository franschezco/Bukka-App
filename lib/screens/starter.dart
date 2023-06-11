import 'package:bukka/screens/dashboard/dashboard.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';
import 'package:bukka/screens/home/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'auth/auth_page.dart';
import 'auth/login.dart';

class StarterScreen extends StatefulWidget {
  const StarterScreen({Key? key}) : super(key: key);

  @override
  State<StarterScreen> createState() => _StarterScreenState();
}

class _StarterScreenState extends State<StarterScreen> {
  @override
  void initState() {
    super.initState();
    requestNotificationPermission();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                'assets/images/starter-image.jpg',
              ),
              fit: BoxFit.cover),
        ),
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(.9),
                    Colors.black.withOpacity(.8),
                    Colors.black.withOpacity(.2),
                  ])),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Taking Order For Delivery',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto'),
                )
                    .animate()
                    .slideX(delay: 300.ms, duration: 500.ms)
                    .saturate(),
                SizedBox(
                  height: 20,
                ),
                Text('See resturants nearby by \nadding location',
                    style: TextStyle(
                        color: Colors.white,
                        height: 1.4,
                        fontSize: 18,
                        fontFamily: 'Roboto'))
                    .animate()
                    .slideX(delay: 700.ms, duration: 600.ms)
                    .saturate(),
                SizedBox(
                  height: 120,
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                          colors: [Colors.yellow, Colors.orange])),
                  child: MaterialButton(
                    minWidth: double.infinity,
                    onPressed: () {
                      Get.to(() =>  AuthPage(),
                          transition:
                          Transition.leftToRightWithFade,
                        );
                    },
                    child: Text(
                      'Start',
                      style: TextStyle(
                          color: Colors.white, fontFamily: 'Roboto'),
                    ),
                  ),
                ).animate().slideX(delay: 900.ms, duration: 800.ms).saturate(),
                SizedBox(
                  height: 30,
                ),
                Align(
                  child: Text(
                    'Now Deliver To Your Door Step 24/7.',
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontFamily: 'Roboto'),
                  ),
                ).animate().slideX(delay: 1200.ms, duration: 1000.ms).saturate(),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
void requestNotificationPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  // Handle the user's response to the permission request
  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  } else {
    print('User declined permission');
  }
}