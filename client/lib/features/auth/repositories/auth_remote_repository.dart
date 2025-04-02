import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fpdart/fpdart.dart';

class AuthRemoteRepository {
  final String baseUrl = "http://192.168.100.11:8000";
  Future<Either<Failure, Map<String, dynamic>>> signup({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final Uri url = Uri.parse('$baseUrl/auth/signup');

      final Map<String, dynamic> requestBody = {
        'email': email,
        'password': password,
        'name': name,
      };

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode != 201) {
        return Left(response.body);
      }
      print('✅ Signup successful');
      final user = jsonDecode(response.body) as Map<String, dynamic>;
      return Right(user);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<void> login({required String email, required String password}) async {
    try {
      final Uri url = Uri.parse('$baseUrl/auth/login');

      final Map<String, dynamic> requestBody = {
        'email': email,
        'password': password,
      };

      print('Attempting login...');
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

      if (response.statusCode == 200) {
        print('✅ Login successful');
      } else {
        print('❌ Login failed with status ${response.statusCode}');
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
      print('❗ Unexpected error during login');
      print('Error details: $e');
    }
  }
}
