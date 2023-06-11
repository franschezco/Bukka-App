import 'package:bukka/screens/auth/auth_page.dart';
import 'package:bukka/screens/auth/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../animations/like.dart';
import '../../animations/textfield.dart';
import '../dashboard/dashboard.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;
  bool _loading = false;
  String? _error;

  void check(){
    Get.to(
          () => AuthPage(),
      transition: Transition.leftToRightWithFade,
    );
  }

  void _signInWithEmailAndPassword() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (userCredential.user != null) {
        // Navigate to home page
        return check();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _error = 'No user found for that email.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No user found for that email.',style: TextStyle(color: Colors.black),),
            backgroundColor: Colors.yellow,
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );

      } else if (e.code == 'wrong-password') {
        _error = 'Wrong password provided for that user.';
        ScaffoldMessenger.of(context).showSnackBar( SnackBar(
          content: Text('No user found for that email.',style: TextStyle(color: Colors.black),),
          backgroundColor: Colors.yellow,
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
    );
      } else {
        _error = e.message;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      setState(() {
        _loading = false;
     return   check();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        backgroundColor: Colors.white,
        body: ListView(children: [
          Container(
              padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: MediaQuery.of(context).size.height * 0.26),
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
                const Text('Login your account',
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

                  labelText: 'Email',
                  iconData: Icons.email,
                  controller: _emailController,
                  onChanged: (value) {},
                  keyboardType: TextInputType.emailAddress,
                ).animate().fadeIn(delay: 300.ms, duration: 400.ms).saturate(),
                const SizedBox(height: 16.0),
                AnimatedTextField(
                  controller: _passwordController,
                  labelText: 'Password',
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: (){
                    Get.to(() =>  SignUpScreen(),
                      transition: Transition.leftToRightWithFade,
                      duration: const Duration(seconds: 1));},
                  child: RichText(
                    text: const TextSpan(
                      text: 'Don\'t have account ',
                      style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey),
                      children: [
                      TextSpan(
                          text: 'Register!',
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
                      ],
                    ),
                  ),
                ),
                const Text(
                  'Forgot Password',
                  style: TextStyle(fontSize: 14.0,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey),
                ),
              ],
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
              _signInWithEmailAndPassword();
            }, buttonText: 'Login Account', isLoading: isLoading, ).animate().fadeIn(delay: 900.ms, duration: 800.ms).saturate(),
          ),
        ]));
  }
}



