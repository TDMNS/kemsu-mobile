class CourseInfoOUPro {
  String? discName;
  String? discRep;
  String? discHours;
  String? fio;
  String? discFirstDate;
  String? discLastDate;
  int? discMark;
  int? courseId;

  CourseInfoOUPro(
      {this.discName,
      this.discRep,
      this.discHours,
      this.fio,
      this.discFirstDate,
      this.discLastDate,
      this.discMark,
      this.courseId});

  CourseInfoOUPro.fromJson(Map<String, dynamic> json) {
    discName = json["DISC_NAME"];
    discRep = json["DISC_REP"];
    discHours = json["DISC_HOURS"];
    fio = json["FIO"];
    discFirstDate = json["DISC_FIRST_DATE"];
    discLastDate = json["DISC_LAST_DATE"];
    discMark = json["DISC_MARK"];
    courseId = json["COURSE_ID"];
  }
}

class ReportInfoOUPro {
  int? repId;
  String? name;
  int? solveFlag;
  String? comments;
  String? repControlDate;
  int? maxBall;
  String? sumBall;

  List<TaskListInfoOUPro>? studentTaskList;

  ReportInfoOUPro(
      {this.repId,
      this.name,
      this.solveFlag,
      this.comments,
      this.repControlDate,
      this.maxBall,
      this.sumBall,
      this.studentTaskList});

  ReportInfoOUPro.fromJson(Map<String, dynamic> json) {
    repId = json["REP_ID"];
    name = json["NAME"];
    solveFlag = json["SOLVE_FLAG"];
    comments = json["COMMENTS"];
    if (json["REP_CONTROL_DATE"] == null) {
      repControlDate = "";
    } else {
      repControlDate = json["REP_CONTROL_DATE"];
    }
    maxBall = json["MAX_BALL"];
    if (json["SUM_BALL"] == null) {
      sumBall = "Отсутствует";
    } else {
      sumBall = json["SUM_BALL"].toString();
    }
    studentTaskList =
        json["STUDENT_TASK_LIST"].map<TaskListInfoOUPro>((json) => TaskListInfoOUPro.fromJson(json)).toList();
  }
}

class TaskListInfoOUPro {
  String? name;
  int? taskId;
  String? taskName;
  String? solveFlag;
  String? comments;
  String? taskControlDate;
  int? maxBall;
  String? sumBall;
  String? solutionStatus;
  String? solutionStatusShort;

  int? optionId;
  String? optionName;
  String? optionComments;
  String? optionSolutionStatus;

  TaskListInfoOUPro(
      {this.name,
      this.taskId,
      this.taskName,
      this.solveFlag,
      this.comments,
      this.taskControlDate,
      this.maxBall,
      this.sumBall,
      this.solutionStatus,
      this.solutionStatusShort,
      this.optionId,
      this.optionName,
      this.optionComments,
      this.optionSolutionStatus});

  TaskListInfoOUPro.fromJson(Map<String, dynamic> json) {
    taskId = json["TASK_ID"];
    taskName = json["TASK_NAME"];
    if (json["SOLVE_FLAG"] == 0) {
      solveFlag = "Нет";
    } else {
      solveFlag = "Да";
    }
    comments = json["COMMENTS"];
    if (json["TASK_CONTROL_DATE"] == null) {
      taskControlDate = "";
    } else {
      taskControlDate = json["TASK_CONTROL_DATE"];
    }
    maxBall = json["MAX_BALL"];
    if (json["SUM_BALL"] == null) {
      sumBall = "";
    } else {
      sumBall = json["SUM_BALL"].toString();
    }
    if (json["STUDENT_OPTION_LIST"].length == 0) {
      solutionStatus = json["SOLUTION_STATUS"];
      solutionStatusShort = json["SOLUTION_STATUS_SHORT"];
      optionId = 0;
      optionName = "";
      optionSolutionStatus = "";
      optionComments = "";
    } else {
      var option = json["STUDENT_OPTION_LIST"][0];
      optionId = option["OPTION_ID"];
      optionName = option["OPTION_NAME"];
      optionSolutionStatus = option["SOLUTION_STATUS"];
      solutionStatusShort = option["SOLUTION_STATUS_SHORT"];
      optionComments = option["COMMENTS"];
      solutionStatus = "";
    }
    name = taskName;
    if (optionName != "") name = name.toString() + ".\n" + optionName.toString();
  }
}
