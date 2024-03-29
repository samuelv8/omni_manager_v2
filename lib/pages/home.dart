import 'package:flutter/material.dart';
import 'package:omni_manager/api/auth.dart';
import 'package:omni_manager/pages/dashboard/dashboard.dart';
import 'package:omni_manager/pages/forms/forms.dart';
import 'package:omni_manager/pages/login.dart';
import 'package:omni_manager/pages/settings/settings.dart';
import 'package:omni_manager/pages/spreadsheet/spreadsheet.dart';
import 'package:omni_manager/utils/shared_prefs.dart';
import 'package:omni_manager/pages/tutorial/tutorial.dart';

class HomePage extends StatefulWidget {
  static const String routeName = "/home";
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  bool loaded = false;

  Future<void> loadIsManager() async {
    loggedUserIsManager = await isUserManager(getUserUid());
  }

  @override
  void initState() {
    super.initState();
    loaded = false;
    loadIsManager().then((value) => setState(() {
          loaded = true;
        }));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!loaded) {
      return Scaffold(
          appBar: AppBar(
            title: Text("Omni Manager"),
          ),
          body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(
        title: Row(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png',
              fit: BoxFit.contain,
              height: 75,
            ),
            Container(
              padding:
                  const EdgeInsets.all(8.0), /*child: Text('YourAppTitle')*/
            )
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              Constants.prefs!.setBool("loggedIn", false);
              Navigator.pushReplacementNamed(context, LoginPage.routeName);
            },
          )
        ],
      ),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.all,
            destinations: [
              if (loggedUserIsManager)
                NavigationRailDestination(
                    icon: Icon(Icons.home_outlined),
                    label: Text("Home"),
                    selectedIcon: Icon(Icons.home)),
              if (loggedUserIsManager)
                NavigationRailDestination(
                    icon: Icon(Icons.list_outlined),
                    label: Text("List"),
                    selectedIcon: Icon(Icons.list)),
              NavigationRailDestination(
                  icon: Icon(Icons.forum_outlined),
                  label: Text("Forms"),
                  selectedIcon: Icon(Icons.forum)),
              NavigationRailDestination(
                  icon: Icon(Icons.settings_outlined),
                  label: Text("Settings"),
                  selectedIcon: Icon(Icons.settings)),
              NavigationRailDestination(
                  icon: Icon(Icons.help),
                  label: Text("Tutorial"),
                  selectedIcon: Icon(Icons.help)),
            ],
          ),
          const VerticalDivider(
            width: 1,
          ),
          _pageAtIndex(_selectedIndex)
        ],
      ),
    );
  }
}

Widget _pageAtIndex(int index) {
  if (loggedUserIsManager) {
    switch (index) {
      case 0:
        return DashboardPage();
      case 1:
        return SpreadsheetPage();
      case 2:
        return FormsPage();
      case 3:
        return SettingsPage();
      case 4:
        return TutorialPage();
    }
  } else {
    switch (index) {
      case 0:
        return FormsPage();
      case 1:
        return SettingsPage();
      case 2:
        return TutorialPage();
    }
  }

  return const Center(
    child: Text('Oops'),
  );
}
