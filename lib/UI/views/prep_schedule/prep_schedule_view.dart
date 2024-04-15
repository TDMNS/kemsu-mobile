import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kemsu_app/UI/views/prep_schedule/prep_schedule_view_model.dart';

import 'package:stacked/stacked.dart';

import '../../../Configurations/localizable.dart';
import '../../common_views/main_button.dart';
import '../../common_widgets.dart';

List<DropdownMenuItem<String>> dropdownItems = [];

class PrepScheduleView extends StatefulWidget {
  const PrepScheduleView({super.key});

  @override
  State<PrepScheduleView> createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<PrepScheduleView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PrepScheduleViewModel>.reactive(
        onViewModelReady: (viewModel) => viewModel.onReady(),
        viewModelBuilder: () => PrepScheduleViewModel(context),
        builder: (context, model, child) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
              value: const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.dark),
              child: GestureDetector(
                onTap: () {
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                },
                child: model.circle
                    ? Container(
                        color: Theme.of(context).primaryColor,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Colors.blue,
                            backgroundColor: Colors.white,
                          ),
                        ),
                      )
                    : Scaffold(extendBody: true, extendBodyBehindAppBar: true, appBar: customAppBar(context, model.appBarTitle), body: _prepSchedule(context, model)),
              ));
        });
  }
}

_prepSchedule(BuildContext context, PrepScheduleViewModel model) {
  dropdownItems = List.generate(
    model.teacherList.length,
    (index) => DropdownMenuItem(
      value: model.teacherList[index].prepId.toString(),
      child: Text(
        model.teacherList[index].fio,
      ),
    ),
  );
  return ListView(
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
        child: DropdownSearch<dynamic>(
          popupProps: const PopupProps.menu(showSearchBox: true),
          dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
            labelText: Localizable.prepScheduleChooseTeacher,
            labelStyle: TextStyle(
              color: Color(Theme.of(context).primaryColorDark.value),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.blue,
              ),
            ),
          )),
          items: model.teacherList.map((e) => e.fio).toList(),
          onChanged: (value) => {model.changeTeacher(value)},
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 15),
        child: mainButton(
          context,
          onPressed: () {
            model.getTeacher();
            model.changeTeacher("");
            model.notifyListeners();
          },
          title: Localizable.mainReset,
          isPrimary: false,
        ),
      ),
      model.teacherId != 0
          ? Center(
              child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: GestureDetector(
                onTap: () {},
                child: Text('${model.teacherFIO}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ),
            ))
          : const SizedBox(),
      Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: model.teacherId == 0
              ? const SizedBox()
              : Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                          onPressed: () {
                            model.choiceDay('back');
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            size: 20,
                          )),
                      model.indexDay == 1
                          ? Text(
                              Localizable.monday,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            )
                          : const Text(''),
                      model.indexDay == 2
                          ? Text(
                              Localizable.tuesday,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            )
                          : const Text(''),
                      model.indexDay == 3
                          ? Text(
                              Localizable.wednesday,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            )
                          : const Text(''),
                      model.indexDay == 4
                          ? Text(
                              Localizable.thursday,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            )
                          : const Text(''),
                      model.indexDay == 5
                          ? Text(
                              Localizable.friday,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            )
                          : const Text(''),
                      model.indexDay == 6
                          ? Text(
                              Localizable.saturday,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            )
                          : const Text(''),
                      IconButton(
                          onPressed: () {
                            model.choiceDay('next');
                          },
                          icon: const Icon(
                            Icons.arrow_forward_ios,
                            size: 20,
                          )),
                    ],
                  ),
                )),
      model.teacherId == 0
          ? const SizedBox()
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  Localizable.week,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(25), color: Colors.grey.withOpacity(0.5)),
                  child: Text(
                    '${model.weekNumApi}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  ' ${model.weekTypeApi} ',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
      model.teacherId == 0
          ? const SizedBox()
          : Stack(
              children: [
                ListTile(
                  title: Text(Localizable.even),
                  leading: Radio(
                    value: true,
                    groupValue: model.weekType,
                    onChanged: (value) {
                      model.changeWeek(value);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.width / 2),
                  child: ListTile(
                    title: Text(Localizable.odd),
                    leading: Radio(
                      value: false,
                      groupValue: model.weekType,
                      onChanged: (value) {
                        model.changeWeek(value);
                      },
                    ),
                  ),
                )
              ],
            ),
      Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: model.teacherId == 0
            ? const SizedBox()
            : model.circle
                ? Container(
                    color: Colors.white,
                    child: const Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.white,
                      ),
                    ),
                  )
                : _choiceDay(model, context),
      ),
      const SizedBox(
        height: 50,
      ),
    ],
  );
}

_choiceDay(model, context) {
  if (model.indexDay == 1) {
    return _scheduleTable(model, context, 0);
  } else if (model.indexDay == 2) {
    return _scheduleTable(model, context, 1);
  } else if (model.indexDay == 3) {
    return _scheduleTable(model, context, 2);
  } else if (model.indexDay == 4) {
    return _scheduleTable(model, context, 3);
  } else if (model.indexDay == 5) {
    return _scheduleTable(model, context, 4);
  } else if (model.indexDay == 6) {
    return _scheduleTable(model, context, 5);
  }
}

_scheduleTable(PrepScheduleViewModel model, context, dayIndex) {
  return model.circle
      ? Container(
          color: Colors.white,
          child: const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.white,
            ),
          ),
        )
      : Dismissible(
          key: Key("${model.indexDay}"),
          direction: DismissDirection.horizontal,
          onDismissed: (direction) {
            if (direction.name == "endToStart") {
              model.choiceDay("next");
            } else {
              model.choiceDay("back");
            }
          },
          child: Table(
            border: TableBorder.all(
              color: Theme.of(context).canvasColor,
            ),
            children: [
              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    Localizable.time,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    Localizable.classes,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                )
              ]),
              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('${model.result!.coupleList![0].description}'),
                ),
                ListView.builder(
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(8.0),
                    itemCount: model.weekType == false
                        ? model.result!.prepScheduleTable![dayIndex].ceilList![0].ceil!.uneven!.length
                        : model.result!.prepScheduleTable![dayIndex].ceilList![0].ceil!.even!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          model.weekType == true
                              ? Text(
                                  '${model.result!.prepScheduleTable![dayIndex].ceilList![0].ceil!.even![index].discName}, ${model.result!.prepScheduleTable![dayIndex].ceilList![0].ceil!.even![index].groupName}, ${model.result!.prepScheduleTable![dayIndex].ceilList![0].ceil!.even![index].lessonType}, ${model.result!.prepScheduleTable![dayIndex].ceilList![0].ceil!.even![index].auditoryName}, с ${model.result!.prepScheduleTable![dayIndex].ceilList![0].ceil!.even![index].startWeekNum} по ${model.result!.prepScheduleTable![dayIndex].ceilList![0].ceil!.even![index].endWeekNum} нед.')
                              : Text(
                                  '${model.result!.prepScheduleTable![dayIndex].ceilList![0].ceil!.uneven![index].discName}, ${model.result!.prepScheduleTable![dayIndex].ceilList![0].ceil!.uneven![index].groupName}, ${model.result!.prepScheduleTable![dayIndex].ceilList![0].ceil!.uneven![index].lessonType}, ${model.result!.prepScheduleTable![dayIndex].ceilList![0].ceil!.uneven![index].auditoryName}, с ${model.result!.prepScheduleTable![dayIndex].ceilList![0].ceil!.uneven![index].startWeekNum} по ${model.result!.prepScheduleTable![dayIndex].ceilList![0].ceil!.uneven![index].endWeekNum} нед.'),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      );
                    })
              ]),
              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('${model.result!.coupleList![1].description}'),
                ),
                ListView.builder(
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(8.0),
                    itemCount: model.weekType == false
                        ? model.result!.prepScheduleTable![dayIndex].ceilList![1].ceil!.uneven!.length
                        : model.result!.prepScheduleTable![dayIndex].ceilList![1].ceil!.even!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          model.weekType == true
                              ? Text(
                                  '${model.result!.prepScheduleTable![dayIndex].ceilList![1].ceil!.even![index].discName}, ${model.result!.prepScheduleTable![dayIndex].ceilList![1].ceil!.even![index].groupName}, ${model.result!.prepScheduleTable![dayIndex].ceilList![1].ceil!.even![index].lessonType}, ${model.result!.prepScheduleTable![dayIndex].ceilList![1].ceil!.even![index].auditoryName}, с ${model.result!.prepScheduleTable![dayIndex].ceilList![1].ceil!.even![index].startWeekNum} по ${model.result!.prepScheduleTable![dayIndex].ceilList![1].ceil!.even![index].endWeekNum} нед.')
                              : Text(
                                  '${model.result!.prepScheduleTable![dayIndex].ceilList![1].ceil!.uneven![index].discName}, ${model.result!.prepScheduleTable![dayIndex].ceilList![1].ceil!.uneven![index].groupName}, ${model.result!.prepScheduleTable![dayIndex].ceilList![1].ceil!.uneven![index].lessonType}, ${model.result!.prepScheduleTable![dayIndex].ceilList![1].ceil!.uneven![index].auditoryName}, с ${model.result!.prepScheduleTable![dayIndex].ceilList![1].ceil!.uneven![index].startWeekNum} по ${model.result!.prepScheduleTable![dayIndex].ceilList![1].ceil!.uneven![index].endWeekNum} нед.'),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      );
                    })
              ]),
              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('${model.result!.coupleList![2].description}'),
                ),
                ListView.builder(
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(8.0),
                    itemCount: model.weekType == false
                        ? model.result!.prepScheduleTable![dayIndex].ceilList![2].ceil!.uneven!.length
                        : model.result!.prepScheduleTable![dayIndex].ceilList![2].ceil!.even!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          model.weekType == true
                              ? Text(
                                  '${model.result!.prepScheduleTable![dayIndex].ceilList![2].ceil!.even![index].discName}, ${model.result!.prepScheduleTable![dayIndex].ceilList![2].ceil!.even![index].groupName}, ${model.result!.prepScheduleTable![dayIndex].ceilList![2].ceil!.even![index].lessonType}, ${model.result!.prepScheduleTable![dayIndex].ceilList![2].ceil!.even![index].auditoryName}, с ${model.result!.prepScheduleTable![dayIndex].ceilList![2].ceil!.even![index].startWeekNum} по ${model.result!.prepScheduleTable![dayIndex].ceilList![2].ceil!.even![index].endWeekNum} нед.')
                              : Text(
                                  '${model.result!.prepScheduleTable![dayIndex].ceilList![2].ceil!.uneven![index].discName}, ${model.result!.prepScheduleTable![dayIndex].ceilList![2].ceil!.uneven![index].groupName}, ${model.result!.prepScheduleTable![dayIndex].ceilList![2].ceil!.uneven![index].lessonType}, ${model.result!.prepScheduleTable![dayIndex].ceilList![2].ceil!.uneven![index].auditoryName}, с ${model.result!.prepScheduleTable![dayIndex].ceilList![2].ceil!.uneven![index].startWeekNum} по ${model.result!.prepScheduleTable![dayIndex].ceilList![2].ceil!.uneven![index].endWeekNum} нед.'),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      );
                    })
              ]),
              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('${model.result!.coupleList![3].description}'),
                ),
                ListView.builder(
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(8.0),
                    itemCount: model.weekType == false
                        ? model.result!.prepScheduleTable![dayIndex].ceilList![3].ceil!.uneven!.length
                        : model.result!.prepScheduleTable![dayIndex].ceilList![3].ceil!.even!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          model.weekType == true
                              ? Text(
                                  '${model.result!.prepScheduleTable![dayIndex].ceilList![3].ceil!.even![index].discName}, ${model.result!.prepScheduleTable![dayIndex].ceilList![3].ceil!.even![index].groupName}, ${model.result!.prepScheduleTable![dayIndex].ceilList![3].ceil!.even![index].lessonType}, ${model.result!.prepScheduleTable![dayIndex].ceilList![3].ceil!.even![index].auditoryName}, с ${model.result!.prepScheduleTable![dayIndex].ceilList![3].ceil!.even![index].startWeekNum} по ${model.result!.prepScheduleTable![dayIndex].ceilList![3].ceil!.even![index].endWeekNum} нед.')
                              : Text(
                                  '${model.result!.prepScheduleTable![dayIndex].ceilList![3].ceil!.uneven![index].discName}, ${model.result!.prepScheduleTable![dayIndex].ceilList![3].ceil!.uneven![index].groupName}, ${model.result!.prepScheduleTable![dayIndex].ceilList![3].ceil!.uneven![index].lessonType}, ${model.result!.prepScheduleTable![dayIndex].ceilList![3].ceil!.uneven![index].auditoryName}, с ${model.result!.prepScheduleTable![dayIndex].ceilList![3].ceil!.uneven![index].startWeekNum} по ${model.result!.prepScheduleTable![dayIndex].ceilList![3].ceil!.uneven![index].endWeekNum} нед.'),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      );
                    })
              ]),
              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('${model.result!.coupleList![4].description}'),
                ),
                ListView.builder(
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(8.0),
                    itemCount: model.weekType == false
                        ? model.result!.prepScheduleTable![dayIndex].ceilList![4].ceil!.uneven!.length
                        : model.result!.prepScheduleTable![dayIndex].ceilList![4].ceil!.even!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          model.weekType == true
                              ? Text(
                                  '${model.result!.prepScheduleTable![dayIndex].ceilList![4].ceil!.even![index].discName}, ${model.result!.prepScheduleTable![dayIndex].ceilList![4].ceil!.even![index].groupName}, ${model.result!.prepScheduleTable![dayIndex].ceilList![4].ceil!.even![index].lessonType}, ${model.result!.prepScheduleTable![dayIndex].ceilList![4].ceil!.even![index].auditoryName}, с ${model.result!.prepScheduleTable![dayIndex].ceilList![4].ceil!.even![index].startWeekNum} по ${model.result!.prepScheduleTable![dayIndex].ceilList![4].ceil!.even![index].endWeekNum} нед.')
                              : Text(
                                  '${model.result!.prepScheduleTable![dayIndex].ceilList![4].ceil!.uneven![index].discName}, ${model.result!.prepScheduleTable![dayIndex].ceilList![4].ceil!.uneven![index].groupName}, ${model.result!.prepScheduleTable![dayIndex].ceilList![4].ceil!.uneven![index].lessonType}, ${model.result!.prepScheduleTable![dayIndex].ceilList![4].ceil!.uneven![index].auditoryName}, с ${model.result!.prepScheduleTable![dayIndex].ceilList![4].ceil!.uneven![index].startWeekNum} по ${model.result!.prepScheduleTable![dayIndex].ceilList![4].ceil!.uneven![index].endWeekNum} нед.'),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      );
                    })
              ]),
              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('${model.result!.coupleList![5].description}'),
                ),
                ListView.builder(
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(8.0),
                    itemCount: model.weekType == false
                        ? model.result!.prepScheduleTable![dayIndex].ceilList![5].ceil!.uneven!.length
                        : model.result!.prepScheduleTable![dayIndex].ceilList![5].ceil!.even!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          model.weekType == true
                              ? Text(
                                  '${model.result!.prepScheduleTable![dayIndex].ceilList![5].ceil!.even![index].discName}, ${model.result!.prepScheduleTable![dayIndex].ceilList![5].ceil!.even![index].groupName}, ${model.result!.prepScheduleTable![dayIndex].ceilList![5].ceil!.even![index].lessonType}, ${model.result!.prepScheduleTable![dayIndex].ceilList![5].ceil!.even![index].auditoryName}, с ${model.result!.prepScheduleTable![dayIndex].ceilList![5].ceil!.even![index].startWeekNum} по ${model.result!.prepScheduleTable![dayIndex].ceilList![5].ceil!.even![index].endWeekNum} нед.')
                              : Text(
                                  '${model.result!.prepScheduleTable![dayIndex].ceilList![5].ceil!.uneven![index].discName}, ${model.result!.prepScheduleTable![dayIndex].ceilList![5].ceil!.uneven![index].groupName}, ${model.result!.prepScheduleTable![dayIndex].ceilList![5].ceil!.uneven![index].lessonType}, ${model.result!.prepScheduleTable![dayIndex].ceilList![5].ceil!.uneven![index].auditoryName}, с ${model.result!.prepScheduleTable![dayIndex].ceilList![5].ceil!.uneven![index].startWeekNum} по ${model.result!.prepScheduleTable![dayIndex].ceilList![5].ceil!.uneven![index].endWeekNum} нед.'),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      );
                    })
              ]),
              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('${model.result!.coupleList![6].description}'),
                ),
                ListView.builder(
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(8.0),
                    itemCount: model.weekType == false
                        ? model.result!.prepScheduleTable![dayIndex].ceilList![6].ceil!.uneven!.length
                        : model.result!.prepScheduleTable![dayIndex].ceilList![6].ceil!.even!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          model.weekType == true
                              ? Text(
                                  '${model.result!.prepScheduleTable![dayIndex].ceilList![6].ceil!.even![index].discName}, ${model.result!.prepScheduleTable![dayIndex].ceilList![6].ceil!.even![index].groupName}, ${model.result!.prepScheduleTable![dayIndex].ceilList![6].ceil!.even![index].lessonType}, ${model.result!.prepScheduleTable![dayIndex].ceilList![6].ceil!.even![index].auditoryName}, с ${model.result!.prepScheduleTable![dayIndex].ceilList![6].ceil!.even![index].startWeekNum} по ${model.result!.prepScheduleTable![dayIndex].ceilList![6].ceil!.even![index].endWeekNum} нед.')
                              : Text(
                                  '${model.result!.prepScheduleTable![dayIndex].ceilList![6].ceil!.uneven![index].discName}, ${model.result!.prepScheduleTable![dayIndex].ceilList![6].ceil!.uneven![index].groupName}, ${model.result!.prepScheduleTable![dayIndex].ceilList![6].ceil!.uneven![index].lessonType}, ${model.result!.prepScheduleTable![dayIndex].ceilList![6].ceil!.uneven![index].auditoryName}, с ${model.result!.prepScheduleTable![dayIndex].ceilList![6].ceil!.uneven![index].startWeekNum} по ${model.result!.prepScheduleTable![dayIndex].ceilList![6].ceil!.uneven![index].endWeekNum} нед.'),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      );
                    })
              ])
            ],
          ),
        );
}
