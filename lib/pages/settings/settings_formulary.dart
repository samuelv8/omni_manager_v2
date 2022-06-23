import 'package:flutter/material.dart';
//import 'package:omni_manager/api/firebase.dart';
import '../home.dart';
import '../login.dart';
import 'package:omni_manager/api/auth.dart';
import 'package:omni_manager/widgets/snackbar.dart';

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

  final formKeyEmail = GlobalKey<FormState>();

  final formKeyPassword = GlobalKey<FormState>();

  final formKeyRepeatPassword = GlobalKey<FormState>();

  final _usernameController = TextEditingController();

  final _passwordController = TextEditingController();

  final _repeatpasswordController = TextEditingController();

  String textQuestion1 = "Enter your new user email:";

  String textQuestion2 = "Enter your new password:";

  String textQuestion3 = "Enter your new password again:";

  final RegExp reg = new RegExp(
      r"^[a-z\.0-9]+@((gmail\.com)|(outlook\.com)|(live\.com)|(hotmail\.com)|(mac\.com)|(icloud\.com)|(me\.com)|(manager\.com)|(ga\.ita\.br)|(gp\.ita\.br)|(ita\.br)|(yahoo\.com\.br))$");


  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8 ,
        child: Card(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 300,
                    child: Form(
                      key: formKeyEmail,
                      child: TextFormField(
                        controller: _usernameController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: "Your new e-mail", labelText: "e-mail"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your e-mail';
                          }
                          if (!reg.hasMatch(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (formKeyEmail.currentState!.validate()){
                        bool successfulEmail =
                                          await changeEmail(_usernameController.text)
                                              .then((value) => value)
                                              .catchError((err) {
                                                showSnackBar(
                                                    text:
                                                        "Failed to authenticate: ${err.toString()}",
                                                    context: context,
                                                    backgroundColor: Colors.red);
                                                hideSnackBar(context: context);
                                                return false;
                                              });
                        if(successfulEmail){
                          sendEmailVerification();
                          Navigator.pushReplacementNamed(
                              context,
                              LoginPage.routeName);
                          showSnackBar(
                              text:
                                  'Your e-mail has been updated. A verification e-mail has been sent to you.',
                              context: context,
                              backgroundColor: Colors.green);
                        }
                      }
                    },
                    child: Text("Change e-mail"),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 300,
                    child: Form(
                      key: formKeyPassword,
                      child: TextFormField(
                        controller: _passwordController,
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Your new password", labelText: "password"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            return 'Very small password. Your password must be 6 or more characters long.';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 300,
                    child: Form(
                      key: formKeyRepeatPassword,
                      child: TextFormField(
                        controller: _repeatpasswordController,
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Confirm your new password.", labelText: "repeat password"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value != _passwordController.text) {
                            return 'Unmatched passwords! Try typing again.';
                          }
                          if (value.length < 6) {
                            return 'Very small password. Your password must be 6 or more characters long.';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if(formKeyPassword.currentState!.validate() && formKeyRepeatPassword.currentState!.validate()){
                        bool successfulPassword = 
                                          await updateInfo(_passwordController.text)
                                              .then((value) => value)
                                              .catchError((err) {
                                                showSnackBar(
                                                    text:
                                                        "Failed to authenticate: ${err.toString()}",
                                                    context: context,
                                                    backgroundColor: Colors.red);
                                                hideSnackBar(context: context);
                                                return false;
                                              });
                        if(successfulPassword){
                          Navigator.pushReplacementNamed(
                              context,
                              HomePage.routeName);
                          showSnackBar(
                              text:
                                  'Your password has been updated.',
                              context: context,
                              backgroundColor: Colors.green);
                        }
                      }
                    },
                    child: Text("Change password"),
                  ),SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if(formKeyPassword.currentState!.validate() && formKeyRepeatPassword.currentState!.validate() && formKeyEmail.currentState!.validate()){
                        bool successfulPassword = 
                                          await updateInfo(_passwordController.text)
                                              .then((value) => value)
                                              .catchError((err) {
                                                showSnackBar(
                                                    text:
                                                        "Failed to authenticate: ${err.toString()}",
                                                    context: context,
                                                    backgroundColor: Colors.red);
                                                hideSnackBar(context: context);
                                                return false;
                                              });
                        bool successfulEmail = 
                                          await changeEmail(_usernameController.text)
                                              .then((value) => value)
                                              .catchError((err) {
                                                showSnackBar(
                                                    text:
                                                        "Failed to authenticate: ${err.toString()}",
                                                    context: context,
                                                    backgroundColor: Colors.red);
                                                hideSnackBar(context: context);
                                                return false;
                                              });
                        if(successfulEmail && successfulPassword){
                          sendEmailVerification();
                          Navigator.pushReplacementNamed(
                              context,
                              LoginPage.routeName);
                          showSnackBar(
                              text:
                                  'Your data has been updated. A verification e-mail has been sent to you.',
                              context: context,
                              backgroundColor: Colors.green);
                        }
                      }
                    },
                    child: Text("Change e-mail and password"),
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
  }
}

