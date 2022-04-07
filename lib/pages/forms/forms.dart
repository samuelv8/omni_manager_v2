import 'package:flutter/material.dart';
import 'package:omni_manager/api/auth.dart';
import 'package:omni_manager/api/firebase.dart';
import 'package:omni_manager/pages/forms/widgets/formulary.dart';
import 'package:omni_manager/pages/forms/widgets/list_panel.dart';
import '../dashboard/widgets/custom_text_title.dart';

class FormsPage extends StatefulWidget {
  static const String routeName = "/forms";
  @override
  _FormsPageState createState() => _FormsPageState();
}

class _FormsPageState extends State<FormsPage> {
  bool isManager = loggedUserIsManager;

  @override
  Widget build(BuildContext context) {
    if (isManager) {
      return Padding(
        padding: const EdgeInsets.all(30.0),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          alignment: Alignment.topLeft,
          child: SingleChildScrollView(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 30.0),
                        child: CustomTextTitle(
                          text: "Formularies",
                          size: 40,
                          weight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Loading...')),
                            );
                            Database.releaseForms().then((value) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Forms released successfully!'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              setState(() {});
                            }).catchError((err) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text("Failed to release. Error: $err"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              setState(() {});
                            });
                          },
                          child: Text("Release Forms"))
                    ],
                  ),
                  Container(alignment: Alignment.center, child: ListPanel()),
                  SizedBox(
                    height: 20,
                  ),
                ]),
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(30.0),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          alignment: Alignment.topLeft,
          child: SingleChildScrollView(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 30.0),
                        child: CustomTextTitle(
                          text: "Formularies",
                          size: 40,
                          weight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Formulary(
                    isManager: isManager,
                    employee: getUserUid(),
                  ),
                ]),
          ),
        ),
      );
    }
  }
}
