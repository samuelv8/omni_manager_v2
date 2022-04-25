import 'package:flutter/material.dart';
import 'package:omni_manager/pages/login.dart';
import 'package:omni_manager/utils/shared_prefs.dart';
import 'package:omni_manager/api/auth.dart';
import 'package:omni_manager/api/firebase.dart';
import 'package:omni_manager/pages/manager_validation.dart';
//import 'package:omni_manager/api/queries.dart';

class RegisterPage extends StatefulWidget {
  static const String routeName = "/register";
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();

  final _usernameController = TextEditingController();

  final _passwordController = TextEditingController();

  final _repeatpasswordController = TextEditingController();

  final RegExp reg = new RegExp(r"^[a-z\.0-9]+@((gmail\.com)|(outlook\.com)|(live\.com)|(hotmail\.com)|(mac\.com)|(icloud\.com)|(me\.com)|(manager\.com)|(ga\.ita\.br))$");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Staff Register Page"),
        ),
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Card(
                      child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: FocusTraversalGroup(
                            policy: WidgetOrderTraversalPolicy(),
                            descendantsAreFocusable: true,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                TextFormField(
                                  controller: _nameController,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                      hintText: "Your name", labelText: "Name"),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your name';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  controller: _usernameController,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                      hintText: "Your email",
                                      labelText: "Email"),
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
                                SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  controller: _passwordController,
                                  keyboardType: TextInputType.text,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                      hintText: "Enter password",
                                      labelText: "Password"),
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
                                TextFormField(
                                  controller: _repeatpasswordController,
                                  keyboardType: TextInputType.text,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                      hintText: "Confirm password",
                                      labelText: "Repeat Password"),
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
                                SizedBox(
                                  height: 20,
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    Map<String, dynamic> userData = {
                                      "email": _usernameController.text,
                                      "password": _passwordController.text,
                                      "name": _nameController.text,
                                    };
                                    if (formKey.currentState!.validate()) {
                                      bool successfulRegister =
                                          await register(userData)
                                              .then((value) => value)
                                              .catchError((err) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                "Failed to authenticate: ${err.toString()}"),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                        ScaffoldMessenger.of(context)
                                            .hideCurrentSnackBar();
                                        return false;
                                      });

                                      if (successfulRegister) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text('Loading...')),
                                        );
                                        signIn(_usernameController.text,
                                                _passwordController.text)
                                            .then((value) {
                                            sendEmailVerification();
                                          Constants.prefs
                                              !.setBool("loggedIn", true);
                                          Navigator.pushReplacementNamed(
                                              context,
                                              ValidationPage.routeName);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content:
                                                  Text('A verification e-mail has been sent to you.'),
                                              backgroundColor: Colors.green,
                                            ),
                                          );
                                        });
                                      }
                                      else{
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                "E-mail already registered! You can redefine your password in Sign In options."),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  child: Text("Register"),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushReplacementNamed(
                                        context, LoginPage.routeName);
                                  },
                                  child: Text("Sign In"),
                                ),
                              ],
                            ),
                          )),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}