import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:stacked/stacked.dart';

import '../../../Configurations/localizable.dart';
import '../../widgets.dart';
import '../ordering_information/ordering_information_main/ordering_information_main_view.dart';
import 'notifications_view_model.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NotificationViewModel>.reactive(
        onViewModelReady: (viewModel) => viewModel.onReady(),
        viewModelBuilder: () => NotificationViewModel(context),
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
                  appBar: customAppBar(context, model, Localizable.notificationsTitle),
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
                      : _notView(context, model),
                ),
              ));
        });
  }
}

Widget _notView(context, NotificationViewModel model) {
  return model.userNotifications.isEmpty
      ? const CircularProgressIndicator()
      : FutureBuilder(
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
                          child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(12)),
                              child: Padding(
                                padding: const EdgeInsets.all(6),
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      richText("${item.title}", "", context, isWhite: true),
                                      const SizedBox(height: 10),
                                      Text("${item.message}", style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.normal)),
                                      const SizedBox(height: 10),
                                      item.fileSrc != "" && item.fileSize != 0 ? _pictureView(context, urls[index]) : const SizedBox.shrink(),
                                      const SizedBox(height: 10),
                                      Align(
                                          alignment: Alignment.bottomRight,
                                          child: Text("${item.notificationDateTime}", style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.normal)))
                                    ],
                                  ),
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

_pictureView(BuildContext context, url) {
  return GestureDetector(
    onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (_) {
        return Scaffold(
          body: Center(
            child: Dismissible(
              key: UniqueKey(),
              direction: DismissDirection.vertical,
              onDismissed: (_) => Navigator.pop(context),
              child: PhotoView(
                loadingBuilder: (context, event) => Center(
                  child: CircularProgressIndicator(
                    color: Colors.blueGrey.shade700,
                  ),
                ),
                scaleStateController: PhotoViewScaleStateController(),
                backgroundDecoration: const BoxDecoration(color: Colors.transparent),
                imageProvider: NetworkImage(url),
                minScale: PhotoViewComputedScale.contained * 0.8,
                maxScale: PhotoViewComputedScale.covered * 2,
              ),
            ),
          ),
        );
      }));
    },
    child: Container(
        margin: const EdgeInsets.all(15),
        child: Image.network(
          url,
          width: 200,
          height: 200,
          fit: BoxFit.cover,
        )),
  );
}
