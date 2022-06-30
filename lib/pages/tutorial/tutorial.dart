import 'package:flutter/material.dart';
import 'package:omni_manager/pages/dashboard/widgets/custom_text_title.dart';
import 'package:omni_manager/pages/settings/settings_formulary.dart';
import 'package:omni_manager/pages/tutorial/tutorial_text.dart';
//import 'package:omni_manager/pages/home.dart';
//import 'package:omni_manager/pages/login.dart';
//import 'package:omni_manager/api/auth.dart';

class TutorialPage extends StatefulWidget {
  static const String routeName = "/tutorial";
  @override
  _TutorialPageState createState() => _TutorialPageState();
}

class _TutorialPageState extends State<TutorialPage> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            alignment: Alignment.topLeft,
            child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(children: [
                    Image.asset(
                      'assets/tutpag1.png',
                      fit: BoxFit.contain,
                      width: 1000,
                    ),
                    Image.asset(
                      'assets/tutpag2.png',
                      fit: BoxFit.contain,
                      width: 1000,
                    ),
                  ]),
                  // example
                ]),
          ),
        ));
  }
}
