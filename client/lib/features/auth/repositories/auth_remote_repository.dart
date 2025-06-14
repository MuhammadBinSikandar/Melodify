import 'dart:async';
import 'package:client/core/constants/server_constant.dart';
import 'package:client/core/failure/failure.dart';
import 'package:client/features/auth/model/user_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_remote_repository.g.dart';

@riverpod
// ignore: deprecated_member_use_from_same_package
AuthRemoteRepository authRemoteRepository(AuthRemoteRepositoryRef ref) {
  return AuthRemoteRepository();
}

class AuthRemoteRepository {
  // final String baseUrl = "http://10.113.73.153:8000";
  final String baseUrl = "http://192.168.100.96:8000";

  Future<Either<AppFailure, UserModel>> signup({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final Uri url = Uri.parse('${ServerConstant.serverURL}/auth/signup');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'email': email, 'password': password, 'name': name}),
      );
      final resBodyMap = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 201) {
        return Left(AppFailure(resBodyMap['detail']));
      }
      print('✅ Signup successful');
      return Right(UserModel.fromMap(resBodyMap['user']));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, UserModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      final Uri url = Uri.parse('${ServerConstant.serverURL}/auth/login');

      final Map<String, dynamic> requestBody = {
        'email': email,
        'password': password,
      };

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(requestBody),
      );
      final resBodyMap = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode != 200) {
        return Left(AppFailure(resBodyMap['detail']));
      }
      print('✅ Login successful');
      return Right(
        UserModel.fromMap(
          resBodyMap['user'],
        ).copyWith(token: resBodyMap['token']),
      );
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, UserModel>> getCurrentUserData({
    required String usertoken,
  }) async {
    try {
      final Uri url = Uri.parse('${ServerConstant.serverURL}/auth/');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'x-auth-token': usertoken,
        },
      );
      final resBodyMap = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode != 200) {
        return Left(AppFailure(resBodyMap['detail']));
      }
      print('✅ Login successful');
      return Right(UserModel.fromMap(resBodyMap).copyWith(token: usertoken));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}
