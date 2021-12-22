import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'home.dart';

class PcastVote extends StatefulWidget {
  const PcastVote({Key? key}) : super(key: key);

  @override
  _PcastVoteState createState() => _PcastVoteState();
}

class _PcastVoteState extends State<PcastVote> {

  final _formKey = GlobalKey<FormState>();

  void home() => Navigator.pushReplacement(context,
      MaterialPageRoute(builder: (context) =>   Home()));

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
          onPressed: () {
            Navigator.pop(context);
            setState(() {
              document.data['vote'] = document.data['vote'] +1;
            });
            Firestore.instance.collection('ProvCandidates').document(
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
              flex: 3,
              child: Text(
                document.data['name'],
                style: Theme.of(context).textTheme.bodyText1,
              )

          ),

          Expanded(
              flex: 2,
              child: Text(
                document.data['party_name'].toString(),
                style: Theme.of(context).textTheme.bodyText1,
              )
          ),
          Expanded(
              flex: 2,
              child: Text(
                document.data['location'].toString(),
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
                    padding: EdgeInsets.fromLTRB(30, 40, 40, 40),
                    child: Text(
                      'Provisional Candidates!',
                      style: TextStyle(
                        fontSize: 25,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 6
                          ..color = Colors.blue[700]!,
                      ),
                    ),
                  ),
                  // Solid text as fill.
                  Padding(
                    padding: EdgeInsets.fromLTRB(30, 40, 40, 40),
                    child:
                    Text(
                      'Provisional Candidates!',
                      style: TextStyle(
                        fontSize: 25,
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
              stream: Firestore.instance.collection('ProvCandidates').snapshots(),

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
