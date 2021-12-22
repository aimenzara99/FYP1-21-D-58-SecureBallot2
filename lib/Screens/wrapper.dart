import 'package:e_voting_frontend/Screens/authenticate/authenticate.dart';
import 'package:e_voting_frontend/Screens/home/home.dart';
import 'package:e_voting_frontend/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    // print("123 in wrapper");
    // final user = Provider.of<User>(context);
    // print(user);
    // print("start");
    // //return either home aur authenticate
    // if (user == null){
       return Authenticate();
    // }
    // else{
    //   return Home();
    // }
  }
}
