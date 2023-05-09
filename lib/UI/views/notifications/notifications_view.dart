import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';

import '../../widgets.dart';
import '../ordering_information/ordering_information_main/ordering_information_main_view.dart';
import 'notifications_view_model.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NotificationViewModel>.reactive(
        onModelReady: (viewModel) => viewModel.onReady(),
        viewModelBuilder: () => NotificationViewModel(context),
        builder: (context, model, child) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
              value: const SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.dark),
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
                  appBar: customAppBar(context, model, 'Уведомления'),
                  body: _notView(context, model),
                ),
              ));
        });
  }
}

Widget _notView(context, NotificationViewModel model) {
  return FutureBuilder(
    future: model.getImageUrls(model.userNotifications),
    builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
      if (snapshot.hasData) {
        List<String> urls = snapshot.data ?? [""];
        return ListView.builder(
          shrinkWrap: true,
          itemCount: model.userNotifications.length,
          itemBuilder: (context, index) {
            final item = model.userNotifications[index];
            return Column(
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
                        // ваш код
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              richText("${item.title}", "", context, isWhite: true),
                              const SizedBox(height: 10),
                              richText("${item.message}", "", context, isWhite: true),
                              const SizedBox(height: 10),
                              richText("${item.notificationDateTime}", "", context, isWhite: true),
                              const SizedBox(height: 10),
                              item.fileSrc != "" && item.fileSize != 0 ? _buildImage(urls[index]) : const SizedBox.shrink(), // отображаем изображение из списка
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      } else {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    },
  );
}

Widget _buildImage(String imageUrl) {
  return Image.network(
    imageUrl,
    width: 200,
    height: 200,
    fit: BoxFit.cover,
  );
}