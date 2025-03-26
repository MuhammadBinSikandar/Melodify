import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthRemoteRepository {
  Future<void> signup({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final String baseUrl = "http://192.168.100.11:8000";
      final Uri url = Uri.parse('$baseUrl/auth/signup');

      final Map<String, dynamic> requestBody = {
        'email': email,
        'password': password,
        'name': name,
      };

      print('Attempting signup...');
      print('Request URL: $url');
      print('Request Body: ${jsonEncode(requestBody)}');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      print('Response Headers: ${response.headers}');

      if (response.statusCode == 201) {
        print('✅ Signup successful');
      } else {
        print('❌ Signup failed with status ${response.statusCode}');
        print('Error Details: ${response.body}');
      }
    } on SocketException catch (e) {
      print('🚨 Socket Exception: Unable to connect to the server');
      print('Error details: $e');
    } on TimeoutException catch (e) {
      print('⏳ Timeout Error: Connection timed out');
      print('Error details: $e');
    } on HttpException catch (e) {
      print('📡 HTTP Exception: ${e.message}');
    } catch (e) {
      print('❗ Unexpected error during signup');
      print('Error details: $e');
    }
  }
}
