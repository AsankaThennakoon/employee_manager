import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final Stream<QuerySnapshot> employeeStream =
      FirebaseFirestore.instance.collection("employee").snapshots();
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Container(
      height: MediaQuery.of(context).size.height,
      child: StreamBuilder<QuerySnapshot>(
        stream: employeeStream,
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
                        .collection('employee')
                        .doc(document.id)
                        .delete();
                  },
                  child: ListTile(
                    title: Text(
                      document['employeeName'],
                      textScaleFactor: 1.3,
                    ),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(document['employeeNo'].toString()),
                        Text(document['DateOfBirth'].toDate().toString())
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
