import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kemsu_app/UI/common_views/main_button.dart';
import 'package:kemsu_app/UI/common_views/main_dropdown.dart';
import 'package:kemsu_app/UI/views/prep_schedule/prep_schedule_view.dart';
import 'package:kemsu_app/UI/views/rating_of_students/views/ros_detail_view.dart';
import 'package:kemsu_app/UI/views/rating_of_students/ros_model.dart';
import 'package:stacked/stacked.dart';
import '../../../../Configurations/localizable.dart';
import '../../../widgets.dart';
import '../../ordering_information/ordering_information_main/ordering_information_main_view.dart';
import '../ros_view_model.dart';

class RosView extends StatelessWidget {
  const RosView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RosViewModel>.reactive(
        onViewModelReady: (viewModel) => viewModel.onReady(),
        viewModelBuilder: () => RosViewModel(context),
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
                child: Scaffold(
                  extendBody: true,
                  extendBodyBehindAppBar: true,
                  appBar: customAppBar(context, Localizable.rosTitle),
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
                      : _rosView(context, model),
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
      mainDropdown(context,
          value: model.studyCard,
          items: model.receivedStudyCard.map<DropdownMenuItem<StudyCard>>((e) {
            return DropdownMenuItem<StudyCard>(
              value: e,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(e.groupName.toString()),
              ),
            );
          }).toList(),
          textHint: Localizable.orderingInformationMainChooseStudyCard, onChanged: (value) {
        model.circle = true;
        model.notifyListeners();
        model.changeCard(value);
      }),
      const SizedBox(height: 10),
      model.studyCard?.id != null ? getListView(model) : const SizedBox.shrink()
    ],
  );
}

Widget getListView(RosViewModel model) {
  return ListView.builder(
    physics: const NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    itemCount: model.rosSemesterList.length,
    itemBuilder: (context, index) {
      final item = model.rosSemesterList[index];
      return Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 10, bottom: 15, right: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).primaryColor,
                boxShadow: [BoxShadow(color: Theme.of(context).primaryColorLight, blurRadius: 15, offset: const Offset(0, 15), spreadRadius: -15)]),
            child: Theme(
              data: ThemeData(dividerColor: Colors.transparent),
              child: ExpansionTile(
                collapsedIconColor: Colors.blue,
                initiallyExpanded: index == 0 ? true : false,
                expandedAlignment: Alignment.centerRight,
                title: Text(
                  "${Localizable.semester}: ${item.semester}",
                  style: TextStyle(color: Theme.of(context).primaryColorDark, fontFamily: "Ubuntu", fontSize: 17, fontWeight: FontWeight.bold),
                ),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          richText(Localizable.orderingInformationStudyYear, "${item.startDate}-${item.endDate}", context),
                          const SizedBox(height: 10),
                          richText(Localizable.rosRating, "${item.commonScore}", context),
                          const SizedBox(height: 10),
                          mainButton(context, onPressed: () async {
                            await model.getReitList(item.startDate, item.endDate, item.semester);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RosDetailView(
                                        reitList: model.reitList,
                                        semester: item.semester != null ? item.semester! : 1,
                                      )),
                            );
                          }, title: Localizable.mainMore, isPrimary: true)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    },
  );
}
