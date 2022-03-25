class NetworkResponse {
  String? url;
  late int statusCode;
  late bool access;
  String? error;
  Map<String, dynamic> data = <String, dynamic>{};
  String? dataString;

  NetworkResponse(this.statusCode, this.access, this.error);
}
