import 'package:flutter/material.dart';
import 'package:kemsu_app/UI/views/pgas/model/achieve_category.dart';
import 'package:kemsu_app/UI/views/pgas/model/activity_tree.dart';
import 'package:kemsu_app/UI/views/pgas/model/year.dart';
import 'package:kemsu_app/UI/views/pgas/new_achieve_pgas_viewmodel.dart';
import 'package:stacked/stacked.dart';
import '../../widgets.dart';

class NewAchievePgasScreen extends StatelessWidget {
  const NewAchievePgasScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NewAchievePgasViewModel>.reactive(
        viewModelBuilder: () => NewAchievePgasViewModel(context),
        onModelReady: (viewModel) => viewModel.onReady(),
        builder: (context, model, child) {
          return Scaffold(
            appBar: customAppBar(context, model, "Прикрепление"),
            body: _body(context, model),
          );
        });
  }
}

_body(context, NewAchievePgasViewModel model) {
  return SingleChildScrollView(
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 27, vertical: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _title(context),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: _achieveCategoryDropDown(context, model),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: model.showAchieve1
              ? _activity1DropDown(context, model)
              : const SizedBox.shrink(),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: model.showAchieve2
              ? _activity2DropDown(context, model)
              : const SizedBox.shrink(),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: model.showAchieve3
              ? _activity3DropDown(context, model)
              : const SizedBox.shrink(),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: model.showAchieve4
              ? _activity4DropDown(context, model)
              : const SizedBox.shrink(),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: model.showOtherInputData
              ? _otherInputData(context, model)
              : const SizedBox.shrink(),
        ),
      ],
    ),
  );
}

_title(context) {
  return const Text("Прикрепление достижения",
      style: TextStyle(
          fontSize: 24, fontWeight: FontWeight.w800, color: Colors.blueAccent));
}

_achieveCategoryDropDown(context, NewAchievePgasViewModel model) {
  return Container(
    decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF00C2FF)),
        borderRadius: BorderRadius.circular(10)),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<AchieveCategoryModel>(
          dropdownColor: Theme.of(context).primaryColor,
          isExpanded: true,
          value: model.chosenCategory,
          items: model.achieveCategories
              .map<DropdownMenuItem<AchieveCategoryModel>>((e) {
            return DropdownMenuItem<AchieveCategoryModel>(
              child: FittedBox(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(e.activityTypeTitle.toString()),
                ),
              ),
              value: e,
            );
          }).toList(),
          hint: const Center(
              child: Text(
            "Категория достижения",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                fontStyle: FontStyle.normal),
          )),
          onChanged: (value) {
            model.chosenCategory = value!;
            model.showOtherInputData = false;
            model.showAchieve1 = false;
            model.showAchieve2 = false;
            model.showAchieve3 = false;
            model.showAchieve4 = false;
            model.chosenActivity1 = null;
            model.chosenActivity2 = null;
            model.chosenActivity3 = null;
            model.chosenActivity4 = null;
            model.fetchAchieves(0, value.activityTypeId).then((value) {
              model.activityList1 = value;
              model.notifyListeners();
            });
            model.showAchieve1 = true;
            model.notifyListeners();
          }),
    ),
  );
}

_activity1DropDown(context, NewAchievePgasViewModel model) {
  return Container(
    decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF00C2FF)),
        borderRadius: BorderRadius.circular(10)),
    child: DropdownButtonHideUnderline(
      child: ButtonTheme(
        alignedDropdown: true,
        child: DropdownButton<ActivityTreeModel>(
            isExpanded: true,
            itemHeight: null,
            value: model.chosenActivity1,
            items: model.activityList1
                .map<DropdownMenuItem<ActivityTreeModel>>((e) {
              return DropdownMenuItem<ActivityTreeModel>(
                child: Container(
                  child: Text(e.activityTitle.toString()),
                  padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 6.0),
                ),
                value: e,
              );
            }).toList(),
            hint: const Center(
                child: Text(
              "Категория достижения",
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  fontStyle: FontStyle.normal),
            )),
            onChanged: (value) {
              model.chosenActivity1 = value!;
              model.showOtherInputData = false;
              model.showAchieve2 = false;
              model.showAchieve3 = false;
              model.showAchieve4 = false;
              model.chosenActivity2 = null;
              model.chosenActivity3 = null;
              model.chosenActivity4 = null;
              if (value.nodeCnt != 0) {
                model
                    .fetchAchieves(model.chosenActivity1!.activityId,
                        model.chosenCategory!.activityTypeId)
                    .then((value) {
                  model.activityList2 = value;
                  model.showAchieve2 = true;
                  model.notifyListeners();
                });
              } else {
                model.showOtherInputData = true;
              }
              model.notifyListeners();
            }),
      ),
    ),
  );
}

_activity2DropDown(context, NewAchievePgasViewModel model) {
  return Container(
    decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF00C2FF)),
        borderRadius: BorderRadius.circular(10)),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<ActivityTreeModel>(
          itemHeight: null,
          isExpanded: true,
          value: model.chosenActivity2,
          items:
              model.activityList2.map<DropdownMenuItem<ActivityTreeModel>>((e) {
            return DropdownMenuItem<ActivityTreeModel>(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Text(e.activityTitle.toString()),
                  padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 6.0),
                ),
              ),
              value: e,
            );
          }).toList(),
          hint: const Center(
              child: Text(
            "Достижение",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                fontStyle: FontStyle.normal),
          )),
          onChanged: (value) {
            model.chosenActivity2 = value!;
            model.showOtherInputData = false;
            model.showAchieve3 = false;
            model.showAchieve4 = false;
            model.chosenActivity3 = null;
            model.chosenActivity4 = null;
            if (value.nodeCnt != 0) {
              model
                  .fetchAchieves(model.chosenActivity2!.activityId,
                      model.chosenCategory!.activityTypeId)
                  .then((value) {
                model.activityList3 = value;
                model.showAchieve3 = true;
                model.notifyListeners();
              });
            } else {
              model.showOtherInputData = true;
            }
            model.notifyListeners();
          }),
    ),
  );
}

_activity3DropDown(context, NewAchievePgasViewModel model) {
  return Container(
    decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF00C2FF)),
        borderRadius: BorderRadius.circular(10)),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<ActivityTreeModel>(
          isExpanded: true,
          itemHeight: null,
          value: model.chosenActivity3,
          items:
              model.activityList3.map<DropdownMenuItem<ActivityTreeModel>>((e) {
            return DropdownMenuItem<ActivityTreeModel>(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Text(e.activityTitle.toString()),
                  padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 6.0),
                ),
              ),
              value: e,
            );
          }).toList(),
          hint: const Center(
              child: Text(
            "Достижение",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                fontStyle: FontStyle.normal),
          )),
          onChanged: (value) {
            model.chosenActivity3 = value!;
            model.showOtherInputData = false;
            model.showAchieve4 = false;
            model.chosenActivity4 = null;
            if (value.nodeCnt != 0) {
              model
                  .fetchAchieves(model.chosenActivity3!.activityId,
                      model.chosenCategory!.activityTypeId)
                  .then((value) {
                model.activityList4 = value;
                model.showAchieve4 = true;
                model.notifyListeners();
              });
            } else {
              model.showOtherInputData = true;
            }
            model.notifyListeners();
          }),
    ),
  );
}

_activity4DropDown(context, NewAchievePgasViewModel model) {
  return Container(
    decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF00C2FF)),
        borderRadius: BorderRadius.circular(10)),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<ActivityTreeModel>(
          isExpanded: true,
          itemHeight: null,
          value: model.chosenActivity4,
          items:
              model.activityList4.map<DropdownMenuItem<ActivityTreeModel>>((e) {
            return DropdownMenuItem<ActivityTreeModel>(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Text(e.activityTitle.toString()),
                  padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 6.0),
                ),
              ),
              value: e,
            );
          }).toList(),
          hint: const Center(
              child: Text(
            "Достижение",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                fontStyle: FontStyle.normal),
          )),
          onChanged: (value) {
            model.chosenActivity4 = value!;
            model.showOtherInputData = true;
            model.notifyListeners();
          }),
    ),
  );
}

_otherInputData(context, NewAchievePgasViewModel model) {
  return Column(
    children: [
      TextField(
          maxLines: 5,
          textCapitalization: TextCapitalization.words,
          autofocus: false,
          controller: model.descController,
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(8),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      const BorderSide(color: Color(0xFFC4C4C4), width: 1)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      const BorderSide(color: Color(0xFFC4C4C4), width: 1)),
              hintText:
                  "Описание достижения (не требуется для достижения 'Отличная учеба')",
              hintStyle: const TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                  fontSize: 14))),
      const SizedBox(
        height: 10,
      ),
      DropdownButtonHideUnderline(
        child: DropdownButton<YearModel>(
            isExpanded: true,
            value: model.chosenYear,
            items: model.years.map<DropdownMenuItem<YearModel>>((e) {
              return DropdownMenuItem<YearModel>(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(e.year.toString()),
                ),
                value: e,
              );
            }).toList(),
            hint: const Center(
                child: Text(
              "Год получения",
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  fontStyle: FontStyle.normal),
            )),
            onChanged: (value) {
              model.chosenYear = value!;
              model.notifyListeners();
            }),
      ),
      const SizedBox(
        height: 10,
      ),
      Container(
        decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFC4C4C4)),
            borderRadius: BorderRadius.circular(10)),
        height: 60,
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
              isExpanded: true,
              value: model.chosenMonth == null
                  ? null
                  : model.months[model.chosenMonth!],
              items: model.months
                  .map<DropdownMenuItem<String>>(
                      (e) => DropdownMenuItem<String>(
                          value: e,
                          child: FittedBox(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(e.toString()),
                          ))))
                  .toList(),
              onChanged: (value) {
                model.chosenMonth = model.months.indexOf(value!);
                model.notifyListeners();
              },
              hint: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Месяц получения достижения (не требуется для достижения 'Отличная учеба')",
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                      fontSize: 14),
                ),
              )),
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      TextField(
          maxLines: 2,
          textCapitalization: TextCapitalization.words,
          autofocus: false,
          controller: model.resourceController,
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(8),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      const BorderSide(color: Color(0xFFC4C4C4), width: 1)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      const BorderSide(color: Color(0xFFC4C4C4), width: 1)),
              hintText:
                  "Ссылка на внешний ресурс, подтверждающий выполнение достижения",
              hintStyle: const TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                  fontSize: 14))),
      const SizedBox(
        height: 10,
      ),
      _fileContainer(context, model),
      const SizedBox(
        height: 10,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 22),
        child: Container(
            width: double.maxFinite,
            height: 46,
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                    color: Colors.black45,
                    offset: Offset(0, 6),
                    spreadRadius: 1,
                    blurRadius: 7)
              ],
              borderRadius: BorderRadius.circular(10),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF00C2FF), Colors.blueAccent],
              ),
            ),
            child: TextButton(
              onPressed: () async {
                model.sendButtonAction(context);
              },
              child: model.circle
                  ? const SizedBox(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                      height: 14,
                      width: 14,
                    )
                  : const Text(
                      "Отправить",
                      style: TextStyle(
                        fontStyle: FontStyle.normal,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
            )),
      )
    ],
  );
}

_fileContainer(context, NewAchievePgasViewModel model) {
  return model.chooseFile == null
      ? InkWell(
          onTap: () => model.pickFileBtnAction(context),
          child: Container(
            width: 100,
            height: 150,
            decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Colors.grey),
                borderRadius: const BorderRadius.all(Radius.circular(15))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "+",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 28),
                ),
                const Text("Выберите файл-подтверждение (до 10 МБ)",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey))
              ],
            ),
          ),
        )
      : InkWell(
          onTap: () => model.pickFileBtnAction(context),
          child: Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              Container(
                width: 100,
                height: 150,
                decoration: const BoxDecoration(
                    color: Colors.lightBlueAccent,
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(model.chooseFile!.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white)),
                    Text(
                        "Размер: ${(model.chooseFile!.size / 1024 / 1024).roundToDouble()} МБ",
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white))
                  ],
                ),
              ),
              Positioned(
                  child: ElevatedButton(
                    onPressed: () {
                      model.chooseFile = null;
                      model.notifyListeners();
                    },
                    child: const Icon(
                      Icons.close,
                      color: Colors.black,
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      backgroundColor: Colors.white, // <-- Button color
                    ),
                  ),
                  bottom: 110,
                  left: 60)
            ],
          ),
        );
}
