import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../Configurations/localizable.dart';
import '../../ordering_information/ordering_information_main/ordering_information_main_view.dart';
import '../info_view_model.dart';
import '../info_model.dart';
import 'package:stacked/stacked.dart';

import '../../../widgets.dart';

class InfoOUProTaskBlockView extends StatelessWidget {
  const InfoOUProTaskBlockView({super.key, required this.repData, required this.blockName});
  final List<TaskListInfoOUPro> repData;
  final String blockName;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<InfoOUProViewModel>.reactive(
        onViewModelReady: (viewModel) => viewModel.onReady(),
        viewModelBuilder: () => InfoOUProViewModel(context),
        builder: (context, model, child) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.dark),
            child: Scaffold(
              extendBody: true,
              extendBodyBehindAppBar: true,
              appBar: customAppBar(context, blockName),
              body: _infoOUProTaskBlockView(context, model, repData),
            ),
          );
        });
  }
}

_infoOUProTaskBlockView(BuildContext context, InfoOUProViewModel model, repData) {
  return ListView(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      children: <Widget>[const SizedBox(height: 12), Padding(padding: const EdgeInsets.only(left: 5, right: 5), child: _getTaskBlockView(repData))]);
}

Widget _getTaskBlockView(repData) {
  return ListView.builder(
    physics: const NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    itemCount: repData.length,
    itemBuilder: (context, index) {
      final item = repData[index];
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
                          Text(item.name, style: TextStyle(color: Theme.of(context).primaryColorDark, fontFamily: "Ubuntu", fontSize: 17, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          richText(Localizable.infoTaskBlockSolution, "${item.solveFlag}", context),
                          const SizedBox(height: 10),
                          richText(Localizable.infoTaskBlockKeyDate, "${item.taskControlDate}", context),
                          const SizedBox(height: 10),
                          richText(Localizable.infoTaskBlockMaxScore, "${item.maxBall}", context),
                          const SizedBox(height: 10),
                          richText(Localizable.infoTaskBlockResult, "${item.sumBall}", context),
                          const SizedBox(height: 10),
                          richText(Localizable.infoTaskBlockState, "${item.solutionStatus}", context)
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
