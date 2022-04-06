import 'package:flutter/material.dart';
import 'package:omni_manager/pages/dashboard/widgets/custom_text_title.dart';
import 'package:omni_manager/pages/forms/widgets/formulary.dart';
import 'package:omni_manager/pages/settings/settings_formulary.dart';
//import 'package:omni_manager/pages/home.dart';
//import 'package:omni_manager/pages/login.dart';
//import 'package:omni_manager/api/auth.dart';

class SettingsPage extends StatefulWidget {
  static const String routeName = "/settings";
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        alignment: Alignment.topLeft,
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30.0),
                    child: CustomTextTitle(
                      text: "Configurações",
                      size: 40,
                      weight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                  child: SettingsFormulary(
                      isManager: true,
                      employee: "bOLnQhbXqGdfN9p5r9jpMnoXbgC3")), // example
            ]),
      ),
    );
  }
}
