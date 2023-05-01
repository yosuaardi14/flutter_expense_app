import 'package:get/get.dart';

import '../modules/expense_add/bindings/expense_add_binding.dart';
import '../modules/expense_add/views/expense_add_view.dart';
import '../modules/expense_list/bindings/expense_list_binding.dart';
import '../modules/expense_list/views/expense_list_view.dart';


part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.EXPENSE_LIST;

  static final routes = [
    GetPage(
      name: _Paths.EXPENSE_LIST,
      page: () => ExpenseListView(),
      binding: ExpenseListBinding(),
    ),
    GetPage(
      name: _Paths.EXPENSE_ADD,
      page: () => ExpenseAddView(),
      binding: ExpenseAddBinding(),
    ),
  ];
}
