import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  // GET Request
  Future<dynamic> getRequest(String url) async {
    final response = await http.get(Uri.parse(url));
    return _handleResponse(response);
  }

  // POST Request
  Future<dynamic> postRequest(String url, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  // PUT Request
  Future<dynamic> putRequest(String url, Map<String, dynamic> body) async {
    final response = await http.put(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  // DELETE Request
  Future<dynamic> deleteRequest(String url) async {
    final response = await http.delete(Uri.parse(url));
    return _handleResponse(response);
  }

  // Handle API Response
  dynamic _handleResponse(http.Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }
}
