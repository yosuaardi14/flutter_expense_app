class Expense {
  String id;
  String title;
  double amount;
  DateTime date;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
  });

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map["id"],
      amount: map["amount"],
      title: map["title"],
      date: DateTime.parse(map["date"]),
    );
  }
}
