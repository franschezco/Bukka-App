import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
class ProfileList extends StatelessWidget {
final icons;
final links;
  const ProfileList({Key? key,required this.icons,required this.links}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: (){},
      leading: Container(
        width: 30,height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.yellow.withOpacity(0.1),
        ),
        child:  Icon(icons ,color: Colors.black,),
      ),
      title: Text(links),
      trailing: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.grey.withOpacity(0.1),
          ),
          child: Icon(LineAwesomeIcons.angle_right,color: Colors.grey,size: 15,)),
    );
  }
}
