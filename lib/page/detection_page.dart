import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secure/helper/api.dart';
import 'package:secure/helper/constant.dart';
import 'package:secure/page/dashboard.dart';
import 'package:secure/page/detection_detail.dart';

class DetectionPage extends StatefulWidget {
  const DetectionPage({super.key});

  @override
  State<DetectionPage> createState() => _DetectionPageState();
}

class _DetectionPageState extends State<DetectionPage> {
  final List<Widget> _list = [];

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
    Api.getData(context, "kendaraan/getDetection/*").then((val) {
      if (val!.status == "success") {
        print(val.data);
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
