class CourseIais {
  String? DISC_NAME;
  String? DISC_REP; //отчётность
  String? DISC_HOURS;
  String? FIO;
  String? DISC_FIRST_DATE;
  String? DISC_LAST_DATE;
  int? DISC_MARK;
  int? COURSE_ID;

  CourseIais(
      {this.DISC_NAME,
      this.DISC_REP,
      this.DISC_HOURS,
      this.FIO,
      this.DISC_FIRST_DATE,
      this.DISC_LAST_DATE,
      this.DISC_MARK,
      this.COURSE_ID});

  CourseIais.fromJson(Map<String, dynamic> json) {
    DISC_NAME = json["DISC_NAME"];
    DISC_REP = json["DISC_REP"];
    DISC_HOURS = json["DISC_HOURS"];
    FIO = json["FIO"];
    DISC_FIRST_DATE = json["DISC_FIRST_DATE"];
    DISC_LAST_DATE = json["DISC_LAST_DATE"];
    DISC_MARK = json["DISC_MARK"];
    COURSE_ID = json["COURSE_ID"];
  }
}

class ReportIais {
  int? REP_ID;
  String? NAME;
  int? SOLVE_FLAG;
  String? COMMENTS;
  String? REP_CONTROL_DATE;
  int? MAX_BALL;
  String? SUM_BALL;

  List<TaskListIais>? STUDENT_TASK_LIST;

  ReportIais(
      {this.REP_ID,
      this.NAME,
      this.SOLVE_FLAG,
      this.COMMENTS,
      this.REP_CONTROL_DATE,
      this.MAX_BALL,
      this.SUM_BALL,
      this.STUDENT_TASK_LIST});

  ReportIais.fromJson(Map<String, dynamic> json) {
    REP_ID = json["REP_ID"];
    NAME = json["NAME"];
    SOLVE_FLAG = json["SOLVE_FLAG"];
    COMMENTS = json["COMMENTS"];
    if (json["REP_CONTROL_DATE"] == null)
      REP_CONTROL_DATE = "";
    else
      REP_CONTROL_DATE = json["REP_CONTROL_DATE"];
    MAX_BALL = json["MAX_BALL"];
    if (json["SUM_BALL"] == null)
      SUM_BALL = "";
    else
      SUM_BALL = json["SUM_BALL"].toString();
    print(SUM_BALL);
    STUDENT_TASK_LIST = json["STUDENT_TASK_LIST"].map<TaskListIais>((json) => TaskListIais.fromJson(json)).toList();
  }
}

class TaskListIais {
  String? NAME;
  int? TASK_ID;
  String? TASK_NAME;
  String? SOLVE_FLAG;
  String? COMMENTS;
  String? TASK_CONTROL_DATE;
  int? MAX_BALL;
  String? SUM_BALL;
  String? SOLUTION_STATUS;
  String? SOLUTION_STATUS_SHORT;

  int? OPTION_ID;
  String? OPTION_NAME;
  String? OPTION_COMMENTS;
  String? OPTION_SOLUTION_STATUS;

  TaskListIais(
      {this.NAME,
      this.TASK_ID,
      this.TASK_NAME,
      this.SOLVE_FLAG,
      this.COMMENTS,
      this.TASK_CONTROL_DATE,
      this.MAX_BALL,
      this.SUM_BALL,
      this.SOLUTION_STATUS,
      this.SOLUTION_STATUS_SHORT,
      this.OPTION_ID,
      this.OPTION_NAME,
      this.OPTION_COMMENTS,
      this.OPTION_SOLUTION_STATUS});

  TaskListIais.fromJson(Map<String, dynamic> json) {
    TASK_ID = json["TASK_ID"];
    TASK_NAME = json["TASK_NAME"];
    if (json["SOLVE_FLAG"] == 0)
      SOLVE_FLAG = "Нет";
    else
      SOLVE_FLAG = "Да";
    COMMENTS = json["COMMENTS"];
    if (json["TASK_CONTROL_DATE"] == null)
      TASK_CONTROL_DATE = "";
    else
      TASK_CONTROL_DATE = json["TASK_CONTROL_DATE"];
    MAX_BALL = json["MAX_BALL"];
    if (json["SUM_BALL"] == null)
      SUM_BALL = "";
    else
      SUM_BALL = json["SUM_BALL"].toString();
    if (json["STUDENT_OPTION_LIST"].length == 0) {
      SOLUTION_STATUS = json["SOLUTION_STATUS"];
      SOLUTION_STATUS_SHORT = json["SOLUTION_STATUS_SHORT"];
      OPTION_ID = 0;
      OPTION_NAME = "";
      OPTION_SOLUTION_STATUS = "";
      OPTION_COMMENTS = "";
    } else {
      var option = json["STUDENT_OPTION_LIST"][0];
      OPTION_ID = option["OPTION_ID"];
      OPTION_NAME = option["OPTION_NAME"];
      OPTION_SOLUTION_STATUS = option["SOLUTION_STATUS"];
      SOLUTION_STATUS_SHORT = option["SOLUTION_STATUS_SHORT"];
      OPTION_COMMENTS = option["COMMENTS"];
      SOLUTION_STATUS = "";
    }
    NAME = TASK_NAME;
    if (OPTION_NAME != "") NAME = NAME.toString() + ".\n" + OPTION_NAME.toString();
  }
}
