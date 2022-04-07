import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:omni_manager/constants/style.dart';

/// Example without a datasource
class Avaliation360TableSimple extends StatelessWidget {
  const Avaliation360TableSimple();

  @override
  Widget build(BuildContext context) {
    const _verticalDivider = const VerticalDivider(
      color: Colors.black,
      thickness: 1,
    );

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: normalYellow,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 6),
                color: lightGrey.withOpacity(.1),
                blurRadius: 12)
          ],
          border: Border.all(color: lightGrey, width: .5),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
            dividerColor: Colors.black,
          ),
          child: DataTable(
            dividerThickness: 1.0,
            dataRowHeight: 27.0,
            columns: const <DataColumn>[
              DataColumn(
                label: Text(
                  'Avaliação 360°',
                  style: TextStyle(
                      fontStyle: FontStyle.italic, color: Colors.black),
                ),
              ),
              DataColumn(label: _verticalDivider),
              DataColumn(
                label: Text(
                  'Média individual',
                  style: TextStyle(
                      fontStyle: FontStyle.italic, color: Colors.black),
                ),
              ),
              DataColumn(label: _verticalDivider),
              DataColumn(
                label: Text(
                  'Média geral',
                  style: TextStyle(
                      fontStyle: FontStyle.italic, color: Colors.black),
                ),
              ),
            ],
            rows: const <DataRow>[
              DataRow(
                cells: <DataCell>[
                  DataCell(Text(
                    'Relacionamento',
                    style: TextStyle(color: Colors.black),
                  )),
                  DataCell(_verticalDivider),
                  DataCell(Text(
                    '19',
                    style: TextStyle(color: Colors.black),
                  )),
                  DataCell(_verticalDivider),
                  DataCell(Text(
                    'Student',
                    style: TextStyle(color: Colors.black),
                  )),
                ],
              ),
              DataRow(
                cells: <DataCell>[
                  DataCell(Text(
                    'Proatividade',
                    style: TextStyle(color: Colors.black),
                  )),
                  DataCell(_verticalDivider),
                  DataCell(Text(
                    '43',
                    style: TextStyle(color: Colors.black),
                  )),
                  DataCell(_verticalDivider),
                  DataCell(Text(
                    'Professor',
                    style: TextStyle(color: Colors.black),
                  )),
                ],
              ),
              DataRow(
                cells: <DataCell>[
                  DataCell(Text(
                    'Potencial diretor',
                    style: TextStyle(color: Colors.black),
                  )),
                  DataCell(_verticalDivider),
                  DataCell(Text(
                    '27',
                    style: TextStyle(color: Colors.black),
                  )),
                  DataCell(_verticalDivider),
                  DataCell(Text(
                    'Associate Professor',
                    style: TextStyle(color: Colors.black),
                  )),
                ],
              ),
              DataRow(
                cells: <DataCell>[
                  DataCell(Text(
                    'Desenvolveu habilidades',
                    style: TextStyle(color: Colors.black),
                  )),
                  DataCell(_verticalDivider),
                  DataCell(Text(
                    '27',
                    style: TextStyle(color: Colors.black),
                  )),
                  DataCell(_verticalDivider),
                  DataCell(Text(
                    'Associate Professor',
                    style: TextStyle(color: Colors.black),
                  )),
                ],
              ),
              DataRow(
                cells: <DataCell>[
                  DataCell(Text(
                    'Organização',
                    style: TextStyle(color: Colors.black),
                  )),
                  DataCell(_verticalDivider),
                  DataCell(Text(
                    '27',
                    style: TextStyle(color: Colors.black),
                  )),
                  DataCell(_verticalDivider),
                  DataCell(Text(
                    'Associate Professor',
                    style: TextStyle(color: Colors.black),
                  )),
                ],
              ),
              DataRow(
                cells: <DataCell>[
                  DataCell(Text(
                    'Média',
                    style: TextStyle(color: Colors.black),
                  )),
                  DataCell(_verticalDivider),
                  DataCell(Text(
                    '27',
                    style: TextStyle(color: Colors.black),
                  )),
                  DataCell(_verticalDivider),
                  DataCell(Text(
                    'Associate Professor',
                    style: TextStyle(color: Colors.black),
                  )),
                ],
              ),
              DataRow(
                cells: <DataCell>[
                  DataCell(Text(
                    'Trabalho diretoria',
                    style: TextStyle(color: Colors.black),
                  )),
                  DataCell(_verticalDivider),
                  DataCell(Text(
                    '27',
                    style: TextStyle(color: Colors.black),
                  )),
                  DataCell(_verticalDivider),
                  DataCell(Text(
                    'Associate Professor',
                    style: TextStyle(color: Colors.black),
                  )),
                ],
              ),
              DataRow(
                cells: <DataCell>[
                  DataCell(Text(
                    'Seu trabalho',
                    style: TextStyle(color: Colors.black),
                  )),
                  DataCell(_verticalDivider),
                  DataCell(Text(
                    '27',
                    style: TextStyle(color: Colors.black),
                  )),
                  DataCell(_verticalDivider),
                  DataCell(Text(
                    'Associate Professor',
                    style: TextStyle(color: Colors.black),
                  )),
                ],
              ),
              DataRow(
                cells: <DataCell>[
                  DataCell(Text(
                    'Alocação',
                    style: TextStyle(color: Colors.black),
                  )),
                  DataCell(_verticalDivider),
                  DataCell(Text(
                    '27',
                    style: TextStyle(color: Colors.black),
                  )),
                  DataCell(_verticalDivider),
                  DataCell(Text(
                    'Associate Professor',
                    style: TextStyle(color: Colors.black),
                  )),
                ],
              ),
              DataRow(
                cells: <DataCell>[
                  DataCell(Text(
                    'Motivação',
                    style: TextStyle(color: Colors.black),
                  )),
                  DataCell(_verticalDivider),
                  DataCell(Text(
                    '27',
                    style: TextStyle(color: Colors.black),
                  )),
                  DataCell(_verticalDivider),
                  DataCell(Text(
                    'Associate Professor',
                    style: TextStyle(color: Colors.black),
                  )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
