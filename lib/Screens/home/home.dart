import 'package:e_voting_frontend/Screens/home/castVote.dart';
import 'package:e_voting_frontend/services/auth.dart';
import 'package:flutter/material.dart';
import '../wrapper.dart';
import 'PcastVote.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  bool showSignIn = true;

  void toggleView(){
    setState(() => showSignIn = true);
  }

  signOut() async {
    await _auth.signOut();
  }

  void SignOut() => Navigator.pushReplacement(context,
      MaterialPageRoute(builder: (context) =>   Wrapper()));

  void castVote() => Navigator.pushReplacement(context,
      MaterialPageRoute(builder: (context) =>   CastVote()));

  void pcastVote() => Navigator.pushReplacement(context,
      MaterialPageRoute(builder: (context) =>   PcastVote()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue[100],
        appBar: AppBar(
          // title: Text('Secure Ballot'),

          backgroundColor: Colors.blue[400],
          elevation: 0.0,

            title: Row
              (
              mainAxisAlignment: MainAxisAlignment.start,
              children:
              [
                Container(padding: const EdgeInsets.all(8.0), child: Text('Secure Ballot')),

                Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Image.asset('assets/image/voteLogo.png',fit: BoxFit.contain,height: 32, ),
                    ]
                )
              ],
            ),

          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.person),
              label: Text('logout'),
              onPressed: () async{
                    print("12345664323");
                  _auth.signOut();
                 setState(() {
                   SignOut();
                 });
              },
            )
          ],
        ),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
          margin: EdgeInsets.symmetric(vertical: 100.0,horizontal: 100.0),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[

                Image.asset('assets/image/voteLogo.png',fit: BoxFit.contain, ),

                SizedBox(height: 50.0),
                RaisedButton(
                  color: Colors.blue[400],
                  child: Text(
                    'National Assembly Vote',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    setState(() {
                       castVote();
                    });
                  },
                ),

                SizedBox(height: 30.0),
                RaisedButton(
                  color: Colors.blue[400],
                  child: Text(

                    'Provisional Assembly Vote',
                    style: TextStyle(color: Colors.white,),
                  ),
                  onPressed: () async {
                    setState(() {
                      pcastVote();
                    });
                  },
                ),


              ],
            ),

          ),
        )
    );
  }
}
