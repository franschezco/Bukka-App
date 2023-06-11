import 'package:bukka/screens/basket/%20CartItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../auth/auth_page.dart';

class CartAppBar extends StatelessWidget {
  final String heading;
  const CartAppBar({Key? key,required this.heading}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      color:Colors.white,
      padding: EdgeInsets.all(25),
      child: Row(
       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
           InkWell(onTap: (){Navigator.pop(context);}, child: Icon(Icons.arrow_back)),
          Spacer(),
          Text(heading,style: TextStyle(fontSize: 23,color: Colors.black,fontWeight: FontWeight.bold,fontFamily: 'Roboto',),),
        Spacer()
        ],
      ),
    );
  }
}




class CartBottomNavBar extends StatelessWidget {
  const CartBottomNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
        height: 130,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total',style: TextStyle(
                  color: Colors.yellow,fontFamily: 'Roboto',fontSize: 22,fontWeight: FontWeight.bold
                ),),
                Text('3567',style: TextStyle(
                    color: Colors.black,fontFamily: 'Roboto',fontSize: 25,fontWeight: FontWeight.bold
                ),),
              ],
            ), Container(
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
                  'Checkout',
                  style: TextStyle(
                      color: Colors.white, fontFamily: 'Roboto'),
                ),
              ),
            ).animate().slideX(delay: 900.ms, duration: 800.ms).saturate(),

          ],
        ),
      ),
    );
  }
}
