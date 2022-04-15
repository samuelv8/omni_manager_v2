import 'package:flutter/material.dart';
import 'package:omni_manager/pages/home.dart';
import 'package:omni_manager/pages/register.dart';
import 'package:omni_manager/utils/shared_prefs.dart';
import 'package:omni_manager/api/auth.dart';
import 'package:omni_manager/api/firebase.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = "/login";
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();

  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Login Page"),
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            TextFormField(
                              controller: _usernameController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  hintText: "Enter email",
                                  labelText: "Username"),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your e-mail';
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
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Loading...')),
                                  );
                                  signIn(_usernameController.text,
                                          _passwordController.text)
                                      .then((value) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text('Logged in successfully!'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                    Database.userUid = value.user?.uid;
                                    Constants.prefs!.setBool("loggedIn", true);
                                    Constants.prefs!
                                        .setString("uid", value.user!.uid);
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();
                                    Navigator.pushReplacementNamed(
                                        context, HomePage.routeName);
                                  }).catchError((err) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            "Failed to authenticate: ${err.message}"),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();
                                  });
                                }
                              },
                              child: Text("Sign In"),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                    context, RegisterPage.routeName);
                              },
                              child: Text("Register"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
