import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:omni_manager/constants/style.dart';
import 'package:omni_manager/api/firebase.dart';
import 'package:omni_manager/pages/dashboard/widgets/bar_chart.dart';
import 'package:omni_manager/pages/dashboard/widgets/custom_text_content.dart';
import 'package:omni_manager/pages/dashboard/widgets/pie_chart.dart';

class BarChartDash extends StatefulWidget {
  bool isManager;

  BarChartDash({required this.isManager});

  @override
  _StatefulWrapperState createState() =>
      _StatefulWrapperState(isManager: isManager);
}

class _StatefulWrapperState extends State<BarChartDash> {
  bool loaded = false;

  final Future<QuerySnapshot> _employees = Database.listEmployees();

  bool isManager;

  _StatefulWrapperState({required this.isManager});

  Map<String, double>? _empDataCompl;
  Map<String, double>? _empDataWL;

  void _getEmployeeData() async {
    Map<String, double> empDataCompl = {};
    Map<String, double> empDataWL = {};
    await _employees.then((query) async {
      if (query.size != 0) {
        for (var emp in query.docs) {
          var empDoc = Database.getEmployeeData(emp);
          var empID = await empDoc.then((value) => value.id);
          var empName = await empDoc.then((value) {
            var data = value.data() as Map<String, dynamic>;
            return data["name"];
          });
          var empForms = Database.getEmployeeForms(empID, isManager);
          await empForms.then((snapshot) {
            if (snapshot.size != 0) {
              List<double> completions = [];
              List<double> workLoads = [];
              snapshot.docs.forEach((form) {
                var data = form.data() as Map<String, dynamic>;
                var compl = data["work_completion"] as double;
                var wl = data['work_load'] as double;
                completions.add(compl);
                workLoads.add(wl);
              });
              var workLoad =
                  workLoads.reduce((value, element) => value + element);
              var meanCompl =
                  completions.reduce((value, element) => value + element) /
                      workLoad;
              empDataCompl.putIfAbsent(empName, () => meanCompl);
              empDataWL.putIfAbsent(empName, () => workLoad);
            }
          });
        }
      }
    });
    setState(() {
      _empDataCompl = empDataCompl;
      _empDataWL = empDataWL;
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
      width: MediaQuery.of(context).size.width * 0.3,
      padding: EdgeInsets.all(24),
      margin: EdgeInsets.symmetric(vertical: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
              offset: Offset(0, 6),
              color: lightGrey.withOpacity(.1),
              blurRadius: 12)
        ],
        border: Border.all(color: lightGrey, width: .5),
      ),
      child: Column(
        children: [
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomTextContent(
                  text: "Taxa de finalização de tarefas",
                  size: 20,
                  weight: FontWeight.bold,
                  color: dark,
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                    width: 360,
                    height: 250,
                    child: loaded
                        ? new SimpleBarChart.withUnformattedData(_empDataCompl)
                        : Center(child: CircularProgressIndicator()))
              ],
            ),
          ),
          Container(width: 350, height: 50, color: Colors.white),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomTextContent(
                  text: "Carga de trabalho",
                  size: 20,
                  weight: FontWeight.bold,
                  color: dark,
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                    width: 400,
                    height: 250,
                    child: loaded
                        ? new PieOutsideLabelChart.withUnformattedData(
                            _empDataWL)
                        : Center(child: CircularProgressIndicator())),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
