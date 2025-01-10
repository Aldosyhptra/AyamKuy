import 'dart:convert';
import 'package:http/http.dart' as http;

class User {
  final String email;
  final String password;
  final String nama;

  User({required this.email, required this.password, required this.nama});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      password: json['password'],
      nama: json['nama'],
    );
  }
}

class ApiService {
  static const String apiUrlUser =
      "http://localhost/api/ambildata.php"; // Ganti dengan URL server Anda

  static Future<bool> fetchUsers(String email, String password) async {
    try {
      final response = await http.get(Uri.parse(apiUrlUser));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'success') {
          List users = data['data'];

          // Periksa apakah email dan password cocok
          for (var user in users) {
            if (user['email'] == email && user['password'] == password) {
              return true; // Login berhasil
            }
          }
          return false; // Login gagal
        } else {
          throw Exception("Gagal mengambil data pengguna");
        }
      } else {
        throw Exception("Server tidak merespons dengan benar");
      }
    } catch (e) {
      print("Error: $e");
      throw Exception("Terjadi kesalahan saat mencoba menghubungi server");
    }
  }

  static Future<String?> fetchUserName(String email, String password) async {
    try {
      final response = await http.get(Uri.parse(apiUrlUser));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'success') {
          List users = data['data'];

          // Periksa apakah email dan password cocok
          for (var user in users) {
            if (user['email'] == email && user['password'] == password) {
              return user['nama']; // Mengembalikan nama pengguna
            }
          }
          return null; // Tidak ditemukan pengguna dengan email dan password tersebut
        } else {
          throw Exception("Gagal mengambil data pengguna");
        }
      } else {
        throw Exception("Server tidak merespons dengan benar");
      }
    } catch (e) {
      print("Error: $e");
      throw Exception("Terjadi kesalahan saat mencoba menghubungi server");
    }
  }
}
