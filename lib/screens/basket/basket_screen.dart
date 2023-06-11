import 'package:bukka/screens/basket/%20CartItem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../animations/like.dart';
import '../checkout/checkout_screen.dart';
import 'cart_appbar.dart';

class BasketScreen extends StatefulWidget {
  BasketScreen({Key? key}) : super(key: key);

  @override
  State<BasketScreen> createState() => _BasketScreenState();
}

class _BasketScreenState extends State<BasketScreen> {
  bool isLoading = false;
  void deleteItem(CartItem item) {
    setState(() {
      cartItems.remove(item);
    });
  }
  void updateTotal() {
    setState(() {
      total = cartItems.fold(0.0, (sum, item) => sum + (item.quantity * item.price));
      print(total);
    });
  }
  void initState() {
    super.initState();
    updateTotal(); // call your function here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          CartAppBar(heading: 'My Cart'),
          Container(
            height: 700,
            padding: EdgeInsets.only(top: 15),
            decoration: BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(35),
                topRight: Radius.circular(35),
              ),
            ),
            child: Column(children: [
        for (CartItem item in cartItems)
    Container(
      height: 110,
      margin: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.yellow.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
      ),child: Row(

      children: [

        Container(
          margin: EdgeInsets.all(5),
          height: 70,
          width: 70,
          child: Image.asset(item.image),
        ),Padding(padding: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(item.name, style:TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.black)),
              Text('₦${(item.price)} / 1 plate' , style:TextStyle(fontSize: 10,fontWeight: FontWeight.normal,color: Colors.grey)),
              Text('₦${(item.quantity * item.price).toStringAsFixed(2)}', style:TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.black))

            ],
          ),),
        Spacer(),
        Padding(padding: EdgeInsets.symmetric(vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                  onTap: (){
                    deleteItem(item);
                    updateTotal();
                  } ,
                  child: Icon(Icons.delete_outline,color: Colors.red,)),
              Row(children: [
                InkWell(
                  onTap: (){
                    setState(() {
                      // Add logic
                      item.quantity++;
                      updateTotal();
                      print('i update');
                    });
                  },
                  child:  Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow:[
                            BoxShadow(
                              color: Colors.grey.withOpacity(.5),
                              spreadRadius: 1,
                              blurRadius: 10,
                            )
                          ]
                      ),
                      child:  Icon(CupertinoIcons.plus,size: 18,)),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal:10),
                  child: Text(item.quantity.toString(),style: TextStyle(fontSize: 16,fontFamily: 'Roboto',fontWeight: FontWeight.bold),),
                ),
                InkWell(
                  onTap: (){
                    setState(() {
                      // Subtract logic
                      if (item.quantity > 1) {
                        item.quantity--;
                        updateTotal();
                      }
                    });
                  },
                  child:
                  Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow:[
                            BoxShadow(
                              color: Colors.grey.withOpacity(.5),
                              spreadRadius: 1,
                              blurRadius: 10,
                            )
                          ]
                      ),
                      child: Icon(CupertinoIcons.minus,size: 18,)),
                )
              ],)
            ],
          ),)

      ],
    ),

    ),

    ],)
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Icon(Icons.add, color: Colors.white70),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'Add Coupon Code',
                    style: TextStyle(
                      color: Colors.yellow,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          height: 130,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(
                      color: Colors.yellow,
                      fontFamily: 'Roboto',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '₦${total.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Roboto',
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              if (total > 0) // Add this condition to hide the button when total is 0
                LoadingButton(
                  onPressed: () {
                    setState(() {
                      isLoading = true; // Start loading
                    });

                    // Simulate loading for 5 seconds
                    Future.delayed(Duration(seconds: 5), () {
                      setState(() {
                        isLoading = false; // Stop loading after 5 seconds
                      });

                      Get.to(
                            () => CheckoutScreen(),
                        transition: Transition.leftToRightWithFade,
                      );
                    });
                  },
                  buttonText: 'Proceed to Checkout',
                  isLoading: isLoading,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
