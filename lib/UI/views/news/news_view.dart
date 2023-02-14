import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import 'package:video_player/video_player.dart';

import '../../widgets.dart';
import 'news_viewmodel.dart';
import 'news_viewmodel_test.dart';

class NewsView extends StatefulWidget {
  const NewsView({Key? key}) : super(key: key);

  @override
  State<NewsView> createState() => _NewsViewState();
}

class _NewsViewState extends State<NewsView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NewsViewModel>.reactive(
        onModelReady: (viewModel) => viewModel.onReady(),
        viewModelBuilder: () => NewsViewModel(context),
        builder: (context, model, child) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
              value: const SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarIconBrightness: Brightness
                      .dark), //прозрачность statusbar и установка тёмных иконок
              child: GestureDetector(
                onTap: () {
                  FocusScopeNode currentFocus = FocusScope.of(
                      context); //расфокус textfield при нажатии на экран
                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                },
                child: Scaffold(
                  extendBody: true,
                  extendBodyBehindAppBar: true,
                  appBar: customAppBar(context, model, 'Новости'),
                  //bottomNavigationBar: customBottomBar(context, model),
                  body: _newsView(context, model),
                ),
              ));
        });
  }
}

_newsView(context, NewsViewModel model) {
  return Stack(
    children: [
      ListView(
        children: [
          // GestureDetector(
          //   onTap: () {
          //     model.messageService();
          //   },
          //   child: Container(
          //     margin: EdgeInsets.only(left: 50, right: 50, top: 50),
          //     height: 30,
          //     width: 30,
          //     color: Colors.amber,
          //   ),
          // ),
          // const Center(
          //     child: Padding(
          //   padding: EdgeInsets.only(top: 20),
          //   child: Text(
          //     'Новости отсутствуют',
          //     style: TextStyle(fontSize: 16, color: Colors.grey),
          //   ),
          // )),
          ListView.builder(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 50, bottom: 100),
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              itemCount: model.textList.length,
              // itemCount: 0,
              reverse: false,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    model.fileLoaderChange(true);
                    model.testMessage(index);
                    model.newsOnOff(true);
                    model.changeIndex(index);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.all(10),
                    width: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Theme.of(context).primaryColor,
                        boxShadow: [
                          BoxShadow(
                              color: Theme.of(context).primaryColorLight,
                              blurRadius: 15,
                              offset: const Offset(0, 15)),
                        ]),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            model.testMessage(index);
                          },
                          child: SizedBox(
                            height: 50,
                            width: 50,
                            child: Icon(
                              // Icons.add,
                              model.newsIcons[index],
                              color: Colors.blueGrey,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: Text(
                          model.textList[index].length > 65
                              ? '${model.textList[index].substring(0, 65)}...'
                              : model.textList[index],
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColorDark),
                        ))
                      ],
                    ),
                  ),
                );
              }),
          // GestureDetector(
          //   onTap: () {
          //     model.appMetricaTest();
          //   },
          //   child: Container(
          //     color: Colors.red,
          //     height: 100,
          //   ),
          // ),
        ],
      ),
      model.showNews == true
          ? _currentNewsView(context, model, model.newsIndex)
          : SizedBox()
    ],
  );
}

_currentNewsView(BuildContext context, NewsViewModel model, newsIndex) {
  return Container(
    margin: EdgeInsets.only(
        top: MediaQuery.of(context).size.width / 3,
        left: 15,
        right: 15,
        bottom: 40),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Theme.of(context).primaryColor,
        boxShadow: [
          BoxShadow(
              color: Theme.of(context).primaryColorLight,
              blurRadius: 15,
              offset: const Offset(0, 15)),
        ]),
    child: Stack(
      children: [
        ListView(
          padding: EdgeInsets.only(top: 30),
          children: <Widget>[
            model.mimeType == 'image/jpeg'
                ? _pictureView(context, model, newsIndex)
                : model.mimeType == 'audio/mpeg'
                    ? _audioPlayer(context, model, newsIndex)
                    : model.mimeType == 'video/mp4'
                        ? _videoPlayer(context, model, newsIndex)
                        : SizedBox(),
            SizedBox(
              height: 20,
            ),
            Center(
                child: Padding(
              padding: const EdgeInsets.only(
                  left: 25, right: 25, top: 30, bottom: 40),
              child: Text(model.textList[newsIndex]),
            )),
            GestureDetector(
              onTap: () {
                model.newsOnOff(false);
              },
              child: Container(
                height: 30,
                margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width / 3,
                    right: MediaQuery.of(context).size.width / 3),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Theme.of(context).primaryColorDark,
                    boxShadow: [
                      BoxShadow(
                          color: Theme.of(context).primaryColorLight,
                          blurRadius: 15,
                          offset: const Offset(0, 15)),
                    ]),
                child: Center(
                    child: Text(
                  'Закрыть',
                  style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.bold),
                )),
              ),
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
        IconButton(
            onPressed: () {
              model.newsOnOff(false);
            },
            icon: Icon(Icons.close))
      ],
    ),
  );
}

_videoPlayer(BuildContext context, NewsViewModel model, newsIndex) {
  // model.videoController = VideoPlayerController.network(model.videoURL!);
  return Column(
    children: [
      // VideoPlayer(model.videoController),
      FloatingActionButton(onPressed: () {
        model.videoController.play();
      })
    ],
  );
}

_audioPlayer(BuildContext context, NewsViewModel model, newsIndex) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      IconButton(
          onPressed: () async {
            model.stopOrPause == true
                ? await model.player.play(BytesSource(model.tempSound!))
                : await model.player.resume();
          },
          icon: Icon(
            Icons.play_circle,
            size: 40,
            color: Theme.of(context).primaryColorDark,
          )),
      IconButton(
          onPressed: () async {
            await model.player.pause();
            model.pauseOrStop(false);

            //await model.player.resume();
          },
          icon: Icon(
            Icons.pause_circle,
            size: 40,
            color: Theme.of(context).primaryColorDark,
          )),
      IconButton(
          onPressed: () async {
            await model.player.stop();
            model.pauseOrStop(true);
          },
          icon: Icon(
            Icons.stop_circle,
            size: 40,
            color: Theme.of(context).primaryColorDark,
          )),
    ],
  );
}

_pictureView(BuildContext context, NewsViewModel model, newsIndex) {
  return model.fileLoader == true
      ? Container(
          margin: EdgeInsets.only(
              top: 10,
              left: MediaQuery.of(context).size.width / 2.5,
              right: MediaQuery.of(context).size.width / 2.5),
          height: 50,
          child: CircularProgressIndicator(
            color: Colors.blueGrey.shade700,
          ))
      : Container(
          margin: EdgeInsets.only(left: 30, right: 30, top: 20),
          height: 300,
          child: Image.memory(
            Uint8List.fromList(model.tempPic!),
            fit: BoxFit.contain,
          ));
}
