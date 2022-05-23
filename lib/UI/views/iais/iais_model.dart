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
      {this.DISC_NAME, this.DISC_REP, this.DISC_HOURS, this.FIO, this.DISC_FIRST_DATE, this.DISC_LAST_DATE, this.DISC_MARK, this.COURSE_ID});

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
  int? SUM_BALL;

  List<TaskListIais>? STUDENT_TASK_LIST;

  ReportIais(
      {this.REP_ID, this.NAME, this.SOLVE_FLAG, this.COMMENTS, this.REP_CONTROL_DATE, this.MAX_BALL, this.SUM_BALL, this.STUDENT_TASK_LIST});

  ReportIais.fromJson(Map<String, dynamic> json) {
    REP_ID = json["REP_ID"];
    NAME = json["NAME"];
    SOLVE_FLAG = json["SOLVE_FLAG"];
    COMMENTS = json["COMMENTS"];
    REP_CONTROL_DATE = json["REP_CONTROL_DATE"];
    MAX_BALL = json["MAX_BALL"];
    SUM_BALL = json["SUM_BALL"];
    STUDENT_TASK_LIST =
        json["STUDENT_TASK_LIST"]
            .map<TaskListIais>((json) => TaskListIais.fromJson(json))
            .toList();
  }
}

class TaskListIais {
  int? TASK_ID;
  String? TASK_NAME;
  int? SOLVE_FLAG;
  String? COMMENTS;
  String? TASK_CONTROL_DATE;
  int? MAX_BALL;
  int? SUM_BALL;
  String? SOLUTION_STATUS;
  String? SOLUTION_STATUS_SHORT;

  List<TaskOptionListIais>? STUDENT_OPTION_LIST;

  TaskListIais(
      {this.TASK_ID, this.TASK_NAME, this.SOLVE_FLAG, this.COMMENTS, this.TASK_CONTROL_DATE, this.MAX_BALL, this.SUM_BALL, this.SOLUTION_STATUS, this.SOLUTION_STATUS_SHORT, this.STUDENT_OPTION_LIST});

  TaskListIais.fromJson(Map<String, dynamic> json) {
    TASK_ID = json["TASK_ID"];
    TASK_NAME = json["TASK_NAME"];
    SOLVE_FLAG = json["SOLVE_FLAG"];
    COMMENTS = json["COMMENTS"];
    TASK_CONTROL_DATE = json["TASK_CONTROL_DATE"];
    MAX_BALL = json["MAX_BALL"];
    SUM_BALL = json["SUM_BALL"];
    SOLUTION_STATUS = json["SOLUTION_STATUS"];
    STUDENT_OPTION_LIST =
        json["STUDENT_OPTION_LIST"]
            .map<TaskOptionListIais>((json) => TaskOptionListIais.fromJson(json))
            .toList();
    SOLUTION_STATUS_SHORT = json["SOLUTION_STATUS_SHORT"];
  }
}

class TaskOptionListIais {
  int? OPTION_ID;
  String? OPTION_NAME;
  String? COMMENTS;
  String? SOLUTION_STATUS;
  String? SOLUTION_STATUS_SHORT;

  TaskOptionListIais(
      {this.OPTION_ID, this.OPTION_NAME, this.COMMENTS, this.SOLUTION_STATUS, this.SOLUTION_STATUS_SHORT});

  TaskOptionListIais.fromJson(Map<String, dynamic> json) {
    OPTION_ID = json["OPTION_ID"];
    OPTION_NAME = json["OPTION_NAME"];
    SOLUTION_STATUS = json["SOLUTION_STATUS"];
    SOLUTION_STATUS_SHORT = json["SOLUTION_STATUS_SHORT"];
    COMMENTS = json["COMMENTS"];
  }
}