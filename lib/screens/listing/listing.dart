import 'package:flutter/material.dart';

class ListingScreen extends StatelessWidget {
  static const String  routeName = '/listing';
  static Route route(){
    return MaterialPageRoute(builder:(_) => ListingScreen(), settings: RouteSettings(name: routeName));
  }
  const ListingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
