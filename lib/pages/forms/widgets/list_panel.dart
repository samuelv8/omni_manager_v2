import 'package:flutter/material.dart';
import 'package:omni_manager/api/firebase.dart';
import 'package:omni_manager/pages/forms/widgets/formulary.dart';
import 'package:omni_manager/widgets/snackbar.dart';

// stores ExpansionPanel state information
class Item {
  Item({
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
}

/// This is the stateful widget that the main application instantiates.
class ListPanel extends StatefulWidget {
  const ListPanel({Key? key}) : super(key: key);

  @override
  State<ListPanel> createState() => _ListPanelState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _ListPanelState extends State<ListPanel> {
  List<Item> _data = [];
  @override
  void initState() {
    super.initState();
    Database.listEmployeesWithName().then((mapEmployees) {
      var map = mapEmployees.entries.toList();
      int numberOfItems = map.length;
      setState(() {
        _data = List<Item>.generate(numberOfItems, (int index) {
          return Item(
            headerValue: map[index].value, //nome do usuário
            expandedValue: map[index]
                .key, //chave de referência user.id : a ser passa para Formulary()
          );
        });
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_data.isEmpty) {
      showSnackBar(text: 'Loading...', context: context);
      return Container(
        child: Center(child: CircularProgressIndicator()),
      );
    }
    hideSnackBar(context: context);
    return Container(
      width: MediaQuery.of(context).size.width,
      child: ExpansionPanelList(
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            _data[index].isExpanded = !isExpanded;
          });
        },
        children: _data.map<ExpansionPanel>((Item item) {
          return ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                key: UniqueKey(),
                title: Text(item.headerValue),
              );
            },
            body: Center(
              child: SingleChildScrollView(
                  padding: EdgeInsets.all(32),
                  child: Formulary(
                      key: UniqueKey(),
                      isManager: true,
                      employee: item.expandedValue)),
            ),
            isExpanded: item.isExpanded,
          );
        }).toList(),
      ),
    );
  }
}
