class CheckList {
  String? GROUPNAME;
  String? DEPARTMENTTITLE;
  String? DEBT;
  String? COMMENTARY;

  CheckList(
      {this.GROUPNAME, this.DEPARTMENTTITLE, this.DEBT, this.COMMENTARY});

  CheckList.fromJson(Map<String, dynamic> json) {
    GROUPNAME = json["groupName"];
    DEPARTMENTTITLE = json["departmentTitle"];
    if(json["commentary"]!=null) COMMENTARY = json["commentary"];
    else COMMENTARY = "";
    DEBT="";
    if(json["noDebtFlag"]==1) DEBT="Нет";
    if(json["DebtFlag"]==1) DEBT="Есть";
  }
}