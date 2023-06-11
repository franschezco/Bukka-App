import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';

import '../../animations/like.dart';
import '../../animations/textfield.dart';
import '../dashboard/dashboard.dart';
import 'auth_page.dart';
import 'login.dart';
class SignUpScreen extends StatefulWidget {
  SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController fullnameController = TextEditingController();

  TextEditingController pwdController = TextEditingController();
  bool isLoading = false;


// Create a new user with email and password
  Future<void> registerWithEmailAndPassword(TextEditingController emailController, TextEditingController passwordController, TextEditingController fullnameController) async {
    try {
      // Create the user with email and password
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Update the user's display name
      User user = userCredential.user!;
      await user.updateDisplayName(fullnameController.text);

      // Show success snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration successful!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );

      // Clear the form fields
      emailController.clear();
      passwordController.clear();
      fullnameController.clear();

      // Navigate to the authentication page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AuthPage()),
      );
    } catch (e) {
      // Handle the error
      print('Error creating user: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$e', style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.yellow,
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: ListView(children: [
          Container(
              padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: MediaQuery.of(context).size.height * 0.16),
              child: Center(
                  child: Column(children: [
                    Image.asset(
                      'assets/images/logo.png',
                      // replace with your own logo image path
                      width: 175.0,
                    ).animate().fadeIn(delay: 200.ms, duration: 200.ms).saturate(),
                    Text('Welcome to Bukka',
                        style: TextStyle(
                          color: Colors.yellow.shade700,
                          fontFamily: "Roboto",
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                        ))
                        .animate()
                        .fadeIn(delay: 200.ms, duration: 300.ms)
                        .saturate(),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text('Create an account',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: "Roboto",
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ))
                        .animate()
                        .fadeIn(delay: 200.ms, duration: 300.ms)
                        .saturate(),
                    const SizedBox(
                      height: 30,
                    ),
                    AnimatedTextField(
                      labelText: 'Full Name',
                      controller: fullnameController,
                      iconData: Icons.person,
                      onChanged: (value) {},
                      keyboardType: TextInputType.name,
                    ).animate().fadeIn(delay: 300.ms, duration: 400.ms).saturate(),
                    const SizedBox(height: 16.0),
                    AnimatedTextField(
                      labelText: 'Email',
                      controller:emailController,
                      iconData: Icons.email,
                      onChanged: (value) {},
                      keyboardType: TextInputType.emailAddress,
                    ).animate().fadeIn(delay: 300.ms, duration: 400.ms).saturate(),
                    const SizedBox(height: 16.0),
                    AnimatedTextField(
                      labelText: 'Password',
                      controller: passwordController,
                      iconData: Icons.lock,
                      onChanged: (value) {
                        // handle password value
                      },
                      obscureText: true,
                    ).animate().fadeIn(delay: 300.ms, duration: 400.ms).saturate(),
                    SizedBox(height: 16.0),
                    AnimatedTextField(
                      labelText: 'Re-enter Password',
                      controller: pwdController,
                      iconData: Icons.lock,
                      onChanged: (value) {
                        // handle password value
                      },
                      obscureText: true,
                    ).animate().fadeIn(delay: 300.ms, duration: 400.ms).saturate(),
                    const SizedBox(height: 26.0),
                  ]))),
          Padding(
            padding: const EdgeInsets.only(left: 20,right: 20.0),
            child:
                InkWell(
                  onTap: (){
                    Get.to(() =>  LoginPage(),
                        transition: Transition.leftToRightWithFade,
                        duration: const Duration(seconds: 1));},
                  child: RichText(
                    text: const TextSpan(
                      text: 'Have an account ',
                      style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey),
                      children: [
                        TextSpan(
                          text: 'Login!',
                          style: TextStyle(

                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Roboto',
                              color: Colors.black),
                        ),
                        WidgetSpan(
                          child: Padding(
                            padding: EdgeInsets.all(3.0),
                          ),)
                      ],)
                )
            ),
          ),
          const SizedBox(height: 46.0),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: LoadingButton(onPressed: () {
              FocusScope.of(context).requestFocus(FocusNode());
              setState(() {
                isLoading = true; // Start loading
              });

              // Simulate loading for 5 seconds
              Future.delayed(Duration(seconds: 5), () {
                setState(() {
                  isLoading = false; // Stop loading after 5 seconds
                });});
    if(passwordController.text == pwdController.text) {
    registerWithEmailAndPassword(emailController, passwordController, fullnameController);

    } else {
    print('password does not match');
    }
    }, buttonText: 'Login Account', isLoading: isLoading, ).animate().fadeIn(delay: 900.ms, duration: 800.ms).saturate(),

          ),
        ]));
  }
}
