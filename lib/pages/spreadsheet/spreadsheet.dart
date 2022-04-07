import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:omni_manager/pages/dashboard/widgets/custom_text_title.dart';
import 'package:omni_manager/pages/spreadsheet/spreadsheet_table.dart';
import 'package:omni_manager/api/firebase.dart';

class SpreadsheetPage extends StatefulWidget {
  const SpreadsheetPage({Key? key}) : super(key: key);
  @override
  _SpreadsheetState createState() => _SpreadsheetState();
}

class _SpreadsheetState extends State<SpreadsheetPage> {
  bool loaded = false;

  final Future<QuerySnapshot> _employees = Database.listEmployees();

  List<Map<String, dynamic>>? _empData;

  void _getEmployeeData() async {
    List<Map<String, dynamic>> employeesData = [];
    await _employees.then((query) async {
      if (query.size != 0) {
        for (var emp in query.docs) {
          var empDoc = Database.getEmployeeData(emp);
          var empID = await empDoc.then((value) => value.id);
          var empForms = Database.getAllEmployeeForms(empID);
          var empName = await empDoc.then((value) {
            var data = value.data() as Map<String, dynamic>;
            return data["name"];
          });
          await empForms.then((snapshot) {
            if (snapshot.size != 0) {
              List<double> completions = [];
              List<double> workLoads = [];
              List<double> qualities = [];
              List<double> proactivities = [];
              snapshot.docs.forEach((form) {
                var data = form.data() as Map<String, dynamic>;
                var compl = data["work_completion"] as double;
                var wl = data['work_load'] as double;
                var qual = data['work_quality'] as double;
                var proac = data['work_proactivity'] as double;
                completions.add(compl);
                workLoads.add(wl);
                qualities.add(qual);
                proactivities.add(proac);
              });
              var workLoad =
                  workLoads.reduce((value, element) => value + element);
              var meanWL = workLoad / workLoads.length;
              var meanCompl =
                  completions.reduce((value, element) => value + element) /
                      workLoad;
              var meanQual =
                  qualities.reduce((value, element) => value + element) /
                      qualities.length;
              var meanProac =
                  proactivities.reduce((value, element) => value + element) /
                      proactivities.length;
              var performance = (meanCompl + meanQual + meanProac) / 3;
              employeesData.add({
                'name': empName,
                'performance': (performance * 100).toStringAsFixed(2),
                'work_load': meanWL.toStringAsFixed(0),
                'work_completion': (meanCompl * 100).toStringAsFixed(2),
                'work_quality': (meanQual * 100).toStringAsFixed(2),
                'work_proactivity': (meanProac * 100).toStringAsFixed(2)
              });
            }
          });
        }
      }
    });
    setState(() {
      _empData = employeesData;
      loaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _getEmployeeData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      alignment: Alignment.topLeft,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: CustomTextTitle(
                  text: "Spreadsheet",
                  size: 40,
                  weight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 30),
                child: Center(
                  child: loaded
                      ? DataTableWidget(listOfColumns: _empData ?? _sampleData)
                      : CircularProgressIndicator(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

const _sampleData = [
  {
    "name": "Foo",
    "performance": "50",
    "work_proactivity": "85",
    "work_load": "100",
    "work_completion": "80",
    "work_quality": "65",
  },
  {
    "name": "Bar",
    "performance": "75",
    "work_proactivity": "5",
    "work_load": "50",
    "work_completion": "100",
    "work_quality": "47",
  },
];
