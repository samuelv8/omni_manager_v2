import 'package:flutter/material.dart';
import 'package:omni_manager/api/auth.dart';
import 'package:omni_manager/api/firebase.dart';
import 'package:omni_manager/pages/forms/widgets/formulary.dart';
import 'package:omni_manager/pages/forms/widgets/list_panel.dart';
import 'package:omni_manager/widgets/snackbar.dart';
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
                            showSnackBar(text: 'Loading...', context: context)
                            Database.releaseForms().then((value) {
                              showSnackBar(text: 'Forms released successfully!',
                                context: context,
                                backgroundColor: Colors.green
                              );
                              hideSnackBar(context: context);
                              setState(() {});
                            }).catchError((err) {
                              showSnackBar(text: "Failed to release. Error: ${err.message}",
                                context: context,
                                backgroundColor: Colors.red
                              );
                              hideSnackBar(context: context);
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
