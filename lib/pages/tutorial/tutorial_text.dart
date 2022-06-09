import 'package:flutter/material.dart';
//import 'package:omni_manager/api/firebase.dart';
import '../home.dart';

class TutorialText extends StatefulWidget {
  const TutorialText({Key? key, required this.isManager, this.employee})
      : super(key: key);
  final bool isManager;
  final String? employee;

  @override
  _TutorialTextState createState() => _TutorialTextState(isManager, employee);
}

class _TutorialTextState extends State<TutorialText> {
  _TutorialTextState(this.isManager, this.employee);
  final bool isManager;
  final String? employee;

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Card(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.white, fontSize: 24),
                    children: <TextSpan>[
                      TextSpan(
                          text: 'How does the formulary page works?',
                          style: TextStyle(color: Colors.yellow)),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
