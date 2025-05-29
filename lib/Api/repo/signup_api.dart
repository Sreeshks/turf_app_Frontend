import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:turf2/Api/baseurl.dart';

class SignupApi {
  Future<String> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${BaseUrl.baseUrl}${BaseUrl.signup}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return responseData['message'] as String;
      } else {
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to signup');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }
}
