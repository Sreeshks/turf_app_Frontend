import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:turf2/Api/baseurl.dart';

class LoginApi {
  Future<String> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${BaseUrl.baseUrl}${BaseUrl.login}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return responseData['message'] as String;
      } else {
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to login');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }
}
