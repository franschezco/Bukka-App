import 'package:bukka/screens/dashboard/dashboard.dart';
import 'package:bukka/screens/home/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Prevent going back
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.all(20.0),
            alignment: Alignment.center,
            child: Column(
              children: [  Image(
                image: AssetImage('assets/images/success.gif'),
                width: 200,
                height: 200,
              ),
                SizedBox(height: 30),
                Text(
                  'Order Received',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Thank you for your order!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Your order has been received and is being processed.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 190),
                InkWell(
                  onTap:(){
                    Get.to(
                          () => DashboardPage(),
                      transition: Transition.leftToRightWithFade,
                    );

                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          colors: [Colors.yellow, Colors.orange],
                        ),
                      ),
                      child: MaterialButton(
                        minWidth: double.infinity,
                        onPressed:(){
                          Get.to(
                                () => DashboardPage(),
                            transition: Transition.leftToRightWithFade,
                          );

                        },
                        child: Text(
                          'Back to Dashboard',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ),
                    ).animate().slideY(delay: 900.ms, duration: 800.ms).saturate(),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
