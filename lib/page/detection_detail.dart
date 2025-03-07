import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:secure/helper/api.dart';
import 'package:secure/helper/constant.dart';
import 'package:secure/page/detection_page.dart';

class DetectionDetail extends StatefulWidget {
  const DetectionDetail({super.key});

  @override
  State<DetectionDetail> createState() => _DetectionDetailState();
}

class _DetectionDetailState extends State<DetectionDetail> {
  @override
  void initState() {
    super.initState();
    print(Get.arguments);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(Get.arguments["nopol"])),
      body: Column(
        children: [
          Flexible(
            child: FlutterMap(
              options: MapOptions(
                initialCenter: LatLng(
                  double.parse(Get.arguments['latitude']),
                  double.parse(Get.arguments['longitude']),
                ),
                initialZoom: 13.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(
                        double.parse(Get.arguments['latitude']),
                        double.parse(Get.arguments['longitude']),
                      ),
                      width: 150,
                      height: 150,
                      child: Icon(Icons.car_crash, color: Colors.red, size: 25),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Flexible(
            child: Container(
              padding: EdgeInsets.all(10),
              child: Card(
                child: Image.network(
                  Get.arguments['url_foto'],
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Divider(),
          Flexible(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Apakah anda yakin mengenali pengendara ini?"),
                  SizedBox(height: 20),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 100,
                        child: ElevatedButton(
                          onPressed: () {
                            sendUpdate(1);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: warnaPrimary,
                          ),
                          child: Text(
                            "Ya",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(width: 50),
                      SizedBox(
                        width: 100,
                        child: ElevatedButton(
                          onPressed: () {
                            sendUpdate(0);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[900],
                          ),
                          child: Text(
                            "Tidak",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          MapsLauncher.launchCoordinates(
            double.parse(Get.arguments['latitude']),
            double.parse(Get.arguments['longitude']),
          );
        },
        child: Icon(Icons.map),
      ),
    );
  }

  void sendUpdate(int i) {
    Api.postData(context, "kendaraan/updateDetection", {
      "id": Get.arguments['id'],
      "is_recognized": i,
    }).then((val) {
      Get.snackbar(
        val!.status!,
        val.message!,
        colorText: Colors.white,
        backgroundColor:
            val.status == "success" ? Colors.green[900] : Colors.red[900],
      );
      if (val.status == "success") {
        Get.offAll(() => DetectionPage());
      }
    });
  }
}
