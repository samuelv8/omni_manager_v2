import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:omni_manager/api/auth.dart';
import 'package:omni_manager/constants/style.dart';
import 'package:omni_manager/api/firebase.dart';
import 'package:omni_manager/pages/dashboard/widgets/bar_chart.dart';
import 'package:omni_manager/pages/dashboard/widgets/custom_text_content.dart';
import 'package:omni_manager/pages/dashboard/widgets/pie_chart.dart';

class BarChartDash extends StatefulWidget {
  final bool isManager;

  BarChartDash({required this.isManager});

  @override
  _StatefulWrapperState createState() =>
      _StatefulWrapperState(isManager: isManager);
}

class _StatefulWrapperState extends State<BarChartDash> {

  final startDate = TextEditingController();
  final endDate = TextEditingController();

  DateTime selectedDate = DateTime.now();

  Future<String> _selectDate(BuildContext context, TextEditingController date, bool isStart) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateFormat('dd/MM/yyyy').parse(date.text),
        firstDate: DateTime(1970),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {

      if(isStart){
        Duration diff = DateFormat('dd/MM/yyyy').parse(endDate.text).difference(DateFormat('dd/MM/yyyy').parse(DateFormat('dd/MM/yyyy').format(picked)));
        if(diff.inDays <= 0){
          //MENSAGEM DE ERRO
        }
        else
            return DateFormat('dd/MM/yyyy').format(picked);
      }
      else{
        Duration diff = DateFormat('dd/MM/yyyy').parse(DateFormat('dd/MM/yyyy').format(picked)).difference(DateFormat('dd/MM/yyyy').parse(startDate.text));
        if(diff.inDays <= 0){
          //MENSAGEM DE ERRO
        }
        else
            return DateFormat('dd/MM/yyyy').format(picked);
      }
    }

    return date.text;
  }



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
                  text: "Finished Tasks Rate",
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
                  text: "Workload",
                  size: 20,
                  weight: FontWeight.bold,
                  color: dark,
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                    width: 400,
                    height: 50, //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! CORRIGIR: era 250 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                    child: loaded
                        ? new PieOutsideLabelChart.withUnformattedData(
                            _empDataWL)
                        : Center(child: CircularProgressIndicator())),
              ],
            ),
          ),
          Row(
            children: [
              Flexible(
                child: TextFormField(
                  controller: startDate..text = DateFormat('dd/MM/yyyy').format(DateTime.now().add(const Duration(minutes: -60*24*30))).toString(),
                  enabled: false,
                  style: TextStyle(color: dark),
                  keyboardType: TextInputType.datetime,
                  decoration: InputDecoration(
                    labelText: "Start Date",
                    labelStyle: TextStyle(
                        color: dark,
                    ),
                    enabledBorder: UnderlineInputBorder(      
                        borderSide: BorderSide(color: dark),   
                    ),  
                    icon: Icon(Icons.calendar_today, color: dark,)
                  ),
                  validator: (value) {
                    if (value != null && value.isEmpty)
                      return "Please enter a date for your task";
                    return null;
                  },
                ), // <-- Wrapped in Expanded.
              ),
              Flexible(
                child: TextFormField(
                  controller: endDate..text = DateFormat('dd/MM/yyyy').format(DateTime.now()).toString(),
                  enabled: false,
                  style: TextStyle(color: dark),
                  keyboardType: TextInputType.datetime,
                  decoration: InputDecoration(
                    labelText: "End Date",
                    labelStyle: TextStyle(
                        color: dark,
                    ),
                    enabledBorder: UnderlineInputBorder(      
                        borderSide: BorderSide(color: dark),   
                    ),  
                    icon: Icon(Icons.calendar_today, color: dark,)
                  ),
                  validator: (value) {
                    if (value != null && value.isEmpty)
                      return "Please enter a date for your task";
                    return null;
                  },
                ), // <-- Wrapped in Expanded.
              ),      
            ],
          ),
          Container(width: 350, height: 16, color: Colors.white),
          Row(
            children: [
              Flexible(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    onPressed: () async {
                      bool isStart = true;
                      startDate.text = await _selectDate(context, startDate, isStart);
                    },
                    child: Text('Select date'),
                  ),
                ) // <-- Wrapped in Expanded.
              ),
              Flexible(
                child: Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () async {
                      bool isStart = false;
                      endDate.text = await _selectDate(context, endDate, isStart);
                    },
                    child: Text('Select date'),
                  ),
                ) // <-- Wrapped in Expanded.
              ),      
            ],
          ),
          Container(width: 350, height: 16, color: Colors.white),
          ElevatedButton(
            onPressed: () {
              DateTime start = DateFormat('dd/MM/yyyy').parse(startDate.text);
              DateTime end = DateFormat('dd/MM/yyyy').parse(endDate.text);
              Future<QuerySnapshot> data = Database.getEmployeeFormsFromInitToEnd(getUserUid(), isManager, start, end);
            },
            child: Text('Filter'),
          ),
        ],
      ),
    );
  }
}
