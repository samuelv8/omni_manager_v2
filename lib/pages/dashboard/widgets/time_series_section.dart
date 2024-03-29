import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:omni_manager/constants/style.dart';
import 'package:omni_manager/api/firebase.dart';
import 'package:omni_manager/pages/dashboard/widgets/bar_chart_time_series.dart';
import 'package:omni_manager/pages/dashboard/widgets/line_chart.dart';
import 'package:omni_manager/pages/dashboard/widgets/custom_text_content.dart';
import 'package:omni_manager/widgets/snackbar.dart';

class TimeSeriesDash extends StatefulWidget {
  final bool isManager;

  TimeSeriesDash({required this.isManager});

  @override
  _StatefulWrapperState createState() =>
      _StatefulWrapperState(isManager: isManager);
}

class _StatefulWrapperState extends State<TimeSeriesDash> {
  final startDate = TextEditingController();
  final endDate = TextEditingController();

  DateTime selectedDate = DateTime.now();

  Future<String> _selectDate(
      BuildContext context, TextEditingController date, bool isStart) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateFormat('dd/MM/yyyy').parse(date.text),
        firstDate: DateTime(1970),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      if (isStart) {
        Duration diff = DateFormat('dd/MM/yyyy').parse(endDate.text).difference(
            DateFormat('dd/MM/yyyy')
                .parse(DateFormat('dd/MM/yyyy').format(picked)));
        if (diff.inDays <= 0) {
          showSnackBar(
              text: "Error: time duration less than 0",
              context: context,
              backgroundColor: Colors.red);
          hideSnackBar(context: context);
        } else
          return DateFormat('dd/MM/yyyy').format(picked);
      } else {
        Duration diff = DateFormat('dd/MM/yyyy')
            .parse(DateFormat('dd/MM/yyyy').format(picked))
            .difference(DateFormat('dd/MM/yyyy').parse(startDate.text));
        if (diff.inDays <= 0) {
          showSnackBar(
              text: "Error: time duration less than 0",
              context: context,
              backgroundColor: Colors.red);
          hideSnackBar(context: context);
        } else
          return DateFormat('dd/MM/yyyy').format(picked);
      }
    }

    return date.text;
  }

  bool loaded = false;

  final Future<QuerySnapshot> _employees = Database.listEmployees();

  bool isManager;
  // String empName;

  _StatefulWrapperState({required this.isManager});

  Map<String, Map<DateTime, double>>? _empDataFrameCompletionPct;
  Map<String, Map<DateTime, double>>? _empDataFrameAttributed;
  Map<String, Map<DateTime, double>>? _empDataFrameSum;
  //Map<String, double>? _empDataCompl;
  List<String>? _empNames;
  String? _selectedEmp1, _selectedEmp2;
  DateTime _start = DateTime.now().add(const Duration(days: -30));
  DateTime _end = DateTime.now();

  void _getEmployeeData(DateTime start, DateTime end) async {
    Map<String, Map<DateTime, double>> empDataFrameCompletionPct = {'': {}};
    Map<String, Map<DateTime, double>> empDataFrameAttributed = {'': {}};
    Map<String, Map<DateTime, double>> empDataFrameSum = {'AVG': {}};
    List<String> empNames = [];
    await _employees.then((query) async {
      if (query.size != 0) {
        for (var emp in query.docs) {
          var empDoc = Database.getEmployeeData(emp);
          var empID = await empDoc.then((value) => value.id);
          var empName = await empDoc.then((value) {
            var data = value.data() as Map<String, dynamic>;
            return data["name"] as String;
          });
          empNames.add(empName);
          var empForms = Database.getEmployeeFormsFromInitToEnd(
              empID, isManager, start, end);
          await empForms.then((snapshot) {
            if (snapshot.size != 0) {
              Map<DateTime, double> empTimeSeriesCompl = {};
              Map<DateTime, double> empTimeSeriesAttr = {};
              snapshot.docs.forEach((form) {
                var data = form.data() as Map<String, dynamic>;
                var compl = data["work_completion"] as num;
                var wl = data['work_load'] as double;
                var dateTmstp = data['submission_date'] as Timestamp?;
                var date = dateTmstp?.toDate();
                if (date != null) {
                  empTimeSeriesCompl.putIfAbsent(date, () => compl / wl);
                  empTimeSeriesAttr.putIfAbsent(date, () => wl);
                }
              });

              empDataFrameCompletionPct.putIfAbsent(
                  empName, () => empTimeSeriesCompl);
              empDataFrameAttributed.putIfAbsent(
                  empName, () => empTimeSeriesAttr);
              empTimeSeriesCompl.forEach((date, rate) { 
                  if(empDataFrameSum['AVG']!.containsKey(date)){
                    empDataFrameSum['AVG']![date] = empDataFrameSum['AVG']![date]! + rate;
                  } else{
                    empDataFrameSum['AVG']![date] = empTimeSeriesCompl[date]!;
                  }
              });
              empDataFrameSum.putIfAbsent(empName, () => empTimeSeriesCompl);
              empDataFrameSum['AVG']!.forEach((date, rate) { empDataFrameSum['AVG']![date] = empDataFrameSum['AVG']![date]!/empNames.length;});
            }
          });
        }
      }
    });
    setState(() {
      _empDataFrameCompletionPct = empDataFrameCompletionPct;
      _empDataFrameAttributed = empDataFrameAttributed;
      _empNames = empNames;
      _empDataFrameSum = empDataFrameSum;
      _selectedEmp1 = empNames[0];
      _selectedEmp2 = empNames[0];
      loaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _getEmployeeData(_start, _end);
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                    child: Text("Employee 1", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                Container(),
                Container(
                  child: Text("Employee 2", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                )
              ],
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                    child: loaded
                        ? Center(
                            child: DropdownButton<String>(
                            value: _selectedEmp1,
                            icon: const Icon(Icons.arrow_downward),
                            items: _empNames
                                ?.map<DropdownMenuItem<String>>((String e) {
                              return DropdownMenuItem(value: e, child: Text(e));
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedEmp1 = newValue!;
                              });
                            },
                            dropdownColor: Colors.yellow,
                            iconEnabledColor: Colors.black,
                            iconDisabledColor: Colors.black,
                            style: TextStyle(color: Colors.black),
                          ))
                        : Center(child: CircularProgressIndicator())),
                Container(),
                Container(
                  child: loaded
                      ? Center(
                          child: DropdownButton<String>(
                          value: _selectedEmp2,
                          icon: const Icon(Icons.arrow_downward),
                          items: _empNames
                              ?.map<DropdownMenuItem<String>>((String e) {
                            return DropdownMenuItem(value: e, child: Text(e));
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedEmp2 = newValue!;
                            });
                          },
                          dropdownColor: Colors.yellow,
                          iconEnabledColor: Colors.black,
                          iconDisabledColor: Colors.black,
                          style: TextStyle(color: Colors.black),
                        ))
                      : Center(child: CircularProgressIndicator()),
                )
              ],
            ),
          ),
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
                    height: 150,
                    child: loaded
                        ? new TimeSeriesLineChart.withUnformattedDataFrame(
                            _empDataFrameCompletionPct,
                            [_selectedEmp1!, _selectedEmp2!], _empNames, _empDataFrameSum)
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
                    height: 150,
                    child: loaded
                        ? new TimeSeriesBarChart.withUnformattedDataFrame(
                            _empDataFrameAttributed,
                            [_selectedEmp1!, _selectedEmp2!])
                        : Center(child: CircularProgressIndicator())),
              ],
            ),
          ),
          Row(
            children: [
              Flexible(
                child: TextFormField(
                  controller: startDate
                    ..text = DateFormat('dd/MM/yyyy').format(_start).toString(),
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
                      icon: Icon(
                        Icons.calendar_today,
                        color: dark,
                      )),
                  validator: (value) {
                    if (value != null && value.isEmpty)
                      return "Please enter a date for your task";
                    return null;
                  },
                ), // <-- Wrapped in Expanded.
              ),
              Flexible(
                child: TextFormField(
                  controller: endDate
                    ..text = DateFormat('dd/MM/yyyy').format(_end).toString(),
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
                      icon: Icon(
                        Icons.calendar_today,
                        color: dark,
                      )),
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
                    startDate.text =
                        await _selectDate(context, startDate, isStart);
                    setState(() {
                      _start = DateFormat('dd/MM/yyyy').parse(startDate.text);
                    });
                    
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
                    setState(() {
                      _end = DateFormat('dd/MM/yyyy').parse(endDate.text);
                    });
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
              _getEmployeeData(_start, _end);
            },
            child: Text('Filter'),
          ),
        ],
      ),
    );
  }
}
