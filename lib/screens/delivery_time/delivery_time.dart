import 'package:flutter/material.dart';
class DeliverytimeScreen extends StatelessWidget {
  static const String  routeName = '/deliverytime';
  static Route route(){
    return MaterialPageRoute(builder:(_) => DeliverytimeScreen(), settings: RouteSettings(name: routeName));
  }
  const DeliverytimeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
