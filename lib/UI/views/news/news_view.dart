import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import 'package:photo_view/photo_view.dart';
import '../../widgets.dart';
import 'news_view_model.dart';

class NewsView extends StatefulWidget {
  const NewsView({Key? key}) : super(key: key);

  @override
  State<NewsView> createState() => _NewsViewState();
}

class _NewsViewState extends State<NewsView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NewsViewModel>.reactive(
        onViewModelReady: (viewModel) => viewModel.onReady(),
        viewModelBuilder: () => NewsViewModel(context),
        builder: (context, model, child) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
              value: const SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarIconBrightness: Brightness.dark),
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
                  appBar: customAppBar(context, model, 'Новости'),
                  body: _newsView(context, model),
                ),
              ));
        });
  }

  _newsView(context, NewsViewModel model) {
    return Stack(
      children: [
        ListView(
          children: [
            ListView.builder(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 50, bottom: 100),
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemCount: model.textList.length,
                reverse: false,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      model.fileLoaderChange(true);
                      model.testMessage(index);
                      model.newsOnOff(true);
                      model.videoPlayFunc(false);
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
                                offset: const Offset(0, 15),
                                spreadRadius: -15),
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
                            style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColorDark),
                          ))
                        ],
                      ),
                    ),
                  );
                }),
          ],
        ),
        model.showNews == true ? _currentNewsView(context, model, model.newsIndex) : const SizedBox()
      ],
    );
  }

  _currentNewsView(BuildContext context, NewsViewModel model, newsIndex) {
    return Stack(
      children: [
        Container(
          color: Colors.black.withOpacity(0.6),
        ),
        Container(
          margin: EdgeInsets.only(top: MediaQuery.of(context).size.width / 3, left: 15, right: 15, bottom: 40),
          decoration:
              BoxDecoration(borderRadius: BorderRadius.circular(30), color: Theme.of(context).primaryColor, boxShadow: [
            BoxShadow(
                color: Theme.of(context).primaryColorLight,
                blurRadius: 15,
                offset: const Offset(0, 15),
                spreadRadius: -15),
          ]),
          child: Stack(
            children: [
              ListView(
                padding: const EdgeInsets.only(top: 30),
                children: <Widget>[
                  model.mimeType == 'image/jpeg'
                      ? _pictureView(context, model, newsIndex)
                      : model.mimeType == 'audio/mpeg'
                          ? _audioPlayer(context, model, newsIndex)
                          : model.mimeType == 'video/mp4'
                              ? _videoPreviewView(context, model, newsIndex)
                              : const SizedBox(),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                      child: Padding(
                    padding: const EdgeInsets.only(left: 25, right: 25, top: 30, bottom: 40),
                    child: Text(model.textList[newsIndex]),
                  )),
                  GestureDetector(
                    onTap: () async {
                      await model.player.stop();
                      model.newsOnOff(false);
                    },
                    child: Container(
                      height: 30,
                      margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width / 3, right: MediaQuery.of(context).size.width / 3),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Theme.of(context).primaryColorDark,
                          boxShadow: [
                            BoxShadow(
                                color: Theme.of(context).primaryColorLight,
                                blurRadius: 15,
                                offset: const Offset(0, 15),
                                spreadRadius: -15),
                          ]),
                      child: Center(
                          child: Text(
                        'Закрыть',
                        style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
              IconButton(
                  onPressed: () async {
                    await model.player.stop();
                    model.newsOnOff(false);
                  },
                  icon: const Icon(Icons.close))
            ],
          ),
        ),
      ],
    );
  }

  _audioPlayer(BuildContext context, NewsViewModel model, newsIndex) {
    return model.fileLoader == true
        ? Container(
            margin: EdgeInsets.only(
                top: 10, left: MediaQuery.of(context).size.width / 2.5, right: MediaQuery.of(context).size.width / 2.5),
            height: 50,
            child: const CircularProgressIndicator(
              color: Colors.blue,
            ))
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                  onPressed: () async {
                    await model.player.audioCache.clearAll();
                    model.tempSound == null
                        ? const Center(child: CircularProgressIndicator(color: Colors.blue))
                        : model.stopOrPause == false
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
                    model.pauseOrStop(true);

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
                    model.pauseOrStop(false);
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
                top: 10, left: MediaQuery.of(context).size.width / 2.5, right: MediaQuery.of(context).size.width / 2.5),
            height: 50,
            child: const CircularProgressIndicator(
              color: Colors.blue,
            ))
        : GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return Scaffold(
                  body: Center(
                    child: Dismissible(
                      key: UniqueKey(),
                      direction: DismissDirection.vertical,
                      onDismissed: (_) => Navigator.pop(context),
                      child: PhotoView(
                        loadingBuilder: (context, event) => const Center(
                          child: CircularProgressIndicator(
                            color: Colors.blue,
                          ),
                        ),
                        scaleStateController: PhotoViewScaleStateController(),
                        backgroundDecoration: const BoxDecoration(color: Colors.transparent),
                        imageProvider: model.newsImage,
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
              child: Image.memory(
                Uint8List.fromList(model.tempPic!),
                fit: BoxFit.contain,
              ),
            ),
          );
  }

  _videoPreviewView(BuildContext context, NewsViewModel model, newsIndex) {
    return model.fileLoader == true
        ? Container(
            margin: EdgeInsets.only(
                top: 10, left: MediaQuery.of(context).size.width / 2.5, right: MediaQuery.of(context).size.width / 2.5),
            height: 50,
            child: const CircularProgressIndicator(
              color: Colors.blue,
            ))
        : Stack(
            children: [
              Container(
                  margin: const EdgeInsets.only(left: 30, right: 30, top: 20),
                  height: 180,
                  child: Image.memory(
                    Uint8List.fromList(model.tempPic!),
                    fit: BoxFit.contain,
                  )),
              Container(
                margin: const EdgeInsets.only(left: 30, right: 30, top: 20),
                height: 180,
                color: Colors.black.withOpacity(0.7),
              ),
              Center(
                  child: Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 10),
                child: IconButton(
                  onPressed: () {
                    model.getVideo(context, newsIndex);
                  },
                  icon: const Icon(
                    Icons.play_circle,
                    size: 40,
                  ),
                  color: Colors.white,
                ),
              )),
              model.videoLoader
                  ? Center(
                      child: Padding(
                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 10),
                      child: const SizedBox(
                        height: 50,
                        width: 50,
                        child: CircularProgressIndicator(
                          color: Colors.blue,
                        ),
                      ),
                    ))
                  : Container()
            ],
          );
  }
}
