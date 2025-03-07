import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:secure/helper/api.dart';
import 'package:secure/helper/common_task.dart';
import 'package:secure/helper/prefs.dart';
import 'package:secure/page/vehicle_list.dart';
import 'package:secure/style/style.dart';

class VehicleRegister extends StatefulWidget {
  const VehicleRegister({super.key});

  @override
  State<VehicleRegister> createState() => _VehicleRegisterState();
}

class _VehicleRegisterState extends State<VehicleRegister> {
  final TextEditingController _nopol = TextEditingController();
  final TextEditingController _tahun = TextEditingController();

  String _merk = '- PILIH -';
  String _model = '- PILIH -';
  String _statusNotif = 'Aktif';

  final List<String> _merkList = [
    '- PILIH -',
    'Toyota',
    'Honda',
    'Ford',
    'BMW',
    'Mercedes',
  ];
  final List<String> _modelList = [
    '- PILIH -',
    'Sedan',
    'SUV',
    'Hatchback',
    'Convertible',
    'Coupe',
    'Minivan',
    'Pickup Truck',
  ];

  String _imageUrl = "";

  File? _image;

  bool _isUpdate = false;

  @override
  initState() {
    super.initState();
    if (Get.arguments != null) {
      _nopol.text = Get.arguments['nopol'];
      _merk = Get.arguments['merk'];
      _model = Get.arguments['model'];
      _tahun.text = Get.arguments['tahun'];
      _imageUrl = Get.arguments['url_foto'];
      _statusNotif = Get.arguments['is_active'] == 1 ? "Aktif" : "Tidak Aktif";
      _isUpdate = true;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isUpdate ? 'Update Vehicle' : 'Register Vechile'),
        actions: [
          Visibility(
            visible: _isUpdate,
            child: IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder:
                      (c) => AlertDialog(
                        title: const Text('Hapus'),
                        content: const Text('Anda yakin untuk menghapus?'),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: const Text('No'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Api.getData(
                                context,
                                "kendaraan/hapus/${_nopol.text}",
                              ).then((val) {
                                Get.snackbar(
                                  val!.status!,
                                  val.message!,
                                  colorText: Colors.white,
                                  backgroundColor: Colors.red[900],
                                );
                                if (val.status == "success") {
                                  Get.offAll(() => VehicleList());
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
              icon: const Icon(Icons.delete),
            ),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Pilih Sumber Gambar'),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                ElevatedButton(
                                  child: const Text('Kamera'),
                                  onPressed: () {
                                    Get.back();
                                    ambilFoto(ImageSource.camera).then((value) {
                                      if (value != null) {
                                        setState(() {
                                          _image = value;
                                        });
                                      }
                                    });
                                  },
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  child: const Text('Galeri'),
                                  onPressed: () {
                                    Get.back();
                                    ambilFoto(ImageSource.gallery).then((
                                      value,
                                    ) {
                                      if (value != null) {
                                        setState(() {
                                          _image = value;
                                        });
                                      }
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Container(
                    width: 100,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child:
                        _isUpdate && _image == null
                            ? CachedNetworkImage(
                              imageUrl: _imageUrl,
                              fit: BoxFit.fill,
                              placeholder:
                                  (context, url) =>
                                      const CircularProgressIndicator(),
                              errorWidget:
                                  (context, url, error) =>
                                      const Icon(Icons.error),
                            )
                            : (_image == null
                                ? Icon(
                                  Icons.camera_alt,
                                  color: Colors.grey[700],
                                )
                                : Image.file(
                                  _image!,
                                  filterQuality: FilterQuality.high,
                                  fit: BoxFit.fill,
                                )),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _nopol,
                  readOnly: _isUpdate,
                  decoration: dekorasiInput(hint: 'Nomor Polisi'),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _merk,
                  hint: Text('Merk'),
                  onChanged: (String? newValue) {
                    setState(() {
                      _merk = newValue!;
                    });
                  },
                  items:
                      _merkList.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                  decoration: dekorasiInput(hint: 'Merk'),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _model,
                  hint: Text('Model'),
                  onChanged: (String? newValue) {
                    setState(() {
                      _model = newValue!;
                    });
                  },
                  items:
                      _modelList.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                  decoration: dekorasiInput(hint: 'Model'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _tahun,
                  decoration: dekorasiInput(hint: 'Tahun'),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
                const SizedBox(height: 10),
                Visibility(
                  visible: _isUpdate,
                  child: DropdownButtonFormField<String>(
                    value: _statusNotif,
                    hint: Text('Status Notifikasi'),
                    onChanged: (String? newValue) {
                      setState(() {
                        _statusNotif = newValue!;
                      });
                    },
                    items:
                        ['Aktif', 'Tidak Aktif'].map<DropdownMenuItem<String>>((
                          String value,
                        ) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                    decoration: dekorasiInput(hint: 'Status Notifikasi'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_nopol.text.isEmpty ||
              _merk == '- PILIH -' ||
              _model == '- PILIH -' ||
              _tahun.text.isEmpty) {
            Get.snackbar("Maaf", "Harap Lengkapi Data Anda");
          } else {
            if (_isUpdate == false && _image == null) {
              Get.snackbar("Maaf", "Harap Pilih Foto Kendaraan Anda");
            } else {
              showDialog(
                context: context,
                builder:
                    (c) => AlertDialog(
                      title: Text("Simpan Data Ini?"),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: Text("Batal"),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            Get.back();
                            sendData();
                          },
                          child: Text("Simpan"),
                        ),
                      ],
                    ),
              );
            }
          }
        },
        child: const Icon(Icons.save),
      ),
    );
  }

  void sendData() async {
    dio.FormData formData = dio.FormData.fromMap({
      "nopol": _nopol.text,
      "merk": _merk,
      "model": _model,
      "tahun": _tahun.text,
      "is_update": _isUpdate ? "1" : "0",
      "is_active": _statusNotif == "Aktif" ? "1" : "0",
      "created_by": Prefs.readString("username"),
      "foto":
          (_image == null
              ? null
              : await dio.MultipartFile.fromFile(
                _image!.path,
                filename: "foto.jpeg",
              )),
    });
    Api.postDataMultiPart(context, "kendaraan/register", formData).then((val) {
      Get.snackbar(
        val!.status!,
        val.message!,
        colorText: Colors.white,
        backgroundColor: Colors.red[900],
      );
      if (val.status == "success") {
        Get.offAll(() => VehicleList());
      }
    });
  }
}
