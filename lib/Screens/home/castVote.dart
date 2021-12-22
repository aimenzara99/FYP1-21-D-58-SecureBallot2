import 'package:flutter/material.dart';
 import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:web3dart/contracts.dart';
import 'package:web3dart/credentials.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web3dart/web3dart.dart' as Transact;
import 'home.dart';

class CastVote extends StatefulWidget {
  const CastVote({Key? key}) : super(key: key);

  @override
  _CastVoteState createState() => _CastVoteState();
}

class _CastVoteState extends State<CastVote> {
  //////////////////declaration of variables////////////////////////////
  final _formKey = GlobalKey<FormState>();
  late Web3Client client;
  String rcpurl = "http://192.168.100.6:7545";
  String wsurl = "ws://192.168.100.6:7545/";


  //////////////function for navigation//////////////////////////////
  void home() => Navigator.pushReplacement(context,
      MaterialPageRoute(builder: (context) =>   Home()));

  /////////////////Connection with blockchain//////////////////////////////////

  Future<DeployedContract> loadContract() async{
    String abi = await rootBundle.loadString("assets/abi.json");
    String contractAddress = "0xCb479e126efa9A5BCfDC45d49BbFeD2240e87509";
    // print(abi);
    final contract = DeployedContract(ContractAbi.fromJson(abi, "ElectionTimer"), EthereumAddress.fromHex(contractAddress));
    print("contract");
    print(contract);
    return contract;
  }

  Future<void> getBalance() async{
    String privatekey = "f890b716706cc0b9bb4bae81ea9103ec5bf6a1b4feb1805104008565f4039a6f";
    Credentials credentials = await client.credentialsFromPrivateKey(privatekey);
    final _contract =  await loadContract();
    final ethFunction = _contract.function("CastVote");

    client.sendTransaction(credentials,
        Transact.Transaction
            .callContract(contract: _contract,
            function: ethFunction, parameters: []));
    print("Vote Casted");
  }

  Future<void> Connection() async {
    client = new Web3Client(rcpurl, Client()
        , socketConnector: (){
          return IOWebSocketChannel.connect(wsurl).cast<String>();
        });
    getBalance();

    await client.dispose();
  }

  ////////////////////////////////////////////////////////////////////////////
  _onVote(context,  DocumentSnapshot document){
    Alert(
      context: context,
      type: AlertType.success,
      title: "ALERT",
      desc: "Are you sure to cast this vote?",
      content: Column(
        children: <Widget>[
          Text(document.data['name']),
          Text(document.data['party_name']),
        ],
      ),
      buttons: [
        DialogButton(
          child: Text(
            "Vote",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () async {
            Navigator.pop(context);
            await Connection();
            setState(() {
              document.data['vote'] = document.data['vote'] +1;
            });
            Firestore.instance.collection('NACandidates').document(
                document.documentID).updateData(document.data);
          },
          width: 120,
        )
      ],
    ).show();
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot document){
    return ListTile(
      title: Row(
        children: [
          Expanded(
              flex: 2,
              child: Text(
                document.data['name'],
                style: Theme.of(context).textTheme.bodyText1,
              )

          ),

          Expanded(
              flex: 3,
              child: Text(
                document.data['party_name'].toString(),
                style: Theme.of(context).textTheme.bodyText1,
              )
          ),

          Expanded(
            flex: 1,
            child: IconButton(
              icon: Icon(Icons.how_to_vote),
              onPressed: () {
                setState(() {
                   _onVote(context, document);
                });
              },
            ),
          ),
        ],
      ),
    );
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
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    home();
                  });
                },
              ),
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

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,

        children: [

          Row(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  // Stroked text as border.
                  Padding(
                    padding: EdgeInsets.fromLTRB(60, 40, 40, 40),
                    child: Text(
                      'NA Candidates!',
                      style: TextStyle(
                        fontSize: 30,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 6
                          ..color = Colors.blue[700]!,
                      ),
                    ),
                  ),
                  // Solid text as fill.
                  Padding(
                    padding: EdgeInsets.fromLTRB(60, 40, 40, 40),
                    child:
                  Text(
                    'NA Candidates!',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.grey[300],
                    ),
                  ),
                ),
                ],
              ),

            ],
          ),
        Expanded(
          child: StreamBuilder(
            stream: Firestore.instance.collection('NACandidates').snapshots(),

            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
              if (snapshot.hasData != null) {
                return ListView.builder(
                  itemExtent: 80.0,
                  itemCount: snapshot.data!.documents.length,
                  itemBuilder: (context, index) =>
                      _buildListItem(context, snapshot.data!.documents[index]),
                );
              }
              return const Text("Loading...");
            },
          ),
        ),
        ],

      ),
    );
  }
}
