import 'package:e_voting_frontend/Screens/authenticate/sing_in.dart';
import 'package:flutter/material.dart';


class  Authenticate extends StatefulWidget {

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  @override
  Widget build(BuildContext context) {
        return SignIn();

  }
}
