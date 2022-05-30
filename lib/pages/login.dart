import 'package:flutter/material.dart';
import 'package:omni_manager/pages/home.dart';
import 'package:omni_manager/pages/register.dart';
import 'package:omni_manager/utils/shared_prefs.dart';
import 'package:omni_manager/api/auth.dart';
import 'package:omni_manager/api/firebase.dart';
import 'package:omni_manager/widgets/snackbar.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = "/login";

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();

  final _passwordController = TextEditingController();

  final RegExp reg = new RegExp(
      r"^[a-z\.0-9]+@((gmail\.com)|(outlook\.com)|(live\.com)|(hotmail\.com)|(mac\.com)|(icloud\.com)|(me\.com)|(manager\.com)|(ga\.ita\.br)|(gp\.ita\.br)|(ita\.br)|(yahoo\.com\.br))$");


  //function to show pop-up window asking for registered email
  createAlertDialog(BuildContext context) {
    TextEditingController emailController = TextEditingController();

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text("Write your registered email"),
              content: TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              actions: <Widget>[
                MaterialButton(
                  elevation: 5.0,
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text('Password reset canceled.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  },
                ),
                MaterialButton(
                  elevation: 5.0,
                  child: Text("Submit"),
                  onPressed: () async {
                    showSnackBar(text: "Sending email...", context: context);

                    await sendRecoveryEmail(emailController.text).then((value) {
                      hideSnackBar(context: context);
                      showSnackBar(
                          text: "Email sent successfully.", context: context);
                    }).catchError((error) {
                      hideSnackBar(context: context);
                      showSnackBar(
                          text: "Error sending email: ${error.message}",
                          context: context,
                          backgroundColor: Colors.red);
                    });
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                )
              ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          title: Text("Login Page"),
        ),
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Center(
              child: Padding(
                padding: EdgeInsets.fromLTRB(_width/2 - 250.0, 0.0, _width/2 - 250.0, 0.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16.0, 30.0, 16.0, 30.0),
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
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  showSnackBar(
                                      text: 'Loading...', context: context);

                                  signIn(_usernameController.text,
                                          _passwordController.text)
                                      .then((value) async {
                                    // checa se email já foi validado
                                    bool validatedEmail =
                                        await Database.checkEmailValidated()
                                            .then((value) => value)
                                            .catchError((error) {
                                      hideSnackBar(context: context);
                                      showSnackBar(
                                          text: "Error: ${error.message}",
                                          context: context,
                                          backgroundColor: Colors.red);
                                    });
                                    if (validatedEmail) {
                                      hideSnackBar(context: context);
                                      showSnackBar(
                                          text: 'Logged in successfully!',
                                          context: context,
                                          backgroundColor: Colors.green);

                                      Database.userUid = value.user?.uid;
                                      Constants.prefs!
                                          .setBool("loggedIn", true);
                                      Constants.prefs!
                                          .setString("uid", value.user!.uid);
                                      hideSnackBar(context: context);
                                      Navigator.pushReplacementNamed(
                                          context, HomePage.routeName);
                                    } else {
                                      //printa mensagem de não validação de e-mail e impede o login
                                      hideSnackBar(context: context);
                                      showSnackBar(
                                          text:
                                              'Please validate yout e-mail! A new verification e-mail was sent to you.',
                                          context: context);
                                    }
                                  }).catchError((err) {
                                    hideSnackBar(context: context);
                                    showSnackBar(
                                        text:
                                            "Failed to authenticate: ${err.message}",
                                        context: context,
                                        backgroundColor: Colors.red);
                                    hideSnackBar(context: context);
                                  });
                                }
                              },
                              child: Text("Sign In"),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                      context, RegisterPage.routeName);
                                },
                                child: Text("Register")),
                            SizedBox(
                              height: 12,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                createAlertDialog(context);
                                ScaffoldMessenger.of(context).clearSnackBars();
                              },
                              child: Text("Forgot your password?"),
                            )
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
