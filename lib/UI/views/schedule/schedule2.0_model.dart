class FinalTable {
  WeekDay? weekDay1;
  WeekDay? weekDay2;
  WeekDay? weekDay3;
  WeekDay? weekDay4;
  WeekDay? weekDay5;
  WeekDay? weekDay6;

  FinalTable(
      {this.weekDay1,
      this.weekDay2,
      this.weekDay3,
      this.weekDay4,
      this.weekDay5,
      this.weekDay6});

  factory FinalTable.fromJson(Map<String, dynamic> json) {
    return FinalTable(
        weekDay1: WeekDay.fromJson(json['weekDay1']),
        weekDay2: WeekDay.fromJson(json['weekDay2']),
        weekDay3: WeekDay.fromJson(json['weekDay3']),
        weekDay4: WeekDay.fromJson(json['weekDay4']),
        weekDay5: WeekDay.fromJson(json['weekDay5']),
        weekDay6: WeekDay.fromJson(json['weekDay6']));
  }
}

class WeekDay {
  List<CoupleData>? coupleAll1;
  List<CoupleData>? coupleAll2;
  List<CoupleData>? coupleAll3;
  List<CoupleData>? coupleAll4;
  List<CoupleData>? coupleAll5;
  List<CoupleData>? coupleAll6;
  List<CoupleData>? coupleAll7;
  List<CoupleData>? coupleEven1;
  List<CoupleData>? coupleEven2;
  List<CoupleData>? coupleEven3;
  List<CoupleData>? coupleEven4;
  List<CoupleData>? coupleEven5;
  List<CoupleData>? coupleEven6;
  List<CoupleData>? coupleEven7;
  List<CoupleData>? coupleOdd1;
  List<CoupleData>? coupleOdd2;
  List<CoupleData>? coupleOdd3;
  List<CoupleData>? coupleOdd4;
  List<CoupleData>? coupleOdd5;
  List<CoupleData>? coupleOdd6;
  List<CoupleData>? coupleOdd7;

  WeekDay(
      {this.coupleAll1,
      this.coupleAll2,
      this.coupleAll3,
      this.coupleAll4,
      this.coupleAll5,
      this.coupleAll6,
      this.coupleAll7,
      this.coupleEven1,
      this.coupleEven2,
      this.coupleEven3,
      this.coupleEven4,
      this.coupleEven5,
      this.coupleEven6,
      this.coupleEven7,
      this.coupleOdd1,
      this.coupleOdd2,
      this.coupleOdd3,
      this.coupleOdd4,
      this.coupleOdd5,
      this.coupleOdd6,
      this.coupleOdd7});

  factory WeekDay.fromJson(Map<String, dynamic> json) {
    var list1 = json['coupleAll1'] as List;
    var list2 = json['coupleAll2'] as List;
    var list3 = json['coupleAll3'] as List;
    var list4 = json['coupleAll4'] as List;
    var list5 = json['coupleAll5'] as List;
    var list6 = json['coupleAll6'] as List;
    var list7 = json['coupleAll7'] as List;
    var list8 = json['coupleEven1'] as List;
    var list9 = json['coupleEven2'] as List;
    var list10 = json['coupleEven3'] as List;
    var list11 = json['coupleEven4'] as List;
    var list12 = json['coupleEven5'] as List;
    var list13 = json['coupleEven6'] as List;
    var list14 = json['coupleEven7'] as List;
    var list15 = json['coupleOdd1'] as List;
    var list16 = json['coupleOdd2'] as List;
    var list17 = json['coupleOdd3'] as List;
    var list18 = json['coupleOdd4'] as List;
    var list19 = json['coupleOdd5'] as List;
    var list20 = json['coupleOdd6'] as List;
    var list21 = json['coupleOdd7'] as List;
    List<CoupleData> data1 = list1.map((i) => CoupleData.fromJson(i)).toList();
    List<CoupleData> data2 = list2.map((i) => CoupleData.fromJson(i)).toList();
    List<CoupleData> data3 = list3.map((i) => CoupleData.fromJson(i)).toList();
    List<CoupleData> data4 = list4.map((i) => CoupleData.fromJson(i)).toList();
    List<CoupleData> data5 = list5.map((i) => CoupleData.fromJson(i)).toList();
    List<CoupleData> data6 = list6.map((i) => CoupleData.fromJson(i)).toList();
    List<CoupleData> data7 = list7.map((i) => CoupleData.fromJson(i)).toList();
    List<CoupleData> data8 = list8.map((i) => CoupleData.fromJson(i)).toList();
    List<CoupleData> data9 = list9.map((i) => CoupleData.fromJson(i)).toList();
    List<CoupleData> data10 =
        list10.map((i) => CoupleData.fromJson(i)).toList();
    List<CoupleData> data11 =
        list11.map((i) => CoupleData.fromJson(i)).toList();
    List<CoupleData> data12 =
        list12.map((i) => CoupleData.fromJson(i)).toList();
    List<CoupleData> data13 =
        list13.map((i) => CoupleData.fromJson(i)).toList();
    List<CoupleData> data14 =
        list14.map((i) => CoupleData.fromJson(i)).toList();
    List<CoupleData> data15 =
        list15.map((i) => CoupleData.fromJson(i)).toList();
    List<CoupleData> data16 =
        list16.map((i) => CoupleData.fromJson(i)).toList();
    List<CoupleData> data17 =
        list17.map((i) => CoupleData.fromJson(i)).toList();
    List<CoupleData> data18 =
        list18.map((i) => CoupleData.fromJson(i)).toList();
    List<CoupleData> data19 =
        list19.map((i) => CoupleData.fromJson(i)).toList();
    List<CoupleData> data20 =
        list20.map((i) => CoupleData.fromJson(i)).toList();
    List<CoupleData> data21 =
        list21.map((i) => CoupleData.fromJson(i)).toList();

    return WeekDay(
        coupleAll1: data1,
        coupleAll2: data2,
        coupleAll3: data3,
        coupleAll4: data4,
        coupleAll5: data5,
        coupleAll6: data6,
        coupleAll7: data7,
        coupleEven1: data8,
        coupleEven2: data9,
        coupleEven3: data10,
        coupleEven4: data11,
        coupleEven5: data12,
        coupleEven6: data13,
        coupleEven7: data14,
        coupleOdd1: data15,
        coupleOdd2: data16,
        coupleOdd3: data17,
        coupleOdd4: data18,
        coupleOdd5: data19,
        coupleOdd6: data20,
        coupleOdd7: data21);
  }
}

class CoupleData {
  String? discName;
  String? prepName;
  String? auditoryName;
  String? lessonType;
  int? loadDiscpId;
  String? periodTypeName;
  int? periodTypeId;
  int? maxWeekNum;
  int? minWeekNum;
  int? selectFlag;
  String? periodTypePref;
  int? loadFlag;
  int? scheduleId;

  CoupleData(
      {this.discName,
      this.prepName,
      this.auditoryName,
      this.lessonType,
      this.loadDiscpId,
      this.periodTypeName,
      this.periodTypeId,
      this.maxWeekNum,
      this.minWeekNum,
      this.selectFlag,
      this.periodTypePref,
      this.loadFlag,
      this.scheduleId});

  factory CoupleData.fromJson(Map<String, dynamic> json) {
    return CoupleData(
      discName: json['DiscName'],
      prepName: json['PrepName'],
      auditoryName: json['AuditoryName'],
      lessonType: json['lessonType'],
      loadDiscpId: json['loadDiscipId'],
      periodTypeName: json['periodTypeName'],
      periodTypeId: json['PeriodTypeId'],
      maxWeekNum: json['maxWeekNum'],
      minWeekNum: json['minWeekNum'],
      selectFlag: json['selectFlag'],
      periodTypePref: json['periodTypePref'],
      loadFlag: json['loadFlag'],
      scheduleId: json['scheduleId'],
    );
  }
}
