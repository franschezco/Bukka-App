import 'dart:async';

import 'package:bukka/screens/detail/details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../../animations/like.dart';
import '../../animations/models.dart';
import '../../animations/product_list.dart';
import '../basket/ CartItem.dart';
import '../basket/basket_screen.dart';

class HomeScreen extends StatefulWidget {
   HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;
  String? locationText = 'Getting your Location...';
  List<CartItem> cartItems = [];
  bool _isLoading = true; // Flag to track loading state
  late Timer _timer;


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categories.length, vsync: this);
    _tabController.addListener(_handleTabSelection);
    _getLocationDelayed();
    _timer = Timer(Duration(seconds: 15), () {
      setState(() {
        _isLoading = false; // Stop showing the loading indicator
      });
    });
  }

  void _handleTabSelection() {
    setState(() {
      _currentIndex = _tabController.index;
    });
  }

  Future<void> _getLocationDelayed() async {
    await Future.delayed(Duration.zero);
    _getLocation();
  }

  Future<void> _getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    print("Getting location...");

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are disabled
      setState(() {
        locationText = 'Location services are disabled';
      });
      return;
    }

    // Request location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      print("location allowed...");
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        // Location permission is denied
        setState(() {
          locationText = 'Location permission denied';
        });
        return;
      }
    }

    // Location permission is granted, get the current location
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
    );

    // Reverse geocoding
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    // Extract the address
    Placemark placemark = placemarks[0];
    String address =
        ' ${placemark.street}, ${placemark.subLocality}, ${placemark.locality}, ${placemark.administrativeArea} ';


    
    // Update the location text
    setState(() {
      locationText = address;
    });

    // Do something with the address
    print(address);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    List<Meal> hotMeals = categories
        .firstWhere((category) => category.name == 'Hot Meals')
        .meals;

    List<String> hotMealImages = hotMeals.map((meal) => meal.img).toList();
    List<String> hotMealNames = hotMeals.map((meal) => meal.name).toList();
    List<String> hotMealPrice = hotMeals.map((meal) => meal.price.toString()).toList();

    String? displayName = getCurrentUserName();
    return WillPopScope(
        onWillPop: () async {
      // Prevent going back
      return false;
    },child :DefaultTabController(
        length: categories.length,
        child: Scaffold(
      backgroundColor: Colors.grey[100],
    appBar: AppBar(
      backgroundColor: Colors.grey[100],
      elevation: 0,
      leading: Icon(null),
      actions: [
        IconButton(
          onPressed: () {
            Get.to(() => BasketScreen(),
              transition:
              Transition.leftToRightWithFade,
            );
          },
          icon: Icon(CupertinoIcons.shopping_cart,color: Colors.grey[800],),
        )
      ], systemOverlayStyle: SystemUiOverlayStyle.dark,
    ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Good Morning, $displayName',style: TextStyle(color: Colors.grey[800],fontWeight: FontWeight.w100,fontSize: 18),).animate()
                      .fadeIn(delay: 200.ms, duration: 300.ms),
                  SizedBox(height: 20,),
                  Container(
                    width: double.maxFinite,
                    height: 50,
                    child: TabBar(
isScrollable: true,indicator:BoxDecoration(),
                          controller: _tabController,
                          indicatorColor: Colors.yellow[700],
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.grey[500],
                          tabs: [
                            makeCategory(
                              isActive: _currentIndex == 0,
                              title: 'Hot Meals',
                              onTap: () {
                                _tabController.animateTo(0);
                              },
                            ),
                            makeCategory(
                              isActive: _currentIndex == 1,
                              title: 'Breakfast',
                              onTap: () {
                                _tabController.animateTo(1);
                              },
                            ),

                            makeCategory(
                              isActive: _currentIndex == 2,
                              title: 'Locals',
                              onTap: () {
                                _tabController.animateTo(2);
                              },
                            ),
                            makeCategory(
                              isActive: _currentIndex == 3,
                              title: 'Chops',
                              onTap: () {
                                _tabController.animateTo(3);
                              },
                            ),
                            makeCategory(
                              isActive: _currentIndex == 4,
                              title: 'Deserts',
                              onTap: () {
                                _tabController.animateTo(4);
                              },
                            ),
                          ]),
                        ),

                  SizedBox(height: 10,)
                ],

              ),
            ),
            Padding(padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 35,height: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.yellow.withOpacity(0.3),
                  ),
                  child:  const Icon(LineAwesomeIcons.alternate_map_marked ,color: Colors.black,),
                ),
                SizedBox(width: 10,),
              Text(
                locationText ?? '',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.normal,
                  fontSize: 18,
                ),
              ),
              ],
            ),),

            Expanded(child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child:   Visibility(
                visible: !_isLoading,
                child: Container(
                  width: double.maxFinite,
                  height: 360,
                  child: TabBarView(
                    physics: NeverScrollableScrollPhysics(), // Disable scrolling
                    controller: _tabController,
                    children: [
                      makeItem(images: hotMealImages,prices:hotMealPrice ,names: hotMealNames ,).animate().fadeIn(duration: 120.ms),
                      Center(child: Text('Second Food Page')),
                      Center(child: Text('Second Food Page')),
                      Center(child: Text('Hot Meals Content')),
                      Center(child: Text('Locals Content')),



                    ],
                  ),
                ),

                replacement: Center(
                  child: CustomCircularProgressIndicator(),
                ))
            )),
              SizedBox(height: 30,)
          ],
        ),
      ),
    )));
  }

  String? getCurrentUserName() {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.displayName;
  }
}

Widget makeCategory({
  required bool isActive,
  required String title,
  required VoidCallback onTap,
}) {
  return  GestureDetector(
      onTap: onTap,
      child: Container(

      margin: const EdgeInsets.only(right: 10),
  decoration: BoxDecoration(
  color: isActive ? Colors.yellow[700] : Colors.white,
  borderRadius: BorderRadius.circular(20),
  ),child: Padding(
    padding: const EdgeInsets.only(left: 12.0,right: 12),
    child: Align(
          alignment: Alignment.center,
          child: Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.grey[500],
            fontSize: 18,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w100,
          ),
        ),
        ),
  ),
  ),
  );
}

Widget makeItem({required List<String> images,required List<String> prices,required List<String> names}) {
  return   ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        itemBuilder: (context, index) {
          String image = images[index];
          double price = double.parse(prices[index]);
          String name = names[index];
          return GestureDetector(
              onTap: (){
            Get.to(() =>  DetailScreen(
              image: image,
              price: price,
              name: name,
            ),
                transition:
                Transition.leftToRightWithFade,
                );
          }, child :Container(
            width: 340,
            margin: EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: AssetImage(image),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  stops: [.2, .9],
                  colors: [
                    Colors.black.withOpacity(.9),
                    Colors.black.withOpacity(.3),
                  ],
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: LikeButtonAnimation(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                             '₦$price',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              name,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),

                      ],
                    ),
                  ],
                ),
              ),
            ),
  ));});
}









