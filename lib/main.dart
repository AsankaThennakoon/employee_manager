import 'package:flutter/material.dart';

import 'package:mytargets/tabs/HistoryPage.dart';
import 'package:mytargets/tabs/HomesPage.dart';
import 'package:firebase_core/firebase_core.dart';
import './pages/addEmployee/add_employee.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  //here override build function which return Widget type and get parameter as
  //BuildContext
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Employee Mangament',
        home: Root(),
        theme: ThemeData(primarySwatch: Colors.grey));
  }
}

class Root extends StatefulWidget {
  const Root({Key? key}) : super(key: key);

  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  int index = 0;

  List<Widget> tabs = [];
  late Widget page;
  bool pageAssigned = false;

  @override
  Widget build(BuildContext context) {
    tabs.add(HomesPage());

    tabs.add(HistoryPage());

    return Scaffold(
      appBar: AppBar(
        title: Text('Employee Management'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // ignore: unused_local_variable
          setState(() {
            page = AddEmploye();
            pageAssigned = true;
          });
        },
        child: Icon(Icons.add),
      ),

      // ignore: unnecessary_null_comparison
      body: pageAssigned ? page : tabs[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) {
          setState(() {
            index = i;
            pageAssigned = false;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "HOME"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "HISTORY")
        ],
      ),
    );
  }
}
