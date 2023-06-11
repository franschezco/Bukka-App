import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../basket/ CartItem.dart';
import '../basket/basket_screen.dart';
class DetailScreen extends StatefulWidget {
  final String image;
  final double price;
  final String name;

  DetailScreen({required this.image, required this.price, required this.name});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int value = 1;
  void showSnackbar() {
    Get.snackbar(
      'Food added to cart',
      '',
      snackPosition: SnackPosition.TOP,
      duration: Duration(seconds: 2),
      backgroundColor: Colors.black,
      colorText: Colors.white70,
    );
  }

  void addToCart() {
    CartItem existingItem = cartItems.firstWhere(
          (item) => item.name == widget.name,
      orElse: () => CartItem(
        image: widget.image,
        name: widget.name,
        price: widget.price,
        quantity: 0,
      ),
    );

    setState(() {
      if (existingItem.quantity == 0) {
        cartItems.add(existingItem);
      }
      existingItem.quantity += value;
    });
    AudioPlayer().play(AssetSource('sound/like.mp3'));
    showSnackbar();

  }
  double totalPrice = 0.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * .6,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(widget.image),
                fit: BoxFit.cover
              )
            ),
          ),
          Positioned(
            left: 20,top: 30 + MediaQuery.of(context).padding.top,
            child: ClipOval(
              child: Container(
                height: 42,width: 41,
                decoration: BoxDecoration(color: Colors.white,
                    boxShadow:[
                      BoxShadow(
                        color: Colors.black.withOpacity(.25),
                        offset: Offset(0,4),
                        blurRadius: 8
                      )

                    ]),
                child:Center(

                  child: InkWell(
    onTap: (){Navigator.pop(context);},
                      child: Icon(Icons.arrow_back)),
                ) ,
              ),
            ),
          ),
          Positioned(
            right: 20,top: 30 + MediaQuery.of(context).padding.top,
            child: ClipOval(
              child: Container(
                height: 42,width: 41,
                decoration: BoxDecoration(color: Colors.white,
                    boxShadow:[
                      BoxShadow(
                          color: Colors.black.withOpacity(.25),
                          offset: Offset(0,4),
                          blurRadius: 8
                      )

                    ]),
                child:Center(
                  child: InkWell(
                    onTap: (){
                      Get.to(() => BasketScreen(),
                        transition:
                        Transition.leftToRightWithFade,
                      );
                    },
                      child: Icon(CupertinoIcons.shopping_cart,color: Colors.grey[800],)),
                ) ,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * .6,
              width: MediaQuery.of(context).size.width ,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),

                )),
              child: Padding(
                padding: const EdgeInsets.only(left: 30,right: 30,top: 20),
                child: Column(
                  crossAxisAlignment:CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text('${widget.name}',style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),),
                        ),
                        Icon(Icons.favorite_border,color: Colors.black,)
                      ],
                    ),
                   SizedBox(height: 10,),
                   Row(
                     children: [
                      Text ('₦${widget.price}',style: TextStyle(
                        fontSize: 20,fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold
                      ),),SizedBox(width: 10,),
                       Text('/ 1 plate',style :TextStyle(fontSize: 20,fontFamily: 'Roboto',))
                     ],
                   ),
                    SizedBox(height: 10,),
                    Container(
                      padding: EdgeInsets.all(3),
                      decoration:BoxDecoration(
                          color: Color.fromRGBO(63, 200, 101, 1),
                          borderRadius: BorderRadius.circular(5)
                      ) ,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text('Delivered in few minutes',style: TextStyle(color: Colors.white,fontSize: 14),),
                      ),
                    ),


                    Expanded(child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                         InkWell(
                           onTap: (){
                             setState(() {
                               // Subtract logic
                               if (value > 1) {
                                 value--;
                               }
                             });
                           },
                           child: Container(
                            height: 49,width:49,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(228,228, 228, 1),
                                  borderRadius:BorderRadius.circular(10)
                            ),child: Center(child: Text('-',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),
                        ),
                         ),
                        Container(
                          height: 49,width:100,
                          child: Center(child: Text(value.toString(),style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),
                        ),
                        InkWell(
                          onTap: (){
                            setState(() {
                              // Add logic
                              value++;
                            });
                          },
                          child: Container(
                            height: 49,width:49,
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(234,175 ,45,1),
                                borderRadius:BorderRadius.circular(10)
                            ),child: Center(child: Text('+',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),
                          ),
                        )
                      ],
                    )),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          Expanded(child: Column(
                            crossAxisAlignment:CrossAxisAlignment.start,
                            children: [
                              Text('Total',style: TextStyle(fontSize: 14,color: Colors.black,fontFamily: 'Roboto',),),
                              Text('₦${(value * widget.price).toStringAsFixed(2)}',style: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.bold,fontFamily: 'Roboto',),)
                            ],
                          )),

                          InkWell(
                              onTap: addToCart,
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                              decoration: BoxDecoration(color: Color.fromRGBO(234,175 ,45,1),
                              borderRadius: BorderRadius.circular(10),
                              ),

                              child:Text('Add to Cart',style: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.bold,fontFamily: 'Roboto',)),),
                          )
                        ],
                      ),
                    )

                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
