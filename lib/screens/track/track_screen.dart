import 'package:bukka/animations/like.dart';
import 'package:flutter/material.dart';

import '../basket/cart_appbar.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class TrackingScreen extends StatelessWidget {
  final String orderId;

  TrackingScreen({required this.orderId});

  @override
  Widget build(BuildContext context) {
    // Sample list of steps in the tracking process
    List<String> trackingSteps = [      'Order Received',      'Preparing',      'Out for Delivery',      'Delivered',    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CartAppBar(heading: 'Track my Order'),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('orders')
                    .doc(orderId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    // Loading state
                    return Center(
                      child: CustomCircularProgressIndicator(),
                    );
                  }

                  final data = snapshot.data!.data() as Map<String, dynamic>;

                  if (data == null) {
                    // Data not found
                    return Center(
                      child: Text('No data found.'),
                    );
                  }

                  final status = data['status'];
                  bool isCompleted = status == 'completed';

                  Timestamp timestamp = data['timestamp']; // Assuming the timestamp field name is 'timestamp'
                  DateTime dateTime = timestamp.toDate();
                  String formattedDate = DateFormat('EEEE d MMMM yyyy').format(dateTime);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        formattedDate,
                        style: TextStyle(fontSize: 18, color: Colors.black,),
                      ),
                      Text(
                        'ORDER ID - ${orderId.toUpperCase()}',
                        style: TextStyle(fontSize: 20, color: Colors.black,fontWeight: FontWeight.bold),
                      ),
                    ],
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16, top: 16),
              child: Text(
                'Order',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 30),
            Expanded(
              child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('orders')
                    .doc(orderId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    // Loading state
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final data = snapshot.data!.data() as Map<String, dynamic>;

                  if (data == null) {
                    // Data not found
                    return Center(
                      child: Text('No data found.'),
                    );
                  }

                  final status = data['status'];
                  bool isCompleted = status == 'completed';

                  List<dynamic> items = data['items'];

                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: ListView.builder(
                      itemCount: trackingSteps.length,
                      itemBuilder: (context, index) {
                        Color stepColor;
                        if (isCompleted) {
                          stepColor = Colors.green; // Set all steps to green when status is completed
                        } else if (index < 2) {
                          stepColor = Colors.green; // Set first two steps to green when status is ongoing
                        } else {
                          stepColor = Colors.grey; // Set the rest of the steps to grey
                        }

                        return Container(
                          height: 70, // Set a fixed height for each list item
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.circle, size: 30, color: stepColor),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      trackingSteps[index],
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text('Additional information for ${trackingSteps[index]}'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Container(
                height: 130,
                decoration: BoxDecoration(
                  color: Colors.yellow.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('orders')
                      .doc(orderId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // Loading state
                      return Center(
                        child: CustomCircularProgressIndicator(),
                      );
                    }

                    if (!snapshot.hasData || !snapshot.data!.exists) {
                      // Data not found
                      return Center(
                        child: Text('No data found.'),
                      );
                    }

                    final data = snapshot.data!.data() as Map<String, dynamic>;
                    final items = data['items'] as List<dynamic>;

                    return ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text('Ordered ${item['quantity']} plate of ${item['name']} for ₦${item['price']}',style: TextStyle(
                                fontWeight: FontWeight.bold,color: Colors.black
                              ), )
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 50),

          ],
        ),
      ),
    );
  }
}
