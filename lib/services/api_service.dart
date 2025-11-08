import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task.dart';
import '../models/user.dart';

class ApiService {

  static const String baseIp = "10.180.34.1:8080";
  static const String base = "http://$baseIp";



  Future<UserModel> signup(String username, String email, String password) async {
    final res = await http.post(
      Uri.parse("$base/api/auth/signup"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );

    if (res.statusCode == 200 || res.statusCode == 201) {
      return UserModel.fromJson(jsonDecode(res.body));
    } else {
      throw Exception('Signup failed: ${res.body}');
    }
  }

  Future<UserModel> login(String email, String password) async {
    final res = await http.post(
      Uri.parse("$base/api/auth/login"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (res.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(res.body));
    } else {
      throw Exception('Login failed: ${res.body}');
    }
  }


  Future<UserModel> updateUser(int id, String username, String email) async {
    final res = await http.put(
      Uri.parse("$base/api/auth/update/$id"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'email': email,
      }),
    );

    if (res.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(res.body));
    } else {
      throw Exception('Update user failed: ${res.body}');
    }
  }



  Future<List<Task>> fetchTasks(int userId) async {
    final res = await http.get(Uri.parse("$base/api/tasks/$userId"));

    if (res.statusCode == 200) {
      final list = jsonDecode(res.body) as List;
      return list.map((e) => Task.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load tasks: ${res.statusCode}');
    }
  }

  Future<Task> createTask(Task t) async {
    final res = await http.post(
      Uri.parse("$base/api/tasks"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': t.userId,
        'title': t.title,
        'description': t.description,
        'completed': t.completed,
        'dueDate': t.dueDate?.toString(),
      }),
    );

    if (res.statusCode == 200 || res.statusCode == 201) {
      return Task.fromJson(jsonDecode(res.body));
    } else {
      throw Exception('Create failed: ${res.body}');
    }
  }

  Future<Task> updateTask(Task t) async {
    final res = await http.put(
      Uri.parse("$base/api/tasks/${t.id}"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id': t.id,
        'userId': t.userId,
        'title': t.title,
        'description': t.description,
        'completed': t.completed,
        'dueDate': t.dueDate?.toString(),
      }),
    );

    if (res.statusCode == 200) {
      return Task.fromJson(jsonDecode(res.body));
    } else {
      throw Exception('Update failed: ${res.body}');
    }
  }

  Future<void> deleteTask(int id) async {
    final res = await http.delete(Uri.parse("$base/api/tasks/$id"));
    if (res.statusCode != 200 && res.statusCode != 204) {
      throw Exception('Delete failed: ${res.statusCode}');
    }
  }
}
