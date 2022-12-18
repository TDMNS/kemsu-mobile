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
}

class FileClass {
  String? id;
  String? mimeType;
  String? fileReference;
  String? accessHash;
  int? size;
  ThumbsClass? thumbs;

  FileClass(
      {this.id,
      this.mimeType,
      this.fileReference,
      this.accessHash,
      this.size,
      this.thumbs});

  factory FileClass.fromJson(Map<String, dynamic> json) {
    return FileClass(
        id: json['id'],
        mimeType: json['mimeType'],
        fileReference: json['fileReference'],
        accessHash: json['accessHash'],
        size: json['size'],
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
