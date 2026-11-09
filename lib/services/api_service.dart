import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../models/post.dart';
import '../models/user.dart';
import '../utils/logger.dart';

/// Service untuk komunikasi HTTP dengan REST API.
///
/// Menangani semua request HTTP, termasuk penanganan error dan timeout.
class ApiService {
  final http.Client _client;
  final String _baseUrl;

  ApiService({http.Client? client, String? baseUrl})
      : _client = client ?? http.Client(),
        _baseUrl = baseUrl ?? AppConfig.baseUrl;

  /// Mengambil daftar pengguna dari API.
  Future<List<User>> getUsers() async {
    final data = await _getJson('/users') as List<dynamic>;
    return data
        .map((e) => User.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Mengambil pengguna berdasarkan [id].
  Future<User> getUserById(int id) async {
    final data = await _getJson('/users/$id') as Map<String, dynamic>;
    return User.fromJson(data);
  }

  /// Mengambil daftar post dari API (Latihan 1).
  ///
  /// Mengembalikan [List<Post>] jika berhasil.
  Future<List<Post>> getPosts() async {
    final data = await _getJson('/posts') as List<dynamic>;
    return data
        .map((e) => Post.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Melakukan GET ke [endpoint] dan mengembalikan hasil decode JSON.
  ///
  /// Semua error diubah menjadi [Exception] dengan pesan ramah pengguna
  /// (tidak membocorkan detail internal).
  Future<dynamic> _getJson(String endpoint) async {
    try {
      Logger.debug('GET $endpoint');
      final response = await _client
          .get(Uri.parse('$_baseUrl$endpoint'), headers: _buildHeaders())
          .timeout(const Duration(seconds: AppConfig.timeoutSeconds));
      Logger.info('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      throw HttpStatusException(response.statusCode);
    } on HttpStatusException catch (e) {
      Logger.warning('HTTP error ${e.statusCode} pada $endpoint');
      throw Exception('Gagal memuat data. Status: ${e.statusCode}');
    } on TimeoutException {
      throw Exception('Request timeout. Periksa koneksi internet Anda.');
    } on SocketException {
      throw Exception('Tidak ada koneksi internet. Periksa jaringan Anda.');
    } on FormatException {
      throw Exception('Format data tidak valid.');
    } catch (e, st) {
      // Detail teknis hanya ke log (debug), pengguna menerima pesan umum.
      Logger.error('Request gagal: $endpoint', error: e, stackTrace: st);
      throw Exception('Terjadi kesalahan saat memuat data.');
    }
  }

  /// Membangun header request. API key diambil dari konfigurasi.
  Map<String, String> _buildHeaders() => {
        'Content-Type': 'application/json',
        'X-API-Key': AppConfig.apiKey,
      };

  /// Menutup client.
  void dispose() => _client.close();
}

/// Error internal untuk respons HTTP dengan status selain 200.
class HttpStatusException implements Exception {
  final int statusCode;
  const HttpStatusException(this.statusCode);
}