import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secure/helper/api.dart';
import 'package:secure/page/dashboard.dart';
import 'package:secure/page/vehicle_register.dart';

class VehicleList extends StatefulWidget {
  const VehicleList({super.key});

  @override
  State<VehicleList> createState() => _VehicleListState();
}

class _VehicleListState extends State<VehicleList> {
  final List<Widget> _kendaraan = [];
  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicle List'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.to(() => DashboardPage());
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child:
            _kendaraan.isEmpty
                ? const Center(child: Text('No Data'))
                : ListView(children: _kendaraan),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => const VehicleRegister());
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void getData() {
    setState(() {
      _kendaraan.clear();
    });
    Api.getData(context, "kendaraan/getList/*").then((val) {
      if (val!.status == "success") {
        for (var item in val.data!) {
          setState(() {
            _kendaraan.add(
              InkWell(
                onTap: () {
                  Get.to(() => VehicleRegister(), arguments: item);
                },
                child: Card(
                  child: Container(
                    width: double.maxFinite,
                    padding: const EdgeInsets.all(10),
                    child: IntrinsicHeight(
                      child: Row(
                        children: [
                          Flexible(
                            flex: 1,
                            child: CachedNetworkImage(
                              height: 100,
                              imageUrl: item['url_foto'],
                              fit: BoxFit.contain,
                              placeholder:
                                  (context, url) =>
                                      const CircularProgressIndicator(),
                              errorWidget:
                                  (context, url, error) =>
                                      const Icon(Icons.error),
                            ),
                          ),
                          VerticalDivider(color: Colors.black, thickness: 1),
                          Flexible(
                            flex: 5,
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
                                    const Text('No. Polisi'),
                                    const Text(':'),
                                    Text(item['nopol']),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    const Text('Merk'),
                                    const Text(':'),
                                    Text(item['merk']),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    const Text('Tipe'),
                                    const Text(':'),
                                    Text(item['model']),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    const Text('Tahun'),
                                    const Text(':'),
                                    Text(item['tahun']),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    const Text('Notifikasi'),
                                    const Text(':'),
                                    Text(
                                      item['is_active'] == '1'
                                          ? "Active"
                                          : "Not Active",
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
                ),
              ),
            );
          });
        }
      } else {
        Get.snackbar(
          val.status!,
          val.message!,
          colorText: Colors.white,
          backgroundColor: Colors.red[900],
        );
      }
    });
  }
}
