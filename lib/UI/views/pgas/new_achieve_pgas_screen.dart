import 'package:flutter/material.dart';
import 'package:kemsu_app/UI/views/pgas/model/achieve_category.dart';
import 'package:kemsu_app/UI/views/pgas/model/activity_tree.dart';
import 'package:kemsu_app/UI/views/pgas/new_achieve_pgas_viewmodel.dart';
import 'package:stacked/stacked.dart';

class NewAchievePgasScreen extends StatelessWidget {
  const NewAchievePgasScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NewAchievePgasViewModel>.reactive(
        viewModelBuilder: () => NewAchievePgasViewModel(context),
        onModelReady: (viewModel) => viewModel.onReady(),
        builder: (context, model, child) {
          return Scaffold(
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

_body(context, NewAchievePgasViewModel model) {
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
        Padding(
            padding: const EdgeInsets.all(16),
            child: _achieveCategoryDropDown(context, model),
        ),
        !model.isCategoryChosen ? SizedBox.shrink() : _dropDownList(context, model)
      ],
    ),
  );
}

_title(context) {
  return const Text("Прикрепление достижения",
      style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          color: Colors.blueAccent
      )
  );
}

_achieveCategoryDropDown(context, NewAchievePgasViewModel model) {
  return Container(
    decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF00C2FF)),
        borderRadius: BorderRadius.circular(10)
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<AchieveCategoryModel>(
          isExpanded: true,
          value: model.chosenCategory,
          items: model.achieveCategories.map<
              DropdownMenuItem<AchieveCategoryModel>>((e) {
            return DropdownMenuItem<AchieveCategoryModel>(
              child: FittedBox(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(e.activityTypeTitle.toString()),
                ),
              ),
              value: e,
            );
          }).toList(),
          hint: const Center(
              child: Text(
                "Категория достижения",
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    fontStyle: FontStyle.normal
                ),
              )
          ),
          onChanged: (value) {
            model.chosenCategory = value!;
            model.isCategoryChosen = true;
            print(value.activityTypeId);
            model.fetchAchieves(0, value.activityTypeId);
            model.addDropDownWidget(_achieveDropDown(context, model));
            model.notifyListeners();
          }
      ),
    ),
  );
}

_achieveDropDown(context, NewAchievePgasViewModel model) {
  return Container(
    decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF00C2FF)),
        borderRadius: BorderRadius.circular(10)
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<ActivityTreeModel>(
          isExpanded: true,
          value: model.chosenActivity,
          items: model.activityList.map<
              DropdownMenuItem<ActivityTreeModel>>((e) {
            return DropdownMenuItem<ActivityTreeModel>(
              child: FittedBox(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(e.activityTitle.toString()),
                ),
              ),
              value: e,
            );
          }).toList(),
          hint: const Center(
              child: Text(
                "Достижение",
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    fontStyle: FontStyle.normal
                ),
              )
          ),
          onChanged: (value) {
            model.chosenActivity = value!;
            if (value.nodeCnt! > 0) {
              model.fetchAchieves(value.activityId, model.chosenCategory!.activityTypeId);
              model.notifyListeners();
            }
          }
      ),
    ),
  );
}

_dropDownList(context, NewAchievePgasViewModel model) {
  return SizedBox(
    height: 400,
    child: ListView.builder(
        itemCount: model.dropdownsList.length,
        itemBuilder: (context, index) {
          return model.dropdownsList[index];
        }
    ),
  );
}