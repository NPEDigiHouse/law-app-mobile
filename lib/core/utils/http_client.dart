// Package imports:
import 'package:http/http.dart' as http;

class HttpClient {
  static HttpClient? _instance;

  HttpClient._internal() {
    _instance = this;
  }

  factory HttpClient() => _instance ?? HttpClient._internal();

  static http.Client? _clientInstance;

  static http.Client get client {
    return _clientInstance ?? http.Client();
  }
}
