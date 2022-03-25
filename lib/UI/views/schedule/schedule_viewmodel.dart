import 'package:flutter/cupertino.dart';
import 'package:stacked/stacked.dart';

class ScheduleViewModel extends BaseViewModel {
  ScheduleViewModel(BuildContext context);

  Future onReady() async {}
  String dropdownValue = 'Выбор семестра';
  String dropdownValue2 = 'Выбор института';
  String dropdownValue3 = 'Выбор группы';

  int selectedIndex = 1;

  void onTapBottomBar(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  void newDropDownValue(newValue) {
    dropdownValue = newValue;
    notifyListeners();
  }

  void newDropDownValue2(newValue) {
    dropdownValue = newValue;
    notifyListeners();
  }

  void newDropDownValue3(newValue) {
    dropdownValue = newValue;
    notifyListeners();
  }
}
