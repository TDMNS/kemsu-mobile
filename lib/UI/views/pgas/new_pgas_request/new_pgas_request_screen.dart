import 'package:flutter/material.dart';
import 'package:kemsu_app/Configurations/localizable.dart';
import 'package:kemsu_app/UI/common_views/main_button.dart';
import 'package:stacked/stacked.dart';

import '../../../widgets.dart';
import '../common_models/faculty_model.dart';
import '../common_models/semester_type_model.dart';
import 'new_pgas_request_view_model.dart';

class NewPgasRequestScreenRoute extends MaterialPageRoute {
  NewPgasRequestScreenRoute() : super(builder: (context) => const NewPgasRequestScreen());
}

class NewPgasRequestScreen extends StatelessWidget {
  const NewPgasRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NewPgasRequestViewModel>.reactive(
        viewModelBuilder: () => NewPgasRequestViewModel(context),
        onViewModelReady: (viewModel) => viewModel.onReady(),
        builder: (context, model, child) {
          return Scaffold(
            appBar: customAppBar(context, Localizable.newRequestTitle),
            body: model.circle
                ? Container(
                    color: Theme.of(context).primaryColor,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Colors.blue,
                        backgroundColor: Colors.white,
                      ),
                    ),
                  )
                : _body(context, model),
          );
        });
  }
}

_body(context, NewPgasRequestViewModel model) {
  return SingleChildScrollView(
    child: Column(
      children: [
        const SizedBox(
          height: 22,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              decoration: BoxDecoration(border: Border.all(color: const Color(0xFF00C2FF)), borderRadius: BorderRadius.circular(10)),
              width: MediaQuery.of(context).size.width * 0.43,
              height: 30,
              child: DropdownButtonHideUnderline(
                child: DropdownButton<FacultyModel>(
                    dropdownColor: Theme.of(context).primaryColor,
                    isExpanded: true,
                    value: model.chooseFaculty,
                    items: model.facultiesList.map<DropdownMenuItem<FacultyModel>>((e) {
                      return DropdownMenuItem<FacultyModel>(
                        value: e,
                        child: FittedBox(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(e.facultyShortTitle.toString()),
                          ),
                        ),
                      );
                    }).toList(),
                    hint: Center(
                        child: Text(
                      Localizable.institute,
                      style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 14, fontStyle: FontStyle.normal),
                    )),
                    onChanged: (value) {
                      model.chooseFaculty = value!;
                      model.notifyListeners();
                    }),
              ),
            ),
            Container(
              decoration: BoxDecoration(border: Border.all(color: const Color(0xFF00C2FF)), borderRadius: BorderRadius.circular(10)),
              width: MediaQuery.of(context).size.width * 0.43,
              height: 30,
              child: DropdownButtonHideUnderline(
                child: DropdownButton<SemesterTypeModel>(
                    dropdownColor: Theme.of(context).primaryColor,
                    isExpanded: true,
                    value: model.chooseSemester,
                    items: model.semestersList.map<DropdownMenuItem<SemesterTypeModel>>((e) {
                      return DropdownMenuItem<SemesterTypeModel>(
                        value: e,
                        child: FittedBox(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(e.semesterTypeTitle.toString()),
                          ),
                        ),
                      );
                    }).toList(),
                    hint: Center(
                      child: Text(
                        Localizable.semester,
                        style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 14, fontStyle: FontStyle.normal),
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
        _textField(context, Localizable.lastName, model.surnameController),
        const SizedBox(
          height: 10,
        ),
        _textField(context, Localizable.firstName, model.firstNameController),
        const SizedBox(
          height: 10,
        ),
        _textField(context, Localizable.patronymic, model.middleNameController),
        const SizedBox(
          height: 10,
        ),
        _textField(context, Localizable.newRequestPhoneFormat, model.phoneController),
        const SizedBox(
          height: 10,
        ),
        _textField(context, Localizable.newRequestGroupName, model.groupController),
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
        SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: mainButton(context, onPressed: () {
              model.sendButtonAction(context);
            }, title: Localizable.send, isPrimary: true))
      ],
    ),
  );
}

_textField(context, String label, TextEditingController controller) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        height: 40,
        child: TextField(
            textCapitalization: TextCapitalization.words,
            autofocus: false,
            controller: controller,
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(8),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFC4C4C4), width: 1)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFC4C4C4), width: 1)),
                hintText: label,
                hintStyle: const TextStyle(fontWeight: FontWeight.w400, color: Colors.black, fontSize: 14))),
      ),
    ],
  );
}

_yearDropdownButton(context, NewPgasRequestViewModel model) {
  return Container(
    decoration: BoxDecoration(border: Border.all(color: const Color(0xFF00C2FF)), borderRadius: BorderRadius.circular(10)),
    width: MediaQuery.of(context).size.width * 0.9,
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
          hint: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              Localizable.newRequestStudyYear,
              style: const TextStyle(fontWeight: FontWeight.w400, color: Colors.black, fontSize: 14),
            ),
          )),
    ),
  );
}

_courseDropdownButton(context, NewPgasRequestViewModel model) {
  return Container(
    decoration: BoxDecoration(border: Border.all(color: const Color(0xFF00C2FF)), borderRadius: BorderRadius.circular(10)),
    width: MediaQuery.of(context).size.width * 0.9,
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
          hint: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              Localizable.newRequestCourseNumber,
              style: const TextStyle(fontWeight: FontWeight.w400, color: Colors.black, fontSize: 14),
            ),
          )),
    ),
  );
}
