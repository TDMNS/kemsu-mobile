class NewsMessageClass {
  int? id;
  int? date;
  String? message;

  NewsMessageClass({this.id, this.date, this.message});

  factory NewsMessageClass.fromJson(Map<String, dynamic> json) {
    return NewsMessageClass(
        id: json['id'], date: json['date'], message: json['message']);
  }
}

class NewsFileClass {
  int? id;
  int? date;
  FileClass? file;
  String? message;
  String? partialFileUrl;

  NewsFileClass(
      {this.id, this.date, this.file, this.message, this.partialFileUrl});

  factory NewsFileClass.fromJson(Map<String, dynamic> json) {
    return NewsFileClass(
        id: json['id'],
        date: json['date'],
        file: FileClass.fromJson(json['file']),
        message: json['message'],
        partialFileUrl: json['partialFileUrl']);
  }
}

class FileClass {
  String? id;
  String? mimeType;
  FileReference? fileReference;
  String? accessHash;
  ThumbsClass? sizes;
  int? size;
  ThumbsClass? thumbs;

  FileClass(
      {this.id,
      this.mimeType,
      this.fileReference,
      this.accessHash,
      this.sizes,
      this.size,
      this.thumbs});

  factory FileClass.fromJson(Map<String, dynamic> json) {
    return FileClass(
        id: json['id'],
        mimeType: json['mimeType'],
        fileReference: FileReference.fromJson(json['fileReference']),
        accessHash: json['accessHash'],
        size: json['sizes'],
        sizes: ThumbsClass.fromJson(json['sizes']),
        thumbs: json[
            'thumbs']); //тут скорее всего не будет работать, надо посмотреть как в расписании парсится массив, я уже иссох прост)0
  }
}

class ThumbsClass {
  String? type;
  int? w;
  int? h;
  int? size;

  ThumbsClass({this.type, this.w, this.h, this.size});

  factory ThumbsClass.fromJson(Map<String, dynamic> json) {
    return ThumbsClass(
        type: json['type'], w: json['w'], h: json['h'], size: json['size']);
  }
}

class FileReference {
  String? type;
  List<int>? data;

  FileReference({this.type, this.data});

  factory FileReference.fromJson(Map<String, dynamic> json) {
    return FileReference(type: json['type'], data: json['data']);
  }
}
