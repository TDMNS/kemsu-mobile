import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kemsu_app/UI/views/rating_of_students/views/ros_detail_view.dart';
import 'package:kemsu_app/UI/views/rating_of_students/ros_model.dart';
import 'package:stacked/stacked.dart';
import '../../../widgets.dart';
import '../../schedule/schedule_view.dart';
import '../ros_viewmodel.dart';

class RosView extends StatelessWidget {
  const RosView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RosViewModel>.reactive(
        onModelReady: (viewModel) => viewModel.onReady(),
        viewModelBuilder: () => RosViewModel(context),
        builder: (context, model, child) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
              value: const SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarIconBrightness: Brightness.dark), //прозрачность statusbar и установка тёмных иконок
              child: GestureDetector(
                onTap: () {
                  FocusScopeNode currentFocus = FocusScope.of(context); //расфокус textfield при нажатии на экран
                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                },
                child: Scaffold(
                  extendBody: true,
                  extendBodyBehindAppBar: true,
                  appBar: customAppBar(context, model, 'БРС'),
                  //bottomNavigationBar: customBottomBar(context, model),
                  body: _rosView(context, model),
                ),
              ));
        });
  }
}

_rosView(context, RosViewModel model) {
  dropdownItems = List.generate(
    model.receivedStudyCard.length,
    (index) => DropdownMenuItem(
      value: model.receivedStudyCard[index].id.toString(),
      child: Text(
        '${model.receivedStudyCard[index].speciality}',
      ),
    ),
  );
  return ListView(
    children: <Widget>[
      const SizedBox(height: 10),
      Center(
        child: Card(
          margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton<StudyCard>(
                dropdownColor: Theme.of(context).primaryColor,
                itemHeight: 70.0,
                hint: const Text(
                  '- Выбрать учебную карту -',
                ),
                onChanged: (value) {
                  model.changeCard(value);
                },
                isExpanded: true,
                value: model.studyCard,
                items: model.receivedStudyCard.map<DropdownMenuItem<StudyCard>>((e) {
                  return DropdownMenuItem<StudyCard>(
                    child: Text(e.speciality.toString()),
                    value: e,
                  );
                }).toList(),
              )),
        ),
      ),
      const SizedBox(height: 10),
      model.studyCard?.id != null
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Table(
                border: TableBorder.all(
                  color: Theme.of(context).canvasColor,
                ),
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                defaultColumnWidth: const FlexColumnWidth(),
                children: [
                  const TableRow(
                    children: [
                      Text(
                        'Учебный год',
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Семестр',
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Рейтинг',
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Просмотр',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  ...List.generate(model.rosSemesterList.length, (index) {
                    var element = model.rosSemesterList[index];

                    return TableRow(
                      children: [
                        Text(
                          "${element.startDate}-${element.endDate}",
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "${element.semester}",
                          textAlign: TextAlign.center,
                        ), //Extracting from Map element the value
                        Text(
                          "${element.commonScore}",
                          textAlign: TextAlign.center,
                        ),
                        IconButton(
                            onPressed: () async {
                              await model.getReitList(element.startDate, element.endDate, element.semester);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RosDetailView(
                                          reitList: model.reitList,
                                          semester: element.semester != null ? element.semester! : 1,
                                        )),
                              );
                            },
                            icon: Icon(
                              Icons.saved_search,
                              color: Theme.of(context).primaryColorDark,
                            ))
                      ],
                    );
                  }),
                ],
              ))
          : const SizedBox.shrink()
    ],
  );
}
