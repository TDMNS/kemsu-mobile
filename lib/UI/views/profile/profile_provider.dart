import 'package:flutter/cupertino.dart';

class UserProfileProvider with ChangeNotifier {
  String _email = '';
  String _phone = '';

  String get email => _email;
  String get phone => _phone;

  void updateEmail(String newEmail) {
    _email = newEmail;
    notifyListeners();
  }

  void updatePhone(String newPhone) {
    _phone = newPhone;
    notifyListeners();
  }
}