import 'package:flutter_expense_app/models/expense.dart';
import 'package:flutter_expense_app/services/db_service.dart';
import 'package:flutter_expense_app/utils/global_functions.dart';
import 'package:get/get.dart';
import "package:collection/collection.dart";
import 'package:intl/intl.dart';

class ExpenseListController extends GetxController {
  DBService dbService = DBService.instance;
  bool showChart = true;
  bool showList = true;
  bool isLoading = false;
  List<Expense> listExpense = [];
  Map<String, dynamic> expenseData = {};

  List<Expense> get _weekExpenses {
    return listExpense.where((tx) {
      String date = DateTime.now().toString();
      String firstDay = '${date.substring(0, 8)}01${date.substring(10)}';

      int weekDay = DateTime.parse(firstDay).weekday;

      int selisih = (7 - weekDay) + 1;

      DateTime todayDate = DateTime.now();

      weekDay--;
      int weekOfMonth = ((todayDate.day + weekDay) / 7).ceil();
      int firstMondayWeek =
          (weekOfMonth - 1) * (selisih + 1) + (weekOfMonth - 2);

      return tx.date.isAfter(
            DateTime.now().subtract(
              Duration(days: todayDate.day - firstMondayWeek + 1),
            ),
          ) &&
          tx.date.month == DateTime.now().month;
    }).toList();
  }

  Map<String, dynamic> totalSpending() {
    List<Expense> yearExpense = listExpense
        .where((element) => element.date.year == DateTime.now().year)
        .toList();
    double totalSpendingYear =
        yearExpense.fold(0.0, (sum, item) => sum + item.amount);
    List<Expense> lastMonthExpense = listExpense
        .where((element) =>
            element.date.month == DateTime.now().month - 1 &&
            element.date.year == DateTime.now().year)
        .toList();
    double totalSpendingLastMonth =
        lastMonthExpense.fold(0.0, (sum, item) => sum + item.amount);
    List<Expense> monthExpense = listExpense
        .where((element) =>
            element.date.month == DateTime.now().month &&
            element.date.year == DateTime.now().year)
        .toList();
    double totalSpendingMonth =
        monthExpense.fold(0.0, (sum, item) => sum + item.amount);
    List<Expense> todayExpense = listExpense
        .where((element) =>
            element.date.day == DateTime.now().day &&
            element.date.month == DateTime.now().month &&
            element.date.year == DateTime.now().year)
        .toList();
    double totalSpendingToday =
        todayExpense.fold(0.0, (sum, item) => sum + item.amount);
    double totalSpendingWeek =
        _weekExpenses.fold(0.0, (sum, item) => sum + item.amount);
    return {
      "today": totalSpendingToday,
      "week": totalSpendingWeek,
      "month": totalSpendingMonth,
      "lastMonth": totalSpendingLastMonth,
      "year": totalSpendingYear
    };
  }

  void listData() async {
    isLoading = true;
    update();
    listExpense = await dbService.fetchListData();
    isLoading = false;
    groupByDate();
    update();
  }

  double sumTotalperDay(List<Expense> data) {
    return data.fold(0.0, (sum, item) => sum + item.amount);
  }

  void groupByDate() {
    Map<String, dynamic> newMap = groupBy(listExpense,
        (Expense obj) => DateFormat("dd-MM-yyyy").format(obj.date)).map((k, v) {
      //var newKey = DateFormat("dd-MM-yyyy").format(k);
      return MapEntry(
        k,
        v.map(
          (item) {
            return item;
          },
        ).toList(),
      );
    });
    Map<String, dynamic> sortedByKeyMap = Map.fromEntries(
        newMap.entries.toList()
          ..sort((e1, e2) =>
              stringToDateTime(e2.key).compareTo(stringToDateTime(e1.key))));
    expenseData = sortedByKeyMap;
  }

  void deleteData(String id) async {
    await dbService.deleteData(id);
    listData();
    update();
  }
}
