import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'dio_client.dart';
import 'token_interceptor.dart';

class DioImageService extends StatefulWidget {
  final String url;
  final double width;
  final double height;
  final BoxFit fit;

  const DioImageService({
    super.key,
    required this.url,
    this.width = 100.0,
    this.height = 100.0,
    this.fit = BoxFit.cover,
  });

  @override
  DioImageServiceState createState() => DioImageServiceState();
}

class DioImageServiceState extends State<DioImageService> {
  late DioClient _dioClient;
  late Future<Uint8List?> _imageFuture;
  final DefaultCacheManager _cacheManager = DefaultCacheManager();

  @override
  void initState() {
    super.initState();
    Dio dio = Dio();
    dio.interceptors.add(TokenInterceptor(dio));
    _dioClient = DioClient(dio);
    _imageFuture = _loadImage(widget.url);
  }

  Future<Uint8List?> _loadImage(String url) async {
    try {
      final fileInfo = await _cacheManager.getFileFromCache(url);
      if (fileInfo != null) {
        return await fileInfo.file.readAsBytes();
      }

      final response = await _dioClient.get(
        url,
        options: Options(responseType: ResponseType.bytes),
      );

      if (response.statusCode == 200) {
        await _cacheManager.putFile(url, response.data);
        return response.data;
      }
    } catch (e) {
      print('Failed to load image: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: _imageFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            width: widget.width,
            height: widget.height,
            child: const Center(child: CircularProgressIndicator(color: Colors.blue)),
          );
        } else if (snapshot.hasError) {
          return SizedBox(
            width: widget.width,
            height: widget.height,
            child: const Icon(Icons.error),
          );
        } else if (snapshot.hasData && snapshot.data != null) {
          return ClipOval(
            child: Image.memory(
              snapshot.data!,
              width: widget.width,
              height: widget.height,
              fit: widget.fit,
            ),
          );
        } else {
          return SizedBox(
            width: widget.width,
            height: widget.height,
            child: const Icon(Icons.error),
          );
        }
      },
    );
  }
}
