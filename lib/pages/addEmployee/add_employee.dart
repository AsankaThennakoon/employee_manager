import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddEmploye extends StatefulWidget {
  const AddEmploye({Key? key}) : super(key: key);

  @override
  _AddEmployeState createState() => _AddEmployeState();
}

class _AddEmployeState extends State<AddEmploye> {
  TextEditingController nameEM = new TextEditingController();
  TextEditingController noEM = new TextEditingController();

  TextEditingController emailEM = new TextEditingController();
  TextEditingController mobileEM = new TextEditingController();
  DateTime? date;
  @override
  Widget build(BuildContext context) {
    return Container(
        child: SingleChildScrollView(
      child: Card(
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Add new Employee",
                textScaleFactor: 1.6,
              ),
              SizedBox(height: 20.0),
              Text("Employee Id"),
              TextFormField(
                controller: noEM,
              ),
              SizedBox(height: 20.0),
              Text("Employee Name"),
              TextFormField(
                keyboardType: TextInputType.name,
                controller: nameEM,
              ),
              SizedBox(height: 20.0),
              Text("Email Address"),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: emailEM,
              ),
              SizedBox(height: 20.0),
              Text("Mobile No"),
              TextFormField(
                keyboardType: TextInputType.phone,
                controller: mobileEM,
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(date == null ? 'select a date' : date.toString()),
                IconButton(
                    onPressed: () async {
                      date = await showDatePicker(
                          context: context,
                          initialDate: date ?? DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2500));
                    },
                    icon: Icon(Icons.calendar_view_month))
              ]),
              SizedBox(
                height: 20.0,
              ),
              ElevatedButton(
                  onPressed: () {
                    String name = nameEM.text;
                    String no = noEM.text;
                    String state = "perment";
                    FirebaseFirestore.instance.collection("employee").add({
                      "employeeName": name,
                      "employeeNo": int.parse(no),
                      "date": date,
                      "state": state,
                    });
                    nameEM.clear();
                    noEM.clear();
                    date = null;
                  },
                  child: Text("SAVE")),
            ],
          ),
        ),
      ),
    ));
  }
}
