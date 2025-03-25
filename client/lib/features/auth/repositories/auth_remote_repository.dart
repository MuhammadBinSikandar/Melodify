import 'package:http/http.dart' as http;

class AuthRemoteRepository {
  Future<void> signup({
    required String email,
    required String password,
    required String name,
  }) async {
    final response = await http.post(
      Uri.parse('http://localhost:8000/auth/signup,'),
      body: {'email': email, 'password': password, 'name': name},
    );
    print(response.body);
  }
}
