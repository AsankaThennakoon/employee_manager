import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class HomesPage extends StatefulWidget {
  const HomesPage({Key? key}) : super(key: key);

  @override
  _HomesPageState createState() => _HomesPageState();
}

class _HomesPageState extends State<HomesPage> {
  final Stream<QuerySnapshot> _employeeStream =
      FirebaseFirestore.instance.collection('employee').snapshots();

  TextEditingController txtAmount = TextEditingController();
  TextEditingController txtNote = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
            stream: _employeeStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text("Something went wrong");
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
              return new ExpansionPanelList(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  dynamic doc = document.data();
                  return ExpansionPanel(
                      headerBuilder: (BuildContext context, bool isExpanded) {
                        return Container();
                      },
                      body: Container(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    CircleAvatar(
                                      radius: 30,
                                      child: Padding(
                                        padding: EdgeInsets.all(6),
                                        child: FittedBox(),
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          child: Text(
                                            "Employee NO : " +
                                                doc["employeeNo"],
                                          ),
                                        ),
                                        Container(
                                          child: Text(
                                            "Employee Name : " +
                                                doc["employeeName"],
                                          ),
                                        ),
                                        Container(
                                          child: Text("DATE of Birth : " +
                                              doc["DateOfBirth"]
                                                  .toDate()
                                                  .toString()
                                                  .split(" ")[0]),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: Text(
                                        'permanen',
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                            splashColor: Colors.blueGrey,
                                            highlightColor: Colors.green,
                                            color: Colors.green,
                                            icon: Icon(Icons.edit),
                                            onPressed: () {}),
                                        IconButton(
                                          splashColor: Colors.blueGrey,
                                          highlightColor: Colors.green,
                                          color: Colors.green,
                                          icon: Icon(Icons.delete),
                                          onPressed: () {
                                            String tid = document.id;
                                            _showMyDialog(tid);
                                          },
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      isExpanded: true);
                }).toList(),
              );
            }));
  }

  Future<void> _showMyDialog(tid) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Warning'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you want to remove this employee'),
              ],
            ),
          ),
          actions: <Widget>[
            Column(
              children: [
                TextButton(
                  onPressed: () {},
                  child: const Text('NO'),
                ),
                TextButton(
                  child: const Text('SAVE'),
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection('employee')
                        .doc(tid)
                        .delete();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
