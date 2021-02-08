import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'const.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Employees> employees;
  List<Employees> selectedEmployees;
  bool sort;

  @override
  void initState() {
    sort = false;
    selectedEmployees = [];
    employees = Employees.getEmployees();
    super.initState();
  }

  onSortColumn(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      if (ascending) {
        employees.sort((a, b) => a.id.compareTo(b.id));
      } else {
        employees.sort((a, b) => b.id.compareTo(a.id));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBGColor,
      appBar: AppBar(
        backgroundColor: kMainColor,
        title: Text(
          'แสดงผลการตรวจ',
          style: kAppBarText,
        ),
      ),
      body: Column(
        children: [
          Container(
            color: kSecondColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ผู้ตรวจ: สวัสดิเกียรติ แสงบุญ',
                  style: kDetailText,
                ),
                Text(
                  'วันที่ตรวจ: 20/01/21',
                  style: kDetailText,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 9,
            child: Container(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  headingRowColor:
                      MaterialStateProperty.resolveWith((Set states) {
                    if (states.contains(MaterialState.hovered))
                      return Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.08);
                    return kMainColor; // Use the default value.
                  }),
                  dataRowColor: MaterialStateProperty.resolveWith((Set states) {
                    if (states.contains(MaterialState.hovered))
                      return Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.08);
                    return Colors.lightBlue[100]; // Use the default value.
                  }),
                  sortAscending: sort,
                  sortColumnIndex: 0,
                  columnSpacing: 10,
                  headingTextStyle: TextStyle(
                      fontFamily: 'Mitr-Regular',
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                  dataTextStyle: TextStyle(
                      fontFamily: 'Mitr-Regular', color: Colors.black87),
                  showBottomBorder: true,
                  columns: [
                    DataColumn(
                        label: Text('รหัส'),
                        numeric: false,
                        onSort: (columnIndex, ascending) {
                          setState(() {
                            sort = !sort;
                          });
                          onSortColumn(columnIndex, ascending);
                        }),
                    DataColumn(
                      label: Text('ชื่อ'),
                      numeric: false,
                    ),
                    DataColumn(
                      label: Icon(
                        Icons.ac_unit,
                        color: Colors.white,
                      ),
                      numeric: true,
                    ),
                    DataColumn(
                      label: Icon(
                        Icons.favorite,
                        color: Colors.white,
                      ),
                      numeric: true,
                    ),
                    DataColumn(
                      label: Icon(
                        Icons.sports_bar,
                        color: Colors.white,
                      ),
                      numeric: true,
                    ),
                    DataColumn(
                      label: Icon(
                        Icons.remove_circle,
                        color: Colors.white,
                      ),
                      numeric: false,
                    ),
                  ],
                  rows: employees
                      .map(
                        (employee) => DataRow(
                            selected: selectedEmployees.contains(employee),
                            cells: [
                              DataCell(
                                Text(employee.id),
                                onTap: () {
                                  print('Selected ${employee.id}');
                                },
                              ),
                              DataCell(
                                Text(employee.name),
                              ),
                              DataCell(
                                Text(
                                  employee.temperature.toString(),
                                  style: TextStyle(
                                      color: employee.temperature < 37.5
                                          ? Colors.black87
                                          : Colors.red),
                                ),
                              ),
                              DataCell(
                                Text(employee.pressure.toString()),
                              ),
                              DataCell(
                                Text(
                                  employee.alcohol.toString(),
                                  style: TextStyle(
                                      color: employee.alcohol < 60
                                          ? Colors.black87
                                          : Colors.red),
                                ),
                              ),
                              DataCell(
                                Text(
                                  employee.drug,
                                  style: TextStyle(
                                      color: employee.drug == 'ผ่าน'
                                          ? Colors.green
                                          : Colors.red),
                                ),
                              ),
                            ]),
                      )
                      .toList(),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'ตรวจแล้ว ${employees.length}/30',
                  style: kMenuText,
                ),
                Text(
                  'ไม่ผ่าน: 4',
                  style: TextStyle(
                    fontFamily: 'Mitr-Regular',
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Employees {
  String id;
  String name;
  double temperature;
  double pressure;
  double alcohol;
  String drug;

  Employees(
      {this.id,
      this.name,
      this.temperature,
      this.pressure,
      this.alcohol,
      this.drug});

  static List<Employees> getEmployees() {
    return <Employees>[
      Employees(
          id: 'N0001',
          name: 'สวัสดิเกียรติ',
          temperature: 36.5,
          pressure: 125.5,
          alcohol: 0,
          drug: 'ผ่าน'),
      Employees(
          id: 'N0006',
          name: 'สมศักดิ์',
          temperature: 34.5,
          pressure: 120.5,
          alcohol: 0,
          drug: 'ผ่าน'),
      Employees(
          id: 'N0009',
          name: 'สันสนีย์',
          temperature: 37.5,
          pressure: 123.5,
          alcohol: 0,
          drug: 'ผ่าน'),
      Employees(
          id: 'N00013',
          name: 'จิรประภาบวรชัย',
          temperature: 36.5,
          pressure: 121.9,
          alcohol: 0,
          drug: 'ไม่ผ่าน'),
      Employees(
          id: 'N00017',
          name: 'สุวรรณศักดิ์',
          temperature: 36.0,
          pressure: 121.3,
          alcohol: 60,
          drug: 'ไม่ผ่าน'),
      Employees(
          id: 'N00030',
          name: 'มาริสา',
          temperature: 35.3,
          pressure: 125.6,
          alcohol: 0,
          drug: 'ผ่าน'),
      Employees(
          id: 'N00027',
          name: 'กฤษณะ',
          temperature: 36.5,
          pressure: 120.5,
          alcohol: 0,
          drug: 'ผ่าน'),
      Employees(
          id: 'N0074',
          name: 'สุขกมล',
          temperature: 37.9,
          pressure: 125.5,
          alcohol: 0,
          drug: 'ผ่าน'),
      Employees(
          id: 'N00038',
          name: 'วิชาญ',
          temperature: 35.9,
          pressure: 120.5,
          alcohol: 0,
          drug: 'ผ่าน'),
      Employees(
          id: 'N00053',
          name: 'ชาญชัย',
          temperature: 36.5,
          pressure: 121.4,
          alcohol: 0,
          drug: 'ผ่าน'),
      Employees(
          id: 'N00063',
          name: 'วิชิต',
          temperature: 35.5,
          pressure: 121.4,
          alcohol: 0,
          drug: 'ผ่าน'),
      Employees(
          id: 'N00063',
          name: 'วิชัย',
          temperature: 34.5,
          pressure: 121.4,
          alcohol: 0,
          drug: 'ผ่าน'),
    ];
  }
}
