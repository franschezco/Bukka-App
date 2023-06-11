import 'package:bukka/screens/home/HomeController.dart';
import 'package:bukka/screens/profile/profilelist.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import 'ProfileController.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String displayName = '';
  String email = '';

  @override
  void initState() {
    super.initState();
    getCurrentUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(child:
      Container(
    padding:const EdgeInsets.all(20),
        child:Center(
          child: Column(
            children: [
              Center(
                child: SizedBox(height: 120,width: 120,
    child: ClipRRect(
    borderRadius:BorderRadius.circular(100),
    child:const Image(image: AssetImage('assets/images/user.jpg'),)),),
              ),
              const SizedBox(height: 10,),
              Center(child: Text( '${displayName.isNotEmpty ? displayName : 'Guest'}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,),)),
              Center(child:  Text('${email.isNotEmpty ? email : 'Not available'}',style: TextStyle(fontWeight: FontWeight.normal,),)),

              SizedBox(height: 20,),
              SizedBox(
                width: 200,
                child:ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.yellow),

                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                  child: Text('Edit Profile', style: TextStyle(color: Colors.black)),
                ),

              ),
              SizedBox(height: 20,),
              Divider(),
              SizedBox(height: 20,),

              ProfileList(icons: LineAwesomeIcons.cog,links: 'Settings',),
              ProfileList(icons: LineAwesomeIcons.wallet ,links: 'Billing Details',),
              ProfileList(icons: LineAwesomeIcons.user_check,links: 'User Management',),
              Divider(),
              SizedBox(height: 10,),
              ProfileList(icons: LineAwesomeIcons.info,links: 'Information',),
        ListTile(
          onTap: (){
            FirebaseAuth.instance.signOut();
          },
          leading: Container(
            width: 30,height: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.yellow.withOpacity(0.1),
            ),
            child:  Icon(LineAwesomeIcons.alternate_sign_out ,color: Colors.black,),
          ),
          title: Text("Logout",style: TextStyle(color: Colors.red),),
          trailing: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.grey.withOpacity(0.1),
              ),
              child: Icon(LineAwesomeIcons.angle_right,color: Colors.grey,size: 15,)),
        )
          ],
      ),
        )
    )
    ));
  }
  void getCurrentUserData() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        displayName = user.displayName ?? '';
        email = user.email ?? '';
      });
    }
  }
}
