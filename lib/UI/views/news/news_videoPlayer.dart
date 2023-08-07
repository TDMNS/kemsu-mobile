import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import 'package:video_player/video_player.dart';
import '../../widgets.dart';
import 'news_view_model.dart';

class VideoApp extends StatefulWidget {
  final File? file;
  const VideoApp({Key? key, @required this.file}) : super(key: key);

  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.file!)
      ..addListener(() => setState(() {}))
      ..setLooping(true)
      ..initialize().then((_) => _controller.play());
  }

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
                  appBar: customAppBar(context, model, ''),
                  //bottomNavigationBar: customBottomBar(context, model),
                  body: MaterialApp(
                    home: Scaffold(
                      backgroundColor: Colors.grey.shade900,
                      body: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: _controller.value.isInitialized
                                ? AspectRatio(
                                    aspectRatio: _controller.value.aspectRatio,
                                    child: VideoPlayer(_controller),
                                  )
                                : Container(),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          FloatingActionButton(
                            onPressed: () {
                              setState(() {
                                _controller.value.isPlaying ? _controller.pause() : _controller.play();
                              });
                            },
                            child: Icon(
                              _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ));
        });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
