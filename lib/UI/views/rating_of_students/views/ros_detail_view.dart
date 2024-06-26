import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kemsu_app/UI/common_views/main_button.dart';
import 'package:kemsu_app/UI/views/rating_of_students/views/ros_detail_item_view.dart';
import 'package:kemsu_app/UI/views/rating_of_students/ros_model.dart';
import 'package:stacked/stacked.dart';
import '../../../../Configurations/localizable.dart';
import '../../../common_widgets.dart';
import '../../ordering_information/ordering_information_main/ordering_information_main_view.dart';
import '../ros_view_model.dart';

class RosDetailView extends StatelessWidget {
  const RosDetailView({super.key, required this.reitList, required this.semester});

  final int semester;
  final List<ReitList> reitList;

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
                  appBar: customAppBar(context, '${Localizable.semester} $semester'),
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
                      : _rosDetailView(context, model, reitList),
                ),
              ));
        });
  }
}

_rosDetailView(context, RosViewModel model, reitList) {
  return ListView(
    children: <Widget>[const SizedBox(height: 10), Padding(padding: const EdgeInsets.all(8.0), child: getListView(model, reitList))],
  );
}

Widget getListView(RosViewModel model, reitList) {
  return ListView.builder(
    physics: const NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    itemCount: reitList.length,
    itemBuilder: (context, index) {
      final item = reitList[index];
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "${item.discipline}",
                            style: TextStyle(color: Theme.of(context).primaryColorDark, fontFamily: "Ubuntu", fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          richText(Localizable.rosDetailInterimCertificationForm, "${item.intermediateAttestationForm}", context),
                          const SizedBox(height: 10),
                          richText(Localizable.rosDetailCurrentScore, "${item.currentScore}", context),
                          const SizedBox(height: 10),
                          richText(Localizable.rosDetailCertScore, "${item.frontScore}", context),
                          const SizedBox(height: 10),
                          richText(Localizable.rosDetailCommonScore, "${item.commonScore}", context),
                          const SizedBox(height: 10),
                          richText(Localizable.rosDetailMark, item.mark != null ? "${item.mark}" : Localizable.rosDetailNoMark, context),
                          const SizedBox(height: 10),
                          mainButton(context, onPressed: () async {
                            await model.getReitItemList(item.studyId);
                            String safelyDiscipline = item.discipline ?? "";
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => RosDetailItemView(reitItemList: model.reitItemList, discipline: safelyDiscipline)),
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
