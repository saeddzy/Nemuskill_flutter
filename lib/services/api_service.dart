import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async'; // Import for Completer

class ApiService {
  final String _baseUrl = "http://172.20.10.4:8000/api";
  Future<SharedPreferences>? _prefsFuture; // Changed to Future<SharedPreferences>
  String? _currentToken; // In-memory token

  // Private constructor for singleton pattern
  ApiService._();

  // Singleton instance
  static final ApiService _instance = ApiService._();

  // Public factory for getting the instance
  static Future<ApiService> getInstance() async {
    // Initialize _prefsFuture if it's not already initialized
    if (_instance._prefsFuture == null) {
      _instance._prefsFuture = SharedPreferences.getInstance();
      print('ApiService: SharedPreferences instance initialization started.');
    }
    // Ensure the SharedPreferences instance is actually ready
    await _instance._prefsFuture; // Await here to ensure it's ready
    return _instance;
  }

  Future<void> saveToken(String token) async {
    final SharedPreferences prefs = await _prefsFuture!; // Await the future
    _currentToken = token; // Store in memory
    print('ApiService: Attempting to save token: $token to prefs: $prefs (and in memory: $_currentToken)');
    await prefs.setString('auth_token', token);
    print('ApiService: Token saved to SharedPreferences: $token');
  }

  Future<String?> _getToken() async {
    // Prioritize in-memory token if available
    if (_currentToken != null) {
      print('ApiService: Token retrieved from memory: $_currentToken');
      return _currentToken;
    }
    
    final SharedPreferences prefs = await _prefsFuture!; // Await the future
    final String? token = prefs.getString('auth_token');
    _currentToken = token; // Update in-memory if retrieved from prefs
    print('ApiService: Token retrieved from SharedPreferences: $token');
    return token;
  }

  Future<void> _clearToken() async {
    final SharedPreferences prefs = await _prefsFuture!; // Await the future
    _currentToken = null; // Clear from memory
    print('ApiService: Attempting to clear token from prefs: $prefs (and from memory)');
    await prefs.remove('auth_token');
    print('ApiService: Token cleared from SharedPreferences.');
  }

  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> data) async {
    final Map<String, String> headers = {'Content-Type': 'application/json'};
    final String? token = await _getToken();
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    final response = await http.post(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: headers,
      body: json.encode(data),
    );

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> get(String endpoint) async {
    final Map<String, String> headers = {'Content-Type': 'application/json'};
    final String? token = await _getToken(); // Uses _getToken which awaits _prefsFuture
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    final response = await http.get(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: headers,
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> data) async {
    final Map<String, String> headers = {'Content-Type': 'application/json'};
    final String? token = await _getToken(); // Uses _getToken which awaits _prefsFuture
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    final response = await http.put(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: headers,
      body: json.encode(data),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> delete(String endpoint) async {
    final Map<String, String> headers = {'Content-Type': 'application/json'};
    final String? token = await _getToken(); // Uses _getToken which awaits _prefsFuture
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    final response = await http.delete(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: headers,
    );
    return _handleResponse(response);
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data: ${response.statusCode} - ${response.body}');
    }
  }

  Future<String?> getToken() async {
    return _getToken();
  }

  Future<void> clearToken() async {
    await _clearToken();
  }
} 