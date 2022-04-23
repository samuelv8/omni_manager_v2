import 'package:flutter/material.dart';

class RedefinePasswordPage extends StatefulWidget {
  static const String routeName = "/redefine";
  @override
  _RedefinePasswordPageState createState() => _RedefinePasswordPageState();
}

class _RedefinePasswordPageState extends State<RedefinePasswordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Password Redefinition Page"),
        ),
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Form(
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
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                      hintText: "Enter new password",
                                      labelText: "New password"),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                      hintText: "Repeat new password",
                                      labelText: "Repeat new password"),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                ElevatedButton(
                                  onPressed: () {},
                                  child: Text("Redefine password"),
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
