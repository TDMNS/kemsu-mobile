import 'package:intl/intl.dart';

class PayDebts {
  int? amount;
  DateTime? date;

  PayDebts({this.amount, this.date});

  factory PayDebts.fromJson(Map<String, dynamic> json) {
    int? parsedAmount = json['DEBT_AMOUNT'];
    DateTime? parsedDate;
    parsedDate = DateFormat('dd.MM.yyyy').parse(json['DEBT_DATE']);

    return PayDebts(
      amount: parsedAmount,
      date: parsedDate,
    );
  }
}
