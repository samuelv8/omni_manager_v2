import 'package:flutter/material.dart';
import 'package:omni_manager/api/firebase.dart';

class Formulary extends StatefulWidget {
  const Formulary({Key? key, required this.isManager, this.employee})
      : super(key: key);
  final bool isManager;
  final String? employee;

  @override
  _FormularyState createState() => _FormularyState(isManager, employee);
}

class _FormularyState extends State<Formulary> {
  _FormularyState(this.isManager, this.employee);
  final bool isManager;
  final String? employee;

  bool haveForms = true;
  bool loaded = false;

  final formKey = GlobalKey<FormState>();

  String textQuestion1 =
      "Quantidade de tarefas atribuídas ao funcionário na semana:";
  String valueQuestion1 = '0';
  var optionsQuestion1 = ['0', '1', '2', '3', '4', '5'];

  String textQuestion2 = "Quantidade de tarefas que o funcionário completou:";
  String valueQuestion2 = '0';
  var optionsQuestion2 = ['0', '1', '2', '3', '4', '5'];

  String textQuestion3 = "Qual a qualidade da entrega das tarefas?";
  String valueQuestion3 = 'Regular';
  var optionsQuestion3 = ['Péssima', 'Ruim', 'Regular', 'Boa', 'Excelente'];

  String textQuestion4 = "O quanto o funcionário foi proativo?";
  String valueQuestion4 = 'Satisfatorio';
  var optionsQuestion4 = ['Nada', 'Pouco', 'Satisfatorio', 'Muito'];

  @override
  void initState() {
    super.initState();
    Database.getUnfilledForm(isManager: isManager, employee: employee).then((snapshot) {
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
                    width: 120,
                    child: DropdownButtonFormField<String>(
                      value: valueQuestion1,
                      icon: const Icon(Icons.arrow_downward),
                      iconSize: 24,
                      elevation: 16,
                      onChanged: (String? newValue) {
                        setState(() {
                          valueQuestion1 = newValue!;
                        });
                      },
                      items: optionsQuestion1
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
                    textQuestion2,
                  ),
                  Container(
                    width: 120,
                    child: DropdownButtonFormField<String>(
                      value: valueQuestion2,
                      icon: const Icon(Icons.arrow_downward),
                      iconSize: 24,
                      elevation: 16,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (int.parse(value ?? '') >
                            int.parse(valueQuestion2)) {
                          return "Valor incompatível";
                        }
                        return null;
                      },
                      onChanged: (String? newValue) {
                        setState(() {
                          valueQuestion2 = newValue!;
                        });
                      },
                      items: optionsQuestion2
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
                  ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        int load = optionsQuestion1.indexOf(valueQuestion1);
                        int completion = optionsQuestion2.indexOf(valueQuestion2);
                        double quality =
                            optionsQuestion3.indexOf(valueQuestion3) /
                                (optionsQuestion3.length - 1);
                        double proactivity =
                            optionsQuestion4.indexOf(valueQuestion4) /
                                (optionsQuestion4.length - 1);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Loading...')),
                        );
                        Database.fillForms(
                                isManager: isManager,
                                employee: employee,
                                load: load,
                                completion: completion,
                                quality: quality,
                                proactivity: proactivity)
                            .then((value) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Forms submitted successfully!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          setState(() {
                            haveForms = false;
                          });
                        }).catchError((err) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Failed to submit. Error: $err"),
                              backgroundColor: Colors.red,
                            ),
                          );
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
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
        child: Text("Não há formulários pendentes!"),
      );
    }
  }
}
