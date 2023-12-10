import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kemsu_app/UI/views/rating_of_students/ros_model.dart';
import 'package:stacked/stacked.dart';
import '../../../../Configurations/localizable.dart';
import '../../../common_widgets.dart';
import '../../ordering_information/ordering_information_main/ordering_information_main_view.dart';
import '../ros_view_model.dart';

class RosDetailItemView extends StatelessWidget {
  const RosDetailItemView({super.key, required this.reitItemList, required this.discipline});

  final String discipline;
  final List<ReitItemList> reitItemList;

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
                  appBar: customAppBar(context, discipline),
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
                      : _rosDetailItemView(context, model, reitItemList),
                ),
              ));
        });
  }
}

_rosDetailItemView(context, RosViewModel model, reitItemList) {
  return ListView(
    children: <Widget>[const SizedBox(height: 10), Padding(padding: const EdgeInsets.all(8.0), child: getListView(reitItemList))],
  );
}

Widget getListView(reitItemList) {
  return ListView.builder(
    physics: const NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    itemCount: reitItemList.length,
    itemBuilder: (context, index) {
      final item = reitItemList[index];
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
                          Text(item.comment != null ? "${item.activityName} (${item.comment})" : "${item.activityName}",
                              style: TextStyle(color: Theme.of(context).primaryColorDark, fontFamily: "Ubuntu", fontSize: 17, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          richText(Localizable.rosDetailItemAmount, "${item.count}", context),
                          const SizedBox(height: 10),
                          richText(Localizable.rosDetailItemMaxScore, "${item.maxBall}", context),
                          const SizedBox(height: 10),
                          richText(Localizable.rosDetailItemYourScore, "${item.ball}", context)
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
