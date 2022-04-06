import 'package:flutter/material.dart';

class DataTableWidget extends StatelessWidget {
  final List<Map<String, dynamic>> listOfColumns;

  DataTableWidget({required this.listOfColumns});

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columnSpacing: (MediaQuery.of(context).size.width / 6) * 0.2,
      columns: [
        DataColumn(label: Text('Nome')),
        DataColumn(label: Text('Média geral (%)')),
        DataColumn(label: Text('Carga de trabalho')),
        DataColumn(label: Text('Entregas realizadas (%)')),
        DataColumn(label: Text('Qualidade do trabalho (%)')),
        DataColumn(label: Text('Proatividade (%)')),
      ],
      rows:
          listOfColumns // Loops through dataColumnText, each iteration assigning the value to element
              .map(
                ((element) => DataRow(
                      cells: <DataCell>[
                        DataCell(Text(element["name"]!)),
                        DataCell(Text(element["performance"]!)),
                        DataCell(Text(element["work_proactivity"]!)),
                        DataCell(Text(element["work_load"]!)),
                        DataCell(Text(element["work_completion"]!)),
                        DataCell(Text(element["work_quality"]!)),
                      ],
                    )),
              )
              .toList(),
    );
  }
}
