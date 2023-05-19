import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  String url = 'https://reqres.in/';
  Future Post(endpoint, data) async {
    try {
      var response = await http.post(
        Uri.parse(url + endpoint),
        body: data,
        headers: {
          'Content-type': 'application/json',
          'Accept': '*/*',
        },
      );
      return jsonDecode(response.body);
    } catch (e) {
      print("Error Occured in Main Post Method");
      print(e);
    }
  }

  Future loginUser(email, password) async {
    dynamic data = jsonEncode(<dynamic, dynamic>{
      "email": email,
      "password": password,
    });
    Map<dynamic, dynamic> response = await Post('api/login', data);
    return response;
  }

  Future registerUser(email, password) async {
    dynamic data = jsonEncode(<dynamic, dynamic>{
      "email": email,
      "password": password,
    });
    Map<dynamic, dynamic> response = await Post('api/register', data);
    return response;
  }

  Future<dynamic> fetchData() async {
    final response =
        await http.get(Uri.parse('https://reqres.in/api/users?page=2'));
    return jsonDecode(response.body);
  }
}
