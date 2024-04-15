
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:kemsu_app/Configurations/localizable.dart';
import 'package:kemsu_app/UI/common_widgets.dart';
import 'package:kemsu_app/UI/views/online_courses/courses_bloc.dart';
import 'package:kemsu_app/domain/repositories/features/abstract_features_repository.dart';
import 'package:url_launcher/url_launcher.dart';

class OnlineCourseScreen extends StatefulWidget {
  final bool fromAuthMenu;
  const OnlineCourseScreen({super.key, required this.fromAuthMenu});

  @override
  State<OnlineCourseScreen> createState() => _OnlineCourseScreenState();
}

class _OnlineCourseScreenState extends State<OnlineCourseScreen> {
  final _coursesBloc = CoursesBloc(
    const CoursesState(),
    featuresRepository: GetIt.I<AbstractFeaturesRepository>(),
  );

  @override
  void initState() {
    _coursesBloc.add(LoadCourses());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, Localizable.pageCourses, canBack: widget.fromAuthMenu ? false : true),
      resizeToAvoidBottomInset: true,
      body: BlocBuilder<CoursesBloc, CoursesState>(
        bloc: _coursesBloc,
        builder: (context, state) {
          if (state.courses.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.separated(
            itemCount: state.courses.requiredContent.length,
            itemBuilder: (context, index) {
              var currentCurse = state.courses.requiredContent[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ExpansionTile(
                  title: Text(state.courses.requiredContent[index].title),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(state.courses.requiredContent[index].description ?? ''),
                    ),
                    ListView.builder(
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: currentCurse.lectures.length,
                      itemBuilder: (context, titleIndex) {
                        return Card(
                          surfaceTintColor: Colors.white,
                          elevation: 4.0,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () async => await launchUrl(Uri.parse(currentCurse.lectures[titleIndex].url)),
                                  child: ListTile(
                                    title: Text(currentCurse.lectures[titleIndex].title),
                                    trailing: const Icon(Icons.arrow_forward_ios),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Divider(
                  color: Colors.grey.withOpacity(0.5),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
