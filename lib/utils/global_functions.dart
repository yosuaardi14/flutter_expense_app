import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<bool> showConfirmationDialog(String title, String content) async {
  return await showDialog(
    barrierDismissible: false,
    context: Get.context!,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(Get.context!, false);
            },
            child: const Text("Tidak")),
        const SizedBox(width: 20),
        TextButton(
            onPressed: () {
              Navigator.pop(Get.context!, true);
            },
            child: const Text("Ya")),
      ],
    ),
  );
}

Future<bool> showConfirmationDeleteDialog() async {
  return await showConfirmationDialog(
      "Konfirmasi Hapus", "Apa Anda yakin ingin menghapus ini?");
}

Future<bool> showConfirmationAddDialog() async {
  return await showConfirmationDialog(
      "Konfirmasi Tambah", "Apa Anda yakin ingin menambah ini?");
}

DateTime stringToDateTime(String date){
  String day = date.split("-")[0];
  String month = date.split("-")[1];
  String year = date.split("-")[2];
  return DateTime.parse("$year-$month-$day");
}
