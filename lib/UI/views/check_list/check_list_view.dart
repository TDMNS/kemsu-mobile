import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'check_list_viewmodel.dart';
import 'package:stacked/stacked.dart';

import '../../widgets.dart';
import 'check_list_model.dart';

class CheckListView extends StatelessWidget {
  const CheckListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CheckListViewModel>.reactive(
        onModelReady: (viewModel) => viewModel.onReady(),
        viewModelBuilder: () => CheckListViewModel(context),
        builder: (context, model, child) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness
                    .dark),
            child: Scaffold(
              extendBody: true,
              extendBodyBehindAppBar: true,
              appBar: customAppBar(context, model, 'Обходной лист'),
              body: _checkListView(context, model),
            ),
          );
        });
  }
}

_checkListView(BuildContext context, CheckListViewModel model) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: ListView(
      shrinkWrap: true,
      children: [
        const SizedBox(height: 12),
        Wrap(children: [
          Text("Список подразделений", style: Theme.of(context).textTheme.headline5),
          const SizedBox(height: 38),
          getListView(model.checkList)
        ]),
      ]
    ),
  );
}

Widget getListView(List<CheckList> items) {
  return ListView.builder(
    physics: const NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    itemCount: items.length,
    itemBuilder: (context, index) {
      final item = items[index];
      final departmentTitle = item.departmentTitle ?? '';
      final groupName = item.groupName ?? '';
      final address = item.address ?? '';
      return ListTile(
          title: Text(departmentTitle),
          subtitle: Text(groupName + '\n' + address),
          trailing: item.debt == "Нет" ? const Icon(Icons.done, color: Colors.green) : const Icon(Icons.cancel, color: Colors.red)
      );
    },
  );
}