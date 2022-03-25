enum HttpMethod {
  get,
  post,
}

abstract class NetworkRoute {
  String url();
  HttpMethod get method;
  Map<String, String> headers();
  Map<String, dynamic> parameters();
}
