import '../config.dart';
import '../network_route.dart';

class AuthRoute implements NetworkRoute {
  final String login;
  final String password;
  AuthRoute({required this.login, required this.password});

  @override
  url() {
    return Config.apiHost;
  }

  @override
  final method = HttpMethod.post;

  @override
  Map<String, String> headers() {
    return {"Content-Type": "application/json"};
  }

  @override
  Map<String, dynamic> parameters() {
    return {"login": login, "password": password};
  }
}
