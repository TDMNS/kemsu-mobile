import 'dart:convert';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';

import '../../../API/config.dart';

class NewsViewModel extends BaseViewModel {
  NewsViewModel(BuildContext context);

  final storage = const FlutterSecureStorage();
  String newsURL = 'https://api-dev.kemsu.ru';
  int selectedIndex = 0;
  int newsLimit = 10;
  bool showNews = false;
  bool fileLoader = false;
  int newsIndex = 0;
  var imageTG;
  String? mimeType;
  List<dynamic>? tempData;
  List<dynamic>? imageFromTG;
  File? file;
  Uint8List? tgImage;
  List<String> textList = [];
  List<IconData> newsIcons = [];
  final player = AudioPlayer();
  Uint8List? tempSound;
  Uint8List? tempPic;
  late VideoPlayerController _controller;

  void onTapBottomBar(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  void fileLoaderChange(value) {
    fileLoader = value;
    notifyListeners();
  }

  Future onReady() async {
    messageService();
  }

  void testMessage(index) async {
    mimeType = null;

    String? partialFileUrl;
    var dio = Dio();
    String? token = await storage.read(key: 'tokenKey');
    final newsResponse = await http.get(
        Uri.parse('${Config.newsMessages}?limit=$newsLimit'),
        headers: {'x-access-token': token!});
    tempData = json.decode(newsResponse.body);
    partialFileUrl = json.decode(newsResponse.body)[index][0]['partialFileUrl'];

    for (int i = 0; i < tempData!.length; i++) {
      var temp = tempData![i][0]['message'];
      //print(temp);
      // temp != null
      //     ? print(
      //         'MESSAGE:: ${tempData![i][0]['message']}, DATA:: ${temp['mimeType']}')
      //     : print('MESSAGE:: ${tempData![i][0]['message']}');
    }
    print(tempData![index][0]['file']['mimeType']);
    if (tempData![index][0]['file'] != null) {
      mimeType = tempData![index][0]['file']['mimeType'];
      if (mimeType == 'image/jpeg') {
        getPicture(partialFileUrl);
      } else if (mimeType == 'audio/mpeg') {
        getAudio(partialFileUrl);
      }
    } else {
      mimeType = null;
    }
    notifyListeners();
  }

  changeIndex(index) {
    newsIndex = index;
    notifyListeners();
  }

  getAudio(partialFileUrl) async {
    String? token = await storage.read(key: 'tokenKey');
    String fileURL = 'https://api-dev.kemsu.ru$partialFileUrl';

    Map<String, dynamic> map = {'x-access-token': token};

    final getFile = await http.get(Uri.parse('$fileURL&thumbSize=y'),
        headers: {'x-access-token': token!});
    tempSound = getFile.bodyBytes;
    print(tempSound);
  }

  getPicture(partialFileUrl) async {
    String? token = await storage.read(key: 'tokenKey');
    String fileURL = 'https://api-dev.kemsu.ru$partialFileUrl';

    Map<String, dynamic> map = {'x-access-token': token};

    final getFile = await http.get(Uri.parse('$fileURL&thumbSize=y'),
        headers: {'x-access-token': token!});
    tempPic = getFile.bodyBytes;
    fileLoader = false;
    notifyListeners();
  }

  getVideo() async {}

  void openNewsCard() async {}

  void newsOnOff(value) async {
    showNews = value;
    notifyListeners();
  }

  String getTimeStringFromDouble(int value) {
    if (value < 0) return 'Invalid Value';
    int flooredValue = value.floor();
    int decimalValue = value - flooredValue;
    String hourValue = getHourString(flooredValue);
    String minuteString = getMinuteString(decimalValue);

    return '$hourValue:$minuteString';
  }

  String getMinuteString(int decimalValue) {
    return '${(decimalValue * 60).toInt()}'.padLeft(2, '0');
  }

  String getHourString(int flooredValue) {
    return '${flooredValue % 24}'.padLeft(2, '0');
  }

  messageService() async {
    String? partialFileUrl;
    var dio = Dio();
    String? token = await storage.read(key: 'tokenKey');
    final newsResponse = await http.get(
        Uri.parse('${Config.newsMessages}?limit=100'),
        headers: {'x-access-token': token!});
    tempData = json.decode(newsResponse.body);
    //partialFileUrl = json.decode(newsResponse.body)[0][0]['partialFileUrl'];

    for (int i = 0; i < tempData!.length; i++) {
      var file = tempData![i][0]['file'];

      if (file != null) {
        if (file['mimeType'] == 'image/jpeg' &&
            tempData![i][0]['message'] == '') {
          textList.add('Открыть фото');
          newsIcons.add(Icons.image);
        } else if (file['mimeType'] == 'audio/mpeg' &&
            tempData![i][0]['message'] == '') {
          textList.add('Открыть аудио');
          newsIcons.add(Icons.audiotrack);
        } else if (file['mimeType'] == 'video/mp4' &&
            tempData![i][0]['message'] == '') {
          textList.add('Открыть видео');
          newsIcons.add(Icons.video_collection_rounded);
        } else {
          textList.add(tempData![i][0]['message']);
          newsIcons.add(Icons.newspaper);
        }
      } else {
        textList.add(tempData![i][0]['message']);
        newsIcons.add(Icons.newspaper);
      }
    }

    for (int i = 0; i < tempData!.length; i++) {
      if (tempData![i][0]['file'] != null) {
        print(tempData![i][0]['partialFileUrl']);
        partialFileUrl = tempData![i][0]['partialFileUrl'];
      }
    }
    String fileURL = 'https://api-dev.kemsu.ru$partialFileUrl';

    Map<String, dynamic> map = {'x-access-token': token};

    final restFile = await dio.get(fileURL,
        options: Options(headers: {'x-access-token': token}),
        queryParameters: {'thumbSize': 'y'});
    final getFile = await http.get(Uri.parse('$fileURL&thumbSize=y'),
        headers: {'x-access-token': token});

    imageTG = Image.memory(getFile.bodyBytes).image;
    tgImage = getFile.bodyBytes;
    print(getFile.bodyBytes);
    notifyListeners();
  }
}

// Image.memory(
// Uint8List.fromList(model.tgImage!),
// width: 250,
// height: 250,
// fit: BoxFit.contain,
// )
