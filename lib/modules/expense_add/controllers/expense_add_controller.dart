import 'package:flutter/material.dart';
import 'package:flutter_expense_app/services/db_service.dart';
import 'package:get/get.dart';

class ExpenseAddController extends GetxController {
  DBService dbService = DBService.instance;

  TextEditingController titleController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  void insertData() async {
    Map<String, dynamic> data = {
      "title": titleController.text,
      "amount": amountController.text,
      "date": selectedDate.toString(),
      "id": DateTime.now().toString(),
    };
    await dbService.insertData(data);
    // print(data);
    titleController.clear();
    amountController.clear();
    selectedDate = DateTime.now();
    update();
  }
}
