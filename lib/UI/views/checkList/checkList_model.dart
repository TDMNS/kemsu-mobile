class CheckList {
  String? groupName;
  String? departmentTitle;
  String? debt;
  String? comment;

  CheckList(
      {this.groupName, this.departmentTitle, this.debt, this.comment});

  CheckList.fromJson(Map<String, dynamic> json) {
    groupName = json["groupName"];
    departmentTitle = json["departmentTitle"];
    if(json["commentary"]!=null) {
      comment = json["commentary"];
    } else {
      comment = "";
    }
    debt="";
    if(json["noDebtFlag"]==1) debt="Нет";
    if(json["debtFlag"]==1) debt="Есть";
  }
}