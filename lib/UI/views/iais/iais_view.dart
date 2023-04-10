import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../ordering information/ordering_information_main_view.dart';
import './iais_viewmodel.dart';
import './iais_disc_view.dart';
import 'package:stacked/stacked.dart';

import '../../widgets.dart';

class IaisView extends StatelessWidget {
  const IaisView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<IaisViewModel>.reactive(
        onModelReady: (viewModel) => viewModel.onReady(),
        viewModelBuilder: () => IaisViewModel(context),
        builder: (context, model, child) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.dark),
            child: Scaffold(
              extendBody: true,
              extendBodyBehindAppBar: true,
              appBar: customAppBar(context, model, 'ИнфОУПро'),
              body: _iaisView(context, model),
            ),
          );
        });
  }
}

_iaisView(BuildContext context, IaisViewModel model) {
  return ListView(
    children: <Widget>[
      const SizedBox(height: 12),
      Row(
        children: <Widget>[
          const SizedBox(
            width: 10,
          ),
          const Text(
            'Показать все ',
            style: TextStyle(fontSize: 17.0),
          ),
          const SizedBox(width: 10), //SizedBox
          Checkbox(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2.0),
              ),
              side: MaterialStateBorderSide.resolveWith(
                (states) => BorderSide(width: 1.2, color: Color(Theme.of(context).primaryColorDark.value)),
              ),
              checkColor: Colors.white,
              fillColor: MaterialStateProperty.all(Colors.blue),
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
        child: SingleChildScrollView(padding: const EdgeInsets.all(8.0), child: getIaisView(model)),
      ),
    ],
  );
}

Widget getIaisView(IaisViewModel model) {
  return ListView.builder(
    physics: const NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    itemCount: model.Course.length,
    itemBuilder: (context, index) {
      final item = model.Course[index];
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.centerLeft),
                  onPressed: () async {
                    await model.getDiscReports(item.courseId);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => IaisRepView(discData: item, repList: model.Report)),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        richText("Дисциплина: ", "${item.discName}", context),
                        const SizedBox(height: 10),
                        richText("Преподаватель: ", "${item.fio}", context),
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
