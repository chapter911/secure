import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secure/helper/api.dart';
import 'package:secure/helper/constant.dart';
import 'package:secure/page/dashboard.dart';
import 'package:secure/page/detection_detail.dart';
import 'package:secure/style/style.dart';

class DetectionPage extends StatefulWidget {
  const DetectionPage({super.key});

  @override
  State<DetectionPage> createState() => _DetectionPageState();
}

class _DetectionPageState extends State<DetectionPage> {
  final List<Widget> _list = [];
  final TextEditingController _nopol = TextEditingController();
  final TextEditingController _tanggal = TextEditingController();

  String _status = "- Semua -";

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detection'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.to(() => DashboardPage());
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Filter'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: _nopol,
                          decoration: dekorasiInput(
                            hint: "Nomor Polisi",
                            icon: Icons.numbers,
                          ),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: _tanggal,
                          decoration: dekorasiInput(
                            hint: "Tanggal",
                            icon: Icons.calendar_month,
                          ),
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101),
                            );
                            if (pickedDate != null) {
                              setState(() {
                                _tanggal.text =
                                    pickedDate.toString().split(' ')[0];
                              });
                            }
                          },
                        ),
                        SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          value: _status,
                          hint: Text("Status"),
                          items:
                              <String>[
                                '- Semua -',
                                'Dikenali',
                                'Tidak Dikenali',
                                'Belum Diperiksa',
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                          decoration: dekorasiInput(hint: 'Status'),
                          onChanged: (String? newValue) {
                            setState(() {
                              _status = newValue!;
                            });
                          },
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        child: Text('Reset'),
                        onPressed: () {
                          setState(() {
                            _nopol.text = "";
                            _tanggal.text = "";
                            _status = "- Semua -";
                          });
                          Get.back();
                          getData();
                        },
                      ),
                      TextButton(
                        child: Text('OK'),
                        onPressed: () {
                          Get.back();
                          getData();
                        },
                      ),
                    ],
                  );
                },
              );
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Expanded(
          child: SingleChildScrollView(child: Column(children: _list)),
        ),
      ),
    );
  }

  void getData() {
    setState(() {
      _list.clear();
    });
    Api.postData(context, "kendaraan/getDetection", {
      "nopol": _nopol.text.isEmpty ? "*" : _nopol.text,
      "tanggal": _tanggal.text.isEmpty ? "*" : _tanggal.text,
      "status": _status == "- Semua -" ? "*" : _status,
    }).then((val) {
      if (val!.status == "success") {
        for (var i = 0; i < val.data!.length; i++) {
          _list.add(
            InkWell(
              onTap: () {
                Get.to(() => DetectionDetail(), arguments: val.data![i]);
              },
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      color: warnaPrimary,
                      width: double.infinity,
                      padding: EdgeInsets.all(10),
                      child: Center(
                        child: Text(
                          val.data![i]["nopol"],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      color:
                          val.data![i]['is_recognized'] == null
                              ? Colors.grey[100]
                              : (int.parse(val.data![i]['is_recognized']) == 1
                                  ? Colors.green[100]
                                  : Colors.red[200]),
                      child: Table(
                        border: const TableBorder(
                          horizontalInside: BorderSide(
                            width: 1,
                            style: BorderStyle.solid,
                            color: Colors.black,
                          ),
                        ),
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        columnWidths: const <int, TableColumnWidth>{
                          0: FractionColumnWidth(0.3),
                          1: FractionColumnWidth(0.05),
                          2: FractionColumnWidth(0.65),
                        },
                        children: [
                          TableRow(
                            children: [
                              const Text('Tanggal'),
                              const Text(':'),
                              Text(val.data![i]['device_date']),
                            ],
                          ),
                          TableRow(
                            children: [
                              const Text('Status'),
                              const Text(':'),
                              Text(
                                val.data![i]['is_recognized'] == null
                                    ? "Belum Diperiksa"
                                    : (int.parse(
                                              val.data![i]['is_recognized'],
                                            ) ==
                                            1
                                        ? "Dikenali"
                                        : "Tidak Dikenali"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        setState(() {});
      }
    });
  }
}
