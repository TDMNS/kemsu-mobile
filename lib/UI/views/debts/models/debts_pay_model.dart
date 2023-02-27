class PayDebts {
  String? amount;
  String? date;

  PayDebts({this.amount, this.date});

  PayDebts.fromJson(Map<String, dynamic> json) {
    amount = json["DEBT_AMOUNT"];
    date = json["DEBT_DATE"];
  }
}
