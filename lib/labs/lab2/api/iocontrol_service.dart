import 'dart:convert';
import 'package:http/http.dart' as http;

class IoControlService {
  final String board;
  final String variable;
  final String accessKey; // empty if not required

  const IoControlService({
    required this.board,
    required this.variable,
    this.accessKey = '',
  });

  String _keySuffix() => accessKey.isNotEmpty ? '?key=$accessKey' : '';

  Uri _readUri() => Uri.parse(
      'https://iocontrol.ru/api/readData/$board/$variable${_keySuffix()}');

  Uri _sendUri(int value) => Uri.parse(
      'https://iocontrol.ru/api/sendData/$board/$variable/$value${_keySuffix()}');

  Future<int> readValue() async {
    final response = await http.get(_readUri());
    if (response.statusCode != 200) {
      throw Exception('HTTP ${response.statusCode}');
    }
    final Map<String, dynamic> body = jsonDecode(response.body);
    if (body['check'] != true) {
      throw Exception(body['message']?.toString() ?? 'Unknown error');
    }
    final String valueStr = body['value']?.toString() ?? '0';
    return int.tryParse(valueStr) ?? 0;
  }

  Future<int> setValue(int value) async {
    final response = await http.get(_sendUri(value));
    if (response.statusCode != 200) {
      throw Exception('HTTP ${response.statusCode}');
    }
    final Map<String, dynamic> body = jsonDecode(response.body);
    if (body['check'] != true) {
      throw Exception(body['message']?.toString() ?? 'Unknown error');
    }
    final String valueStr = body['value']?.toString() ?? value.toString();
    return int.tryParse(valueStr) ?? value;
  }
}



