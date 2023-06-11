import 'dart:convert';

import 'package:bukka/screens/checkout/sucess/success.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../animations/like.dart';
import '../../animations/textfield.dart';
import '../basket/ CartItem.dart';
import '../basket/cart_appbar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'cardpay.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  String selectedMethod = '';
  bool showProgress = false;
  String displayName = '';
  String UserId = '';
 String token ='';
  @override
  void initState() {
    super.initState();
    requestNotificationPermission();
    getFCMToken();
    getCurrentUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            children: [
              CartAppBar(heading: 'Checkout'),
              Container(
                height: 210,
                padding: const EdgeInsets.only(top: 15),
                decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(35),
                    topRight: Radius.circular(35),
                  ),
                ),
                child: Container(
                  height: 230,
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.yellow.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AnimatedTextField(
                          labelText: 'Delivery Address',
                          controller: addressController,
                          iconData: Icons.location_searching,
                          onChanged: (value) {},
                          keyboardType: TextInputType.name,
                        ).animate()
                            .fadeIn(delay: 300.ms, duration: 400.ms)
                            .saturate(),
                        AnimatedTextField(
                          labelText: 'Receiver Phone',
                          controller: phoneController,
                          iconData: Icons.phone,
                          onChanged: (value) {},
                          keyboardType: TextInputType.phone,
                        ).animate()
                            .fadeIn(delay: 300.ms, duration: 400.ms)
                            .saturate(),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (addressController.text.isEmpty || phoneController
                            .text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Empty Input Field.',
                              style: TextStyle(color: Colors.black),),
                            backgroundColor: Colors.yellow,
                            duration: Duration(seconds: 2),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          );
                          return;
                        } else {
                          FocusScope.of(context).requestFocus(FocusNode());
                          setState(() {
                            selectedMethod = 'Card';
                            showProgress = true;

                            const delayDuration = Duration(seconds: 10);
                            Future.delayed(delayDuration, () async {
                              setState(() {
                                showProgress = false;
                              });
                              var connectivityResult = await Connectivity()
                                  .checkConnectivity();
                              if (connectivityResult ==
                                  ConnectivityResult.none) {
                                // No internet connection
                                setState(() {
                                  showProgress = false;
                                });

                                // Show an error message or perform any necessary actions
                                print(
                                    'No internet connection. Please try again later.');
                              } else {
                                // Internet connection is available
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => CardPayScreen()),
                                );
                              }
                            });
                          });
                        }
                      },
                      child: Container(
                        width: 150,
                        height: 100,
                        decoration: BoxDecoration(
                          color: selectedMethod == 'Card'
                              ? Colors.black
                              : Colors.white60,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: selectedMethod == 'Card'
                                  ? Colors.blue.withOpacity(0.3)
                                  : Colors.grey.withOpacity(0.3),
                              blurRadius: 5,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.credit_card,
                              size: 40,
                              color: selectedMethod == 'Card'
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Pay with Card',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: selectedMethod == 'Card'
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        if (addressController.text.isEmpty || phoneController
                            .text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Empty Input Field.',
                              style: TextStyle(color: Colors.black),),
                            backgroundColor: Colors.yellow,
                            duration: Duration(seconds: 2),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          );
                          return;
                        } else {
                          FocusScope.of(context).requestFocus(FocusNode());
                          setState(() {
                            selectedMethod = 'Cash on Delivery';
                            showProgress = true;

                            const delayDuration = Duration(seconds: 15);
                            Future.delayed(delayDuration, () async {
                              setState(() {
                                showProgress = false;
                              });
                              var connectivityResult = await Connectivity()
                                  .checkConnectivity();
                              if (connectivityResult ==
                                  ConnectivityResult.none) {
                                // No internet connection
                                setState(() {
                                  showProgress = false;
                                });

                                // Show an error message or perform any necessary actions
                                print(
                                    'No internet connection. Please try again later.');
                              } else {
                                // Internet connection is available
                                submitCartToFirestore(UserId, token.toString());
                              }
                            }); });
                        }
                      },
                      child: Container(
                        width: 150,
                        height: 100,
                        decoration: BoxDecoration(
                          color: selectedMethod == 'Cash on Delivery'
                              ? Colors.black
                              : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: selectedMethod == 'Cash on Delivery'
                                  ? Colors.blue.withOpacity(0.3)
                                  : Colors.grey.withOpacity(0.3),
                              blurRadius: 5,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.local_shipping,
                              size: 40,
                              color: selectedMethod == 'Cash on Delivery'
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Cash on Delivery',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: selectedMethod == 'Cash on Delivery'
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 500.ms, duration: 600.ms).saturate(),
            ],
          ),
          // Circular Progress Indicator
          if (showProgress)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                  child: CustomCircularProgressIndicator()
              ),
            ),
        ],
      ),
    );
  }

  void getCurrentUserData() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        displayName = user.displayName ?? '';
        UserId = user.uid; // Assign the user ID to UserId
      });
    }
  }


  void submitCartToFirestore(String userId, String token) {
    CollectionReference cartCollection =
    FirebaseFirestore.instance.collection('orders');

    List<Map<String, dynamic>> itemsData =
    cartItems.map((item) => item.toMap()).toList();

    cartCollection
        .add({
      'userId': userId,
      'items': itemsData,
      'timestamp': DateTime.now(),
      'status': 'Order Received',
      'address': addressController.text,
      'transaction_status': 'Not Completed',
      'name': displayName,
      'phone': phoneController.text,
      'token': token.toString(),
    })
        .then((value) {
      print('Cart added to Firestore');
      cartItems.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Order has been received successfully!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );

      sendPushNotification('New Order', 'You have a new order!');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SuccessScreen()),
      );
    })
        .catchError((error) {
      print('Error adding cart to Firestore: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error', style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.yellow,
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    });
  }
}

  void getFCMToken() async{
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  String? token = await messaging.getToken();
  print('FCM token: $token');
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



void sendPushNotification(String title, String body) async {
  final url = Uri.parse('https://us-central1-bukka-63948.cloudfunctions.net/sendOrderNotification');

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'title': title,
      'body': body,
    }),
  );

  if (response.statusCode == 200) {
    print('Push notification triggered successfully');
  } else {
    print('Failed to trigger push notification: ${response.body}');
  }
}