import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../Configurations/localizable.dart';
import '../../ordering_information/ordering_information_main/ordering_information_main_view.dart';
import '../info_view_model.dart';
import 'info_disc_view.dart';
import 'package:stacked/stacked.dart';

import '../../../common_widgets.dart';

class InfoOUProView extends StatelessWidget {
  const InfoOUProView({super.key});

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
              appBar: customAppBar(context, Localizable.infoTitle),
              body: _infoOUProView(context, model),
            ),
          );
        });
  }
}

_infoOUProView(BuildContext context, InfoOUProViewModel model) {
  return ListView(
    children: <Widget>[
      const SizedBox(height: 12),
      Row(
        children: <Widget>[
          const SizedBox(
            width: 10,
          ),
          Text(
            Localizable.infoShowAll,
            style: const TextStyle(fontSize: 17.0),
          ),
          const SizedBox(width: 10), //SizedBox
          Checkbox(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2.0),
              ),
              side: WidgetStateBorderSide.resolveWith(
                    (states) => BorderSide(width: 1.2, color: Color(Theme.of(context).primaryColorDark.value)),
              ),
              checkColor: Colors.white,
              fillColor: WidgetStateProperty.all(Colors.blue),
              value: model.isChecked,
              onChanged: (e) {
                model.isChecked = !model.isChecked;
                if (model.isChecked) {
                  model.getDiscs(1);
                } else {
                  model.getDiscs(0);
                }
              }),
        ],
      ),
      Center(
        child: SingleChildScrollView(padding: const EdgeInsets.all(8.0), child: _getInfoOUProView(model)),
      ),
      Center(child: model.course.isEmpty ? Text(Localizable.infoWithoutDisciplines, style: const TextStyle(fontSize: 16)) : const SizedBox())
    ],
  );
}

Widget _getInfoOUProView(InfoOUProViewModel model) {
  return ListView.builder(
    physics: const NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    itemCount: model.course.length,
    itemBuilder: (context, index) {
      final item = model.course[index];
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    await model.getDiscReports(item.courseId);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => InfoOUProRepView(discData: item, repList: model.report)),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        richText(Localizable.infoDiscipline, item.discName ?? "", context, isWhite: true),
                        const SizedBox(height: 10),
                        richText(Localizable.infoTeacher, item.fio ?? "", context, isWhite: true),
                      ],
                    ),
                  )),
            ),
          ),
        ],
      );
    },
  );
}
