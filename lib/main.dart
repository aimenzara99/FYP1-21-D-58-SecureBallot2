// @dart=2.9

import 'package:e_voting_frontend/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Screens/wrapper.dart';
import 'models/user.dart';


void main() {
  runApp(MyApp());

}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {  
    return StreamProvider<User>.value(
      value: AuthService().loginUser,
      child: MaterialApp(
        home: Wrapper(),
      ),
    );
  }
}
