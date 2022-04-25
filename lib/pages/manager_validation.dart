import 'package:flutter/material.dart';
import 'package:omni_manager/pages/home.dart';
import 'package:omni_manager/pages/login.dart';
import 'package:omni_manager/api/auth.dart';
import 'package:omni_manager/api/firebase.dart';

class ValidationPage extends StatefulWidget {
  static const String routeName = "/validate";
  @override
  _ValidationPageState createState() => _ValidationPageState();
}

class _ValidationPageState extends State<ValidationPage> {
  final formKey = GlobalKey<FormState>();

  final _companyController = TextEditingController();

  final _departmentController = TextEditingController();

  bool _employee = false;

  bool _managerExists = false;

  final _managerEmailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Company and manager validation"),
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
                                SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  controller: _companyController,
                                  keyboardType: TextInputType.text,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your company';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      hintText: "Enter the company you work at",
                                      labelText: "Company"),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  controller: _departmentController,
                                  keyboardType: TextInputType.text,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your department';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      hintText:
                                          "Enter the department you work at",
                                      labelText: "Department"),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Employee?"),
                                    Checkbox(
                                        checkColor: Colors.black,
                                        fillColor:
                                            MaterialStateProperty.resolveWith(
                                                (Set<MaterialState> states) {
                                          const Set<MaterialState>
                                              interactiveStates =
                                              <MaterialState>{
                                            MaterialState.pressed,
                                            MaterialState.hovered,
                                            MaterialState.focused,
                                            MaterialState.selected
                                          };
                                          if (states.any(
                                              interactiveStates.contains)) {
                                            return Colors.yellow;
                                          }
                                          return Colors.grey;
                                        }),
                                        value: _employee,
                                        onChanged: (bool? _newValue) {
                                          setState(() {
                                            _employee = _newValue!;
                                          });
                                        })
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Visibility(
                                    visible: _employee,
                                    child: FocusScope(
                                      child: Focus(
                                        child: TextFormField(
                                          autovalidateMode: AutovalidateMode.onUserInteraction,
                                          controller: _managerEmailController,
                                          keyboardType: TextInputType.text,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "Please enter your manager's e-mail";
                                            } else if (!_managerExists) {
                                              return "Manager not found";
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                              hintText: "Your manager's email",
                                              labelText: "Manager email"),
                                        ),
                                        canRequestFocus: false,
                                        onFocusChange: (value) async {
                                          if (!value) {
                                            bool managerExists =
                                                await Database.validateManager({
                                              "email": _managerEmailController.text,
                                              "company":
                                                  _companyController.text,
                                              "department":
                                                  _departmentController.text
                                            });
                                            setState(() {
                                              _managerExists = managerExists;
                                            });
                                          }
                                        },
                                      ),
                                    )),
                                SizedBox(
                                  height: 20,
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    if (formKey.currentState!.validate()) {
                                      bool successfulUpdate =
                                          await updateUserData({
                                        "company": _companyController.text,
                                        "department":
                                            _departmentController.text,
                                        "manager": !_employee,
                                        "manager_email":
                                            _managerEmailController.text
                                      });

                                      if (successfulUpdate) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              duration:  const Duration(seconds: 20),
                                              content: Text('Successful register! Please verify your e-mail to sing in, a verification e-mail has been sent to you.'),
                                              backgroundColor: Colors.green,
                                          ),
                                        );
                                        Navigator.pushReplacementNamed(
                                            context, LoginPage.routeName);
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
