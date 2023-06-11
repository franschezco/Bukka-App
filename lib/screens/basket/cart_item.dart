import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bukka/screens/basket/%20CartItem.dart';

class CartItems extends StatefulWidget {
  final List<CartItem> cartItems;
  final VoidCallback updateTotal;
  const CartItems({Key? key, required this.cartItems,required this.updateTotal}) : super(key: key);

  @override
  State<CartItems> createState() => _CartItemsState();
}

class _CartItemsState extends State<CartItems> {
  void deleteItem(CartItem item) {
    setState(() {
      widget.cartItems.remove(item);
    });
  }
  void updateTotal() {
    setState(() {
      total = widget.cartItems.fold(0.0, (sum, item) => sum + (item.quantity * item.price));
      print(total);
    });
  }
  @override
  Widget build(BuildContext context) {
    if (widget.cartItems.isEmpty) {
      return  const Center(
          child: Text(
            'Your Cart is Empty',
            style: TextStyle(fontSize: 18),
          ),
        );
    }


    return  Column(children: [
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

    ],);
  }
}
