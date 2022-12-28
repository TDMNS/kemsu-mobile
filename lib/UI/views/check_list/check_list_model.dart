class CheckList {
  String? groupName;
  String? departmentTitle;
  String? debt;
  String? commentary;
  String? address;

  CheckList({
    this.groupName,
    this.departmentTitle,
    this.debt,
    this.commentary,
    this.address
  });

  CheckList.fromJson(Map<String, dynamic> json) {
    groupName = json["groupName"];
    departmentTitle = json["departmentTitle"];
    if (json["commentary"] != null) {
      commentary = json["commentary"];
    } else {
      commentary = "";
    }
    debt="";
    if (json["noDebtFlag"] == 1) debt = "Нет";
    if (json["debtFlag"] == 1) debt = "Есть";
    address = json["address"];
  }
}