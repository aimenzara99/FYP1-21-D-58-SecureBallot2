import 'package:e_voting_frontend/Screens/home/home.dart';
import 'package:e_voting_frontend/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class SignIn extends StatefulWidget {

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  //text field state
  String email = " ";
  String password = " ";
  String error = " ";

  void home() => Navigator.pushReplacement(context,
      MaterialPageRoute(builder: (context) =>   Home()));

  String rcpurl = "http://172.17.43.75:7545";
  String wsurl = "ws://172.17.43.75:7545/";

  Future<void> Connection() async {

    Web3Client client = new Web3Client(rcpurl, Client(), socketConnector: (){
      return IOWebSocketChannel.connect(wsurl).cast<String>();
    });


    String privateKey = "46fcfb30b0f2b74206ea8479cf78b61aebcea7217311dc1276207d0179d63be0";
  
    Credentials credentials = await client.credentialsFromPrivateKey(privateKey);

    EtherAmount balance = await client.getBalance(await credentials.extractAddress());
    print("Balance");
    print(balance.getValueInUnit(EtherUnit.ether));

    EthereumAddress ownAddress =await credentials.extractAddress();
    EthereumAddress receiver = EthereumAddress.fromHex("0xDE5F2Dca968a9807DB033699E0e84CB76807968a");
    // ignore: avoid_print
    print("Own Address");
    print(ownAddress);

    client.sendTransaction(
      credentials,
      Transaction(
        to: receiver,
        gasPrice: EtherAmount.inWei(BigInt.one),
        maxGas: 100000,
        value: EtherAmount.fromUnitAndValue(EtherUnit.ether, 20),
      ),
    );

  await client.dispose();

    // await client.sendTransaction(credentials, Transaction(from: ownAddress, to: receiver, value: EtherAmount.fromUnitAndValue(EtherUnit.ether, 20)));

  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
        appBar: AppBar
          (
            backgroundColor: Colors.blue[400],
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
            )

        ),

      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        margin: EdgeInsets.symmetric(vertical: 100.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              
              Stack(
                children: <Widget>[
                  // Stroked text as border.
                  Text(
                    'Welcome back!',
                    style: TextStyle(
                      fontSize: 38,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 6
                        ..color = Colors.blue[700]!,
                    ),
                  ),
                  // Solid text as fill.
                  Text(
                    'Welcome back!',
                    style: TextStyle(
                      fontSize: 38,
                      color: Colors.grey[300],
                    ),
                  ),
                ],
              ),

              Text('Please login to your account',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.blue[500])),

        
              SizedBox(height: 20.0),
              TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Email address',
                  ),
                  validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                  onChanged: (val){
                  setState(() => email = val);
                }
              ),

              SizedBox(height: 20.0),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
                validator: (val) => val!.length < 6 ? 'Enter an password 6+ chars long' : null,
                onChanged: (val){
                  setState(() => password = val);
                },
              ),

              SizedBox(height: 20.0),
              RaisedButton(
                color: Colors.blue[400],
                child: Text(
                  'Sign in',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: ()async{
                  setState(() {
                    Connection();                    
                  });

                  if (_formKey.currentState!.validate()){

                    dynamic result =await _auth.signInWithEmailAndPassword(email, password);
                    if (result == null){
                      setState(() => error = 'could not sign in with those credentials');
                    }
                    else{
                      setState(() {
                          home();
                      });
                    }
                  }
                },
              ),
              SizedBox(height:12.0),
              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 14.0),
              )
            ],
          ),
        ),
      )
    );
  }
}
