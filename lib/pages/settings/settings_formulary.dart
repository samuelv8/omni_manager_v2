import 'package:flutter/material.dart';
//import 'package:omni_manager/api/firebase.dart';
import '../home.dart';

class SettingsFormulary extends StatefulWidget {
  const SettingsFormulary({Key? key, required this.isManager, this.employee})
      : super(key: key);
  final bool isManager;
  final String? employee;

  @override
  _SettingsFormularyState createState() =>
      _SettingsFormularyState(isManager, employee);
}

class _SettingsFormularyState extends State<SettingsFormulary> {
  _SettingsFormularyState(this.isManager, this.employee);
  final bool isManager;
  final String? employee;

  final formKey = GlobalKey<FormState>();

  String textQuestion1 = "Digite seu novo email de usuário:";

  String textQuestion2 = "Digite sua nova senha:";

  String textQuestion3 = "Digite sua nova senha novamente:";

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8 ,
      child: Form(
        key: formKey,
        child: Card(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    textQuestion1,
                  ),
                  Container(
                    width: 300,
                    child: TextFormField(
                        decoration: InputDecoration(labelText: 'Nome')),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  Text(
                    textQuestion2,
                  ),
                  Container(
                    width: 300,
                    child: TextFormField(
                        decoration: InputDecoration(labelText: 'Senha')),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  Text(
                    textQuestion3,
                  ),
                  Container(
                    width: 300,
                    child: TextFormField(
                        decoration:
                            InputDecoration(labelText: 'Senha novamente')),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, HomePage.routeName);
                    },
                    child: Text("Salvar"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
