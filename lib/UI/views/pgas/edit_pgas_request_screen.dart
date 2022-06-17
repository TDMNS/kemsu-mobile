import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'edit_pgas_request_viewmodel.dart';
import 'model/faculty.dart';
import 'model/semester_type.dart';

class EditPgasRequestScreenRoute extends MaterialPageRoute {
  EditPgasRequestScreenRoute() : super(builder: (context) => const EditPgasRequestScreen());
}

class EditPgasRequestScreen extends StatelessWidget {
  const EditPgasRequestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<EditPgasRequestViewModel>.reactive(
        viewModelBuilder: () => EditPgasRequestViewModel(context),
        onModelReady: (viewModel) => viewModel.onReady(),
        builder: (context, model, child) {
          return model.circle ? const Center(child: CircularProgressIndicator(),) : Scaffold(
              body: NestedScrollView(
                floatHeaderSlivers: true,
                headerSliverBuilder: (context, innerBoxIsScrolled) =>
                [
                  _appBar(context, model)
                ],
                body: _body(context, model),
              )
          );
        });
  }

  _appBar(context, model) {
    return SliverAppBar(
      floating: true,
      snap: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_outlined),
        color: Colors.black,
        onPressed: () async {
          Navigator.pop(context);
        },
        iconSize: 32,
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
    );
  }

  _body(context, EditPgasRequestViewModel model) {
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
          const SizedBox(height: 22,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF00C2FF)),
                    borderRadius: BorderRadius.circular(10)
                ),
                width: 156,
                height: 30,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<FacultyModel>(
                      isExpanded: true,
                      value: model.chooseFaculty,
                      items: model.facultiesList.map<DropdownMenuItem<FacultyModel>>((e) {
                        return DropdownMenuItem<FacultyModel>(
                          child: FittedBox(child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(e.facultyShortTitle.toString()),
                          )),
                          value: e,
                        );
                      }).toList(),
                      hint: const Center(
                          child: Text(
                            "Институт",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                fontStyle: FontStyle.normal
                            ),
                          )
                      ),
                      onChanged: (value) {
                        model.chooseFaculty = value!;
                        model.isChanged = true;
                        model.notifyListeners();
                      }
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF00C2FF)),
                    borderRadius: BorderRadius.circular(10)
                ),
                width: 156,
                height: 30,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<SemesterTypeModel>(
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
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              fontStyle: FontStyle.normal
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        model.chooseSemester = value!;
                        model.isChanged = true;
                        model.notifyListeners();
                      }
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20,),
          _surnameTextField(context, model),
          const SizedBox(height: 10,),
          _firstNameTextField(context, model),
          const SizedBox(height: 10,),
          _middleNameTextField(context, model),
          const SizedBox(height: 10,),
          _phoneTextField(context, model),
          const SizedBox(height: 10,),
          _groupTextField(context, model),
          const SizedBox(height: 10,),
          _yearDropdownButton(context, model),
          const SizedBox(height: 10,),
          _courseDropdownButton(context, model),
          const SizedBox(height: 20,),
          _saveButton(context, model)
        ],
      ),
    );
  }

  _surnameTextField(context, EditPgasRequestViewModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 40,
          width: 334,
          child: TextField(
              onChanged: (value) {
                model.isChanged = true;
                model.notifyListeners();
              },
              autofocus: false,
              controller: model.surnameController,
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(8),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFFC4C4C4), width: 1)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFFC4C4C4), width: 1)),
                  hintText: "Фамилия",
                  hintStyle: const TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                      fontSize: 14
                  )
              )),
        ),
      ],
    );
  }

  _firstNameTextField(context, EditPgasRequestViewModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 334,
          height: 40,
          child: TextField(
              onChanged: (value) {
                model.isChanged = true;
                model.notifyListeners();
              },
              autofocus: false,
              controller: model.firstNameController,
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(8),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFFC4C4C4), width: 1)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFFC4C4C4), width: 1)),
                  hintText: "Имя",
                  hintStyle: const TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                      fontSize: 14
                  )
              )),
        ),
      ],
    );
  }

  _middleNameTextField(context, EditPgasRequestViewModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 334,
          height: 40,
          child: TextField(
              onChanged: (value) {
                model.isChanged = true;
                model.notifyListeners();
              },
              autofocus: false,
              controller: model.middleNameController,
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(8),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFFC4C4C4), width: 1)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFFC4C4C4), width: 1)),
                  hintText: "Отчество",
                  hintStyle: const TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                      fontSize: 14
                  )
              )),
        ),
      ],
    );
  }

  _phoneTextField(context, EditPgasRequestViewModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 334,
          height: 40,
          child: TextField(
              onChanged: (value) {
                model.isChanged = true;
                model.notifyListeners();
              },
              autofocus: false,
              keyboardType: TextInputType.number,
              controller: model.phoneController,
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(8),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFFC4C4C4), width: 1)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFFC4C4C4), width: 1)),
                  hintText: "Номер телефона в любом формате",
                  hintStyle: const TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                      fontSize: 14
                  )
              )),
        ),
      ],
    );
  }

  _groupTextField(context, EditPgasRequestViewModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 334,
          height: 40,
          child: TextField(
              onChanged: (value) {
                model.isChanged = true;
                model.notifyListeners();
              },
              autofocus: false,
              controller: model.groupController,
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(8),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFFC4C4C4), width: 1)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFFC4C4C4), width: 1)),
                  hintText: "Название группы (пример: М-185)",
                  hintStyle: const TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                      fontSize: 14
                  )
              )),
        ),
      ],
    );
  }

  _yearDropdownButton(context, EditPgasRequestViewModel model) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF00C2FF)),
          borderRadius: BorderRadius.circular(10)
      ),
      width: 334,
      height: 40,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
            isExpanded: true,
            items: model.studyYears.map<DropdownMenuItem<String>>((e) => DropdownMenuItem<String>(
                value: e,
                child: FittedBox(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(e.toString()),
                )))
            ).toList(),
            value: model.chosenYear,
            onChanged: (value) {
              model.chosenYear = value!;
              model.isChanged = true;
              model.notifyListeners();
            },
            hint: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                model.chosenYear.toString(),
                style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    fontSize: 14
                ),
              ),
            )
        ),
      ),
    );
  }

  _courseDropdownButton(context, EditPgasRequestViewModel model) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF00C2FF)),
          borderRadius: BorderRadius.circular(10)
      ),
      width: 334,
      height: 40,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
            isExpanded: true,
            items: model.courses.map<DropdownMenuItem<String>>((e) => DropdownMenuItem<String>(
                value: e,
                child: FittedBox(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(e.toString()),
                )))
            ).toList(),
            value: model.chosenCourse,
            onChanged: (value) {
              model.chosenCourse = value!;
              model.isChanged = true;
              model.notifyListeners();
            },
            hint: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                model.chosenCourse.toString(),
                style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    fontSize: 14
                ),
              ),
            )
        ),
      ),
    );
  }

  _saveButton(context, EditPgasRequestViewModel model) {
    return Padding(
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
                  blurRadius: 7
              )
            ],
            borderRadius: BorderRadius.circular(10),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF00C2FF),
                Colors.blueAccent
              ],
            ),
          ),
          child: TextButton(
            onPressed: () async {
              model.isChanged ? model.saveButtonAction(context) : Navigator.pop(context);
            },
            child: const Text(
              "Сохранить изменения",
              style: TextStyle(
                fontStyle: FontStyle.normal,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,),
            ),

          )
      ),
    );
  }

  _title(context) {
    return const Text("Редактирование заявки",
        style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Color(0xFF5B5B7E)
        )
    );
  }
}
