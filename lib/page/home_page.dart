import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secure/helper/api.dart';
import 'package:secure/helper/prefs.dart';
import 'package:secure/login_page.dart';
import 'package:secure/page/map_page.dart';
import 'package:secure/page/register_vechile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        title: const Text('Secure'),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => const MapPage());
            },
            icon: Icon(Icons.map),
          ),
          IconButton(
            onPressed: () {
              getData();
            },
            icon: Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder:
                    (c) => AlertDialog(
                      title: const Text('Logout'),
                      content: const Text('Are you sure you want to logout?'),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: const Text('No'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Get.back();
                            Api.getData(
                              context,
                              "users/logout/${Prefs.readString("username")}",
                            ).then((val) {
                              if (val!.status == "success") {
                                Prefs().clearData();
                                Get.offAll(() => const LoginPage());
                              } else {
                                Get.snackbar(
                                  val.status!,
                                  val.message!,
                                  colorText: Colors.white,
                                  backgroundColor: Colors.red[900],
                                );
                              }
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: const Text(
                            'Yes',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
              );
            },
            icon: Icon(Icons.power_settings_new),
          ),
        ],
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
          Get.to(() => const RegisterVechile());
        },
        child: const Icon(Icons.add),
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
                  Get.to(() => RegisterVechile(), arguments: item);
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
                              imageUrl: item['url_foto'],
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
