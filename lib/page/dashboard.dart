import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secure/helper/api.dart';
import 'package:secure/helper/constant.dart';
import 'package:secure/helper/prefs.dart';
import 'package:secure/login_page.dart';
import 'package:secure/page/detection_page.dart';
import 'package:secure/page/vehicle_list.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selamat Datang'),
        automaticallyImplyLeading: false,
        actions: [
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
        child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: (1 / 0.7),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          children: [
            InkWell(
              onTap: () {
                Get.to(() => VehicleList());
              },
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                clipBehavior: Clip.antiAlias,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Image.asset("assets/list.png"),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Expanded(
                          child: Container(
                            color: warnaPrimary,
                            child: const Center(
                              child: Text(
                                "Daftar Kendaraan",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Get.to(() => DetectionPage());
              },
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                clipBehavior: Clip.antiAlias,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Image.asset("assets/detect.png"),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Expanded(
                          child: Container(
                            color: warnaPrimary,
                            child: const Center(
                              child: Text(
                                "Deteksi",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
