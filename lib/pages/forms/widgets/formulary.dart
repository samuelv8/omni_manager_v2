import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:omni_manager/api/firebase.dart';
import 'package:omni_manager/widgets/snackbar.dart';
import 'dart:convert';

class Formulary extends StatefulWidget {
  const Formulary({Key? key, required this.isManager, this.uid})
      : super(key: key);
  final bool isManager;
  final String? uid;

  @override
  _FormularyState createState() => _FormularyState(isManager, uid);
}

class _FormularyState extends State<Formulary> {
  _FormularyState(this.isManager, this.uid);
  final bool isManager;
  final String? uid;

  bool haveForms = true;
  bool loaded = false;

  final formKey = GlobalKey<FormState>();

  String textQuestion1 =
      "Number of tasks assigned to the employee in the week:";
  String valueQuestion1 = '0';

  String textQuestion2 = "Number of tasks the employee has completed:";
  String valueQuestion2 = '0';

  String textQuestion3 = "What is the quality of delivery of tasks?";
  String valueQuestion3 = 'Regular';
  var optionsQuestion3 = ['Very bad', 'Bad', 'Regular', 'Good', 'Excellent'];

  String textQuestion4 = "How proactive was the employee?";
  String valueQuestion4 = 'Satisfatory';
  var optionsQuestion4 = ['Nothing', 'Little', 'Satisfatory', 'Very much'];

  String textQuestion5 =
      "In general, how big were the tasks the employee was assigned to?";
  String valueQuestion5 = 'Medium';
  var optionsQuestion5 = [
    'Very small',
    'Small',
    'Medium',
    'Large',
    'Very large'
  ];

  @override
  void initState() {
    super.initState();
    Database.getUnfilledForm(isManager: isManager, uid: uid).then((snapshot) {
      setState(() {
        haveForms = snapshot.docs.isNotEmpty;
        loaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!loaded) {
      return Center(child: CircularProgressIndicator());
    }
    if (haveForms) {
      return SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    textQuestion1,
                  ),
                  Container(
                    width: 320,
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter a number bigger than zero',
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          valueQuestion1 = newValue!;
                        });
                      },
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter(RegExp(r'[0-9]'),
                            allow: true)
                      ],
                      validator: (String? value) {
                        return (value != null &&
                                !value.contains(RegExp(r'[0-9]')))
                            ? 'Invalid input, please write a number'
                            : null;
                      },
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    textQuestion2,
                  ),
                  Container(
                    width: 320,
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter a number bigger than zero',
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          valueQuestion2 = newValue;
                        });
                      },
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter(RegExp(r'[0-9]'),
                            allow: true)
                      ],
                      validator: (String? value) {
                        return (value != null &&
                                !value.contains(RegExp(r'[0-9]')))
                            ? 'Invalid input, please write a number'
                            : null;
                      },
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    textQuestion3,
                  ),
                  Container(
                    width: 120,
                    child: DropdownButtonFormField<String>(
                      value: valueQuestion3,
                      icon: const Icon(Icons.arrow_downward),
                      iconSize: 24,
                      elevation: 16,
                      onChanged: (String? newValue) {
                        setState(() {
                          valueQuestion3 = newValue!;
                        });
                      },
                      items: optionsQuestion3
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    textQuestion4,
                  ),
                  Container(
                    width: 120,
                    child: DropdownButtonFormField<String>(
                      value: valueQuestion4,
                      icon: const Icon(Icons.arrow_downward),
                      iconSize: 24,
                      elevation: 16,
                      onChanged: (String? newValue) {
                        setState(() {
                          valueQuestion4 = newValue!;
                        });
                      },
                      items: optionsQuestion4
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    textQuestion5,
                  ),
                  Container(
                    width: 120,
                    child: DropdownButtonFormField<String>(
                      value: valueQuestion5,
                      icon: const Icon(Icons.arrow_downward),
                      iconSize: 24,
                      elevation: 16,
                      onChanged: (String? newValue) {
                        setState(() {
                          valueQuestion5 = newValue!;
                        });
                      },
                      items: optionsQuestion5
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        int load = int.parse(valueQuestion1);
                        int completion = int.parse(valueQuestion2);
                        double quality =
                            optionsQuestion3.indexOf(valueQuestion3) /
                                (optionsQuestion3.length - 1);
                        double proactivity =
                            optionsQuestion4.indexOf(valueQuestion4) /
                                (optionsQuestion4.length - 1);
                        double taskSize =
                            optionsQuestion5.indexOf(valueQuestion5) /
                                (optionsQuestion5.length - 1);
                        await Database.fillForms(
                                isManager: isManager,
                                uid: uid,
                                load: load,
                                completion: completion,
                                quality: quality,
                                proactivity: proactivity,
                                taskSize: taskSize)
                            .then((value) {
                          setState(() {
                            haveForms = false;
                          });
                        }).catchError((err) {
                          setState(() {});
                        });
                      }
                    },
                    child: Text("Submit Answer"),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return Container(
        alignment: Alignment.center,
        child: Text("No pending forms!"),
      );
    }
  }
}
