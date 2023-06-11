import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../basket/basket_screen.dart';
import '../track/track_screen.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SelectableTabs(),
      ),
    );
  }
}

class SelectableTabs extends StatefulWidget {
  const SelectableTabs({Key? key}) : super(key: key);

  @override
  _SelectableTabsState createState() => _SelectableTabsState();
}

class _SelectableTabsState extends State<SelectableTabs>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = ['Ongoing Orders', 'Completed Orders'];
  late List<QueryDocumentSnapshot<Map<String, dynamic>>> userOrders = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _tabs.length,
      vsync: this,
    );
    fetchUserOrders();
  }

  Future<void> fetchUserOrders() async {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid;
    final ordersRef = FirebaseFirestore.instance.collection('orders');
    final userOrdersQuery = ordersRef.where('userId', isEqualTo: userId);
    final userOrdersSnapshot = await userOrdersQuery.get();

    setState(() {
      userOrders = userOrdersSnapshot.docs;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        leading: Icon(null),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => BasketScreen(),
                transition: Transition.leftToRightWithFade,
              );
            },
            icon: Icon(
              Icons.shopping_cart,
              color: Colors.grey[800],
            ),
          )
        ],
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: _tabs
                .map(
                  (tab) => Tab(text: tab),
            )
                .toList(),
            indicatorColor: Colors.black,
            labelColor: Colors.black,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Ongoing Orders
                Container(
                  color: Colors.yellow.withOpacity(0.1),
                  child: ListView.builder(
                    itemCount: userOrders.length,
                    itemBuilder: (context, index) {
                      if (userOrders[index]['status'] == 'ongoing') {
                        final userId = userOrders[index]['userId'];
                        return InkWell(
                          onTap: () {
                            Get.to(() => TrackingScreen(orderId: userOrders[index].id));
                          },
                          child: Container(
                            height: 110,
                            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                  Row(
                                  children: [
                                  Text(
                                  'Order ID',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.yellow,
                                    ),
                                  ),
                                  SizedBox(width: 10),



                                    Text(
                                      userOrders[index].id.toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                  ),
                                      Row(
                                        children: [
                                          Text(
                                            'STATUS',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            userOrders[index]['status'].toUpperCase(),
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Spacer(),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                      onTap: () {
                                Get.to(() => TrackingScreen(orderId: userOrders[index].id));
                                },
                                        child: Icon(
                                          Icons.fastfood_outlined,
                                          color: Colors.green,
                                        ),
                                      ),
                                      Text('Track Order'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    },
                  ),
                ),

                // Completed Orders
                Container(
                    color: Colors.green.withOpacity(0.2),
                    child: ListView.builder(
                      itemCount: userOrders.length,
                      itemBuilder: (context, index) {
                        if (userOrders[index]['status'] == 'completed') {
                          final userId = userOrders[index]['userId'];
                          return InkWell(
                            onTap: () {
                              Get.to(() => TrackingScreen(orderId: userOrders[index].id));
                            },
                            child: Container(
                              height: 110,
                              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              'Order ID',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.yellow,
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              userOrders[index].id.toUpperCase(),
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'STATUS',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              userOrders[index]['status'].toUpperCase(),
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Spacer(),
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            // Handle track order tap
                                          },
                                          child: Icon(
                                            Icons.security_update_good,
                                            color: Colors.green,
                                          ),
                                        ),
                                        Text('Track Order'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return SizedBox.shrink(); // Default return statement
                      }
                    },
                  )
                )
                  ],
            ),
          ),
        ],
      ),
    );
  }
}