import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final Stream<QuerySnapshot> _contributionStream =
      FirebaseFirestore.instance.collection("contribution").snapshots();
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Container(
      height: MediaQuery.of(context).size.height,
      child: StreamBuilder<QuerySnapshot>(
        stream: _contributionStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went worng");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              return Dismissible(
                  key: Key(document.id),
                  onDismissed: (direction) {
                    FirebaseFirestore.instance
                        .collection("targets")
                        .doc(document["target_id"])
                        .update({
                      'contribution_total':
                          FieldValue.increment(-1 * document['amount'])
                    });

                    FirebaseFirestore.instance
                        .collection('contribution')
                        .doc(document.id)
                        .delete();
                  },
                  child: ListTile(
                    title: Text(
                      document['note'],
                      textScaleFactor: 1.3,
                    ),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(document['amount'].toString()),
                        Text(document['date'].toDate().toString())
                      ],
                    ),
                  ),
                  background: Container(
                    color: Colors.red.shade200,
                    child: Row(
                      children: [
                        Text(
                          "Delete ! ",
                          style: TextStyle(color: Colors.white),
                          textScaleFactor: 1.4,
                        ),
                      ],
                    ),
                  ));
            }).toList(),
          );
        },
      ),
    ));
  }
}
