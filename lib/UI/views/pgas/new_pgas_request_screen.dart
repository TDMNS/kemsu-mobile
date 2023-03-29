import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../widgets.dart';
import 'model/faculty.dart';
import 'model/semester_type.dart';
import 'new_pgas_request_viewmodel.dart';

class NewPgasRequestScreenRoute extends MaterialPageRoute {
  NewPgasRequestScreenRoute() : super(builder: (context) => const NewPgasRequestScreen());
}

class NewPgasRequestScreen extends StatelessWidget {
  const NewPgasRequestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NewPgasRequestViewModel>.reactive(
        viewModelBuilder: () => NewPgasRequestViewModel(context),
        onModelReady: (viewModel) => viewModel.onReady(),
        builder: (context, model, child) {
          return Scaffold(
            appBar: customAppBar(context, model, "Новая заявка"),
            body: _body(context, model),
          );
        });
  }
}

_body(context, NewPgasRequestViewModel model) {
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
        const SizedBox(
          height: 22,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF00C2FF)), borderRadius: BorderRadius.circular(10)),
              width: 156,
              height: 30,
              child: DropdownButtonHideUnderline(
                child: DropdownButton<FacultyModel>(
                    dropdownColor: Theme.of(context).primaryColor,
                    isExpanded: true,
                    value: model.chooseFaculty,
                    items: model.facultiesList.map<DropdownMenuItem<FacultyModel>>((e) {
                      return DropdownMenuItem<FacultyModel>(
                        child: FittedBox(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(e.facultyShortTitle.toString()),
                          ),
                        ),
                        value: e,
                      );
                    }).toList(),
                    hint: const Center(
                        child: Text(
                      "Институт",
                      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14, fontStyle: FontStyle.normal),
                    )),
                    onChanged: (value) {
                      model.chooseFaculty = value!;
                      model.notifyListeners();
                    }),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF00C2FF)), borderRadius: BorderRadius.circular(10)),
              width: 156,
              height: 30,
              child: DropdownButtonHideUnderline(
                child: DropdownButton<SemesterTypeModel>(
                    dropdownColor: Theme.of(context).primaryColor,
                    isExpanded: true,
                    value: model.chooseSemester,
                    items: model.semestersList.map<DropdownMenuItem<SemesterTypeModel>>((e) {
                      return DropdownMenuItem<SemesterTypeModel>(
                        child: FittedBox(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(e.semesterTypeTitle.toString()),
                          ),
                        ),
                        value: e,
                      );
                    }).toList(),
                    hint: const Center(
                      child: Text(
                        "Семестр",
                        style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14, fontStyle: FontStyle.normal),
                      ),
                    ),
                    onChanged: (value) {
                      model.chooseSemester = value!;
                      model.notifyListeners();
                    }),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        _textField(context, "Фамилия", model.surnameController),
        const SizedBox(
          height: 10,
        ),
        _textField(context, "Имя", model.firstNameController),
        const SizedBox(
          height: 10,
        ),
        _textField(context, "Отчество", model.middleNameController),
        const SizedBox(
          height: 10,
        ),
        _textField(context, "Номер телефона в любом формате", model.phoneController),
        const SizedBox(
          height: 10,
        ),
        _textField(context, "Название группы (пример: М-185)", model.groupController),
        const SizedBox(
          height: 10,
        ),
        _yearDropdownButton(context, model),
        const SizedBox(
          height: 10,
        ),
        _courseDropdownButton(context, model),
        const SizedBox(
          height: 20,
        ),
        _sendButton(context, model)
      ],
    ),
  );
}

_textField(context, String label, TextEditingController controller) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SizedBox(
        height: 40,
        width: 334,
        child: TextField(
            textCapitalization: TextCapitalization.words,
            autofocus: false,
            controller: controller,
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(8),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFFC4C4C4), width: 1)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFFC4C4C4), width: 1)),
                hintText: label,
                hintStyle: const TextStyle(fontWeight: FontWeight.w400, color: Colors.black, fontSize: 14))),
      ),
    ],
  );
}

_yearDropdownButton(context, NewPgasRequestViewModel model) {
  return Container(
    decoration:
        BoxDecoration(border: Border.all(color: const Color(0xFF00C2FF)), borderRadius: BorderRadius.circular(10)),
    width: 334,
    height: 40,
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
          dropdownColor: Theme.of(context).primaryColor,
          isExpanded: true,
          items: model.studyYears
              .map<DropdownMenuItem<String>>((e) => DropdownMenuItem<String>(
                  value: e,
                  child: FittedBox(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(e.toString()),
                  ))))
              .toList(),
          value: model.chosenYear,
          onChanged: (value) {
            model.chosenYear = value!;
            model.notifyListeners();
          },
          hint: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Учебный год",
              style: TextStyle(fontWeight: FontWeight.w400, color: Colors.black, fontSize: 14),
            ),
          )),
    ),
  );
}

_courseDropdownButton(context, NewPgasRequestViewModel model) {
  return Container(
    decoration:
        BoxDecoration(border: Border.all(color: const Color(0xFF00C2FF)), borderRadius: BorderRadius.circular(10)),
    width: 334,
    height: 40,
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
          dropdownColor: Theme.of(context).primaryColor,
          isExpanded: true,
          items: model.courses
              .map<DropdownMenuItem<String>>((e) => DropdownMenuItem<String>(
                  value: e,
                  child: FittedBox(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(e.toString()),
                  ))))
              .toList(),
          value: model.chosenCourse,
          onChanged: (value) {
            model.chosenCourse = value!;
            model.notifyListeners();
          },
          hint: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Номер курса",
              style: TextStyle(fontWeight: FontWeight.w400, color: Colors.black, fontSize: 14),
            ),
          )),
    ),
  );
}

_sendButton(context, NewPgasRequestViewModel model) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 22),
    child: Container(
        width: double.maxFinite,
        height: 46,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).primaryColorLight, offset: const Offset(0, 6), spreadRadius: -1, blurRadius: 5)
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
          child: const Text(
            "Отправить",
            style: TextStyle(
              fontStyle: FontStyle.normal,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        )),
  );
}

_title(context) {
  return const Text("Новая заявка на ПГАС",
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.blueAccent));
}
