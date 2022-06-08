import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:omni_manager/constants/style.dart';
import 'package:omni_manager/pages/dashboard/widgets/info_card.dart';
import 'package:omni_manager/api/firebase.dart';

class OverviewCardsLargeScreen extends StatefulWidget {
  @override
  _OverviewCardsState createState() => _OverviewCardsState();
}

class _OverviewCardsState extends State<OverviewCardsLargeScreen> {
  bool loaded = false;

  final Future<QuerySnapshot> _employees = Database.listEmployees();

  List<String>? _empNames;
  Map<String, double>? _qualityMan;
  Map<String, double>? _qualityEmp;
  Map<String, double>? _proactivityMan;
  Map<String, double>? _proactivityEmp;
  String? _selected;

  void _getEmployeeData() async {
    List<String> empNames = [];
    Map<String, double> qualityMan = {};
    Map<String, double> qualityEmp = {};
    Map<String, double> proactivityMan = {};
    Map<String, double> proactivityEmp = {};
    String selected = "";
    await _employees.then((query) async {
      if (query.size != 0) {
        for (var emp in query.docs) {
          var empDoc = Database.getEmployeeData(emp);
          var empID = await empDoc.then((value) => value.id);
          var empName = await empDoc.then((value) {
            var data = value.data() as Map<String, dynamic>;
            return data["name"];
          });
          empNames.add(empName);
          selected = empName;
          var empFormsManager = Database.getEmployeeForms(empID, true);
          var empFormsEmp = Database.getEmployeeForms(empID, false);
          await empFormsManager.then((snapshot) {
            if (snapshot.size != 0) {
              List<double> qualities = [];
              List<double> proactivities = [];
              snapshot.docs.forEach((form) {
                var data = form.data() as Map<String, dynamic>;
                var qual = data["work_quality"] as double;
                var proac = data['work_proactivity'] as double;
                qualities.add(qual);
                proactivities.add(proac);
              });
              var meanQuality =
                  qualities.reduce((value, element) => value + element) /
                      qualities.length;
              var meanProac =
                  proactivities.reduce((value, element) => value + element) /
                      proactivities.length;
              qualityMan.putIfAbsent(empName, () => meanQuality);
              proactivityMan.putIfAbsent(empName, () => meanProac);
            }
          });
          await empFormsEmp.then((snapshot) {
            if (snapshot.size != 0) {
              List<double> qualities = [];
              List<double> proactivities = [];
              snapshot.docs.forEach((form) {
                var data = form.data() as Map<String, dynamic>;
                var qual = data["work_quality"] as double;
                var proac = data['work_proactivity'] as double;
                qualities.add(qual);
                proactivities.add(proac);
              });
              var meanQuality =
                  qualities.reduce((value, element) => value + element) /
                      qualities.length;
              var meanProac =
                  proactivities.reduce((value, element) => value + element) /
                      proactivities.length;
              qualityEmp.putIfAbsent(empName, () => meanQuality);
              proactivityEmp.putIfAbsent(empName, () => meanProac);
            }
          });
        }
      }
    });
    setState(() {
      _empNames = empNames;
      _qualityMan = qualityMan;
      _qualityEmp = qualityEmp;
      _proactivityMan = proactivityMan;
      _proactivityEmp = proactivityEmp;
      _selected = selected;
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
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          width: 200,
          child: loaded
              ? Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(5.0),
                      child: DropdownButton<String>(
                        value: _selected,
                        icon: const Icon(Icons.arrow_downward),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selected = newValue!;
                          });
                        },
                        items: _empNames
                            ?.map<DropdownMenuItem<String>>((String e) {
                          return DropdownMenuItem(value: e, child: Text(e));
                        }).toList(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: InfoCard(
                          title: "Productivity",
                          subtitle: "Employee's answer",
                          value: ((_proactivityEmp?[_selected] ?? 0) * 100)
                                  .toStringAsFixed(1) +
                              "%",
                          topColor: dark,
                          onTap: () {}),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: InfoCard(
                          title: "Productivity",
                          subtitle: "Manager's evaluation",
                          value: ((_proactivityMan?[_selected] ?? 0) * 100)
                                  .toStringAsFixed(1) +
                              "%",
                          topColor: dark,
                          onTap: () {}),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: InfoCard(
                          title: "Quality",
                          subtitle: "Employee's answer",
                          value: ((_qualityEmp?[_selected] ?? 0) * 100)
                                  .toStringAsFixed(1) +
                              "%",
                          topColor: dark,
                          onTap: () {}),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: InfoCard(
                          title: "Quality",
                          subtitle: "Manager's evaluation",
                          value: ((_qualityMan?[_selected] ?? 0) * 100)
                                  .toStringAsFixed(1) +
                              "%",
                          topColor: dark,
                          onTap: () {}),
                    ),
                  ],
                )
              : Center(child: CircularProgressIndicator()),
        ));
  }
}
