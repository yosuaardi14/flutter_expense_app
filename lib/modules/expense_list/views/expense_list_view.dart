import 'package:flutter/material.dart';
import 'package:flutter_expense_app/models/expense.dart';
import 'package:flutter_expense_app/modules/expense_add/controllers/expense_add_controller.dart';
import 'package:flutter_expense_app/modules/expense_add/views/expense_add_view.dart';
import 'package:flutter_expense_app/utils/global_functions.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/expense_list_controller.dart';

class ExpenseListView extends GetView<ExpenseListController> {
  String rupiahFormat(double amount) {
    return NumberFormat.currency(locale: "id", decimalDigits: 0, symbol: "Rp ")
        .format(amount);
  }

  void displayChart() {
    controller.showChart = !controller.showChart;
    controller.update();
  }

  void displayList() {
    controller.showList = !controller.showList;
    controller.update();
  }

  void addExpense() {
    Get.put(ExpenseAddController());
    Get.bottomSheet(
      ExpenseAddView(),
    ).then((value) {
      controller.listData();
    });
  }

  Widget expansionData(String date, List<Expense> data) {
    return Card(
      elevation: 3,
      child: ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(date),
            Text(rupiahFormat(controller.sumTotalperDay(data))),
            // Chip(label: Text(rupiahFormat(controller.sumTotalperDay(data)))),
          ],
        ),
        children: [
          const Divider(color: Colors.black),
          ...data.map((e) => itemData(e)).toList(),
          //itemData(data)
          // const Divider(color: Colors.black),
          // totalExpenseDate,
          // addBtn,
        ],
      ),
    );
  }

  Widget itemData(Expense data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(data.title)),
          Chip(label: Text(rupiahFormat(data.amount))),
          IconButton(
            onPressed: () async {
              bool hapus = await showConfirmationDeleteDialog();
              if (hapus) {
                controller.deleteData(data.id);
              }
            },
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget fab = FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: addExpense,
    );

    Widget filterButton = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          Expanded(
            // flex: 3,
            child: SizedBox(
              height: 40,
              child: ElevatedButton(
                onPressed: () {},
                child: Text("Sembunyikan Dashboard"),
              ),
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            // flex: 2,
            child: SizedBox(
              height: 40,
              child: ElevatedButton(
                onPressed: () {},
                child: Text("Sembunyikan List"),
              ),
            ),
          )
        ],
      ),
    );

    Widget filterDropdown = Padding(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: DropdownButtonFormField<String>(
        items: [
          DropdownMenuItem(
            child: Text("All"),
            value: "all",
          ),
          DropdownMenuItem(
            child: Text("Januari"),
            value: "jan",
          ),
        ],
        onChanged: (val) {},
        decoration: InputDecoration(
          isDense: true,
          border: OutlineInputBorder(),
        ),
      ),
    );

    Widget dashboard = Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: GetBuilder<ExpenseListController>(
          builder: (c) => Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Hari ini: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(rupiahFormat(controller.totalSpending()["today"])),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Minggu ini: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(rupiahFormat(controller.totalSpending()["week"])),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Bulan ini: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(rupiahFormat(controller.totalSpending()["month"])),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Bulan lalu: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(rupiahFormat(controller.totalSpending()["lastMonth"])),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Tahun ini: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(rupiahFormat(controller.totalSpending()["year"])),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    Widget item = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text("Makan Pagi Siang Malam")),
          Text("Rp 100.000"),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.delete,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );

    // Widget addBtn = ElevatedButton(
    //   onPressed: () {},
    //   child: Text("Tambah"),
    // );

    // Widget totalExpenseDate = Padding(
    //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
    //   child: Row(
    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //     children: [
    //       Expanded(child: SizedBox()),
    //       // Expanded(child: Text("Total")),
    //       Text("Total"),
    //       const SizedBox(width: 48),
    //       Text("Rp 1.309.000"),
    //       const SizedBox(width: 48),
    //     ],
    //   ),
    // );

    Widget listItem = GetBuilder<ExpenseListController>(
      init: controller..listData(),
      builder: (c) => Expanded(
        child: ListView(
          children: c.isLoading
              ? [const CircularProgressIndicator()]
              : [
                  ...controller.expenseData.entries
                      .map(
                        (e) => expansionData(e.key, e.value),
                      )
                      .toList(),
                ],
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense App'),
        centerTitle: true,
      ),
      floatingActionButton: fab,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: RefreshIndicator(
        onRefresh: () async => controller.listData(),
        child: Column(children: [
          // filterButton,
          dashboard,
          // filterDropdown,
          listItem,
          //const SizedBox(height: 75),
        ]),
      ),
    );
  }
}
