import 'package:cihuy/menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'apiconnect.dart';

void main() {
  runApp(
    ScreenUtilInit(
      designSize:
          Size(360, 690), // Ubah ukuran desain sesuai dengan kebutuhan Anda
      builder: (context, child) => MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showErrorDialog("Email dan password tidak boleh kosong.");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    Future<void> saveUser(String username) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('namauser', username);
    }

    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    try {
      bool isAuthenticated = await ApiService.fetchUsers(email, password);
      if (isAuthenticated) {
        String? fetchedUserName =
            await ApiService.fetchUserName(email, password);
        if (fetchedUserName != null) {
          saveUser(fetchedUserName);
        }
        if (fetchedUserName != null) {}
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login Berhasil')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => HomePage()),
        // );
      } else {
        _showErrorDialog("Login gagal. Periksa kembali data Anda.");
      }
    } catch (error) {
      _showErrorDialog("Terjadi kesalahan. Silakan coba lagi nanti.");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Kesalahan"),
          content: Text(message),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: 1.sh,
        // Menggunakan tinggi layar penuh
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween, // Meletakkan di bagian bawah
          children: [
            Container(
              margin: EdgeInsets.only(top: 20.h),
              child: Image.asset(
                'assets/images/logo.png', // Path gambar, pastikan gambar ada di folder ini
                width: 180.w,
                height: 180.h,
              ),
            ),
            // Bagian form login
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Color(0xFFF80404),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  topRight: Radius.circular(20.r),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, // Menyesuaikan dengan isi
                children: [
                  Center(
                    child: Text(
                      ' " AyamKuy " ',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Center(
                    child: Text(
                      'Selamat datang kembali',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Color.fromARGB(255, 255, 255, 1),
                      ),
                    ),
                  ),
                  SizedBox(height: 40.h),
                  Center(
                    child: Container(
                      width: 0.8.sw,
                      child: TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email),
                          hintText: 'Email',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Center(
                    child: Container(
                      width: 0.8.sw,
                      child: TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          hintText: 'Kata sandi',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40.h),
                  _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              _handleLogin();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              shadowColor: Colors.black,
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 15.h),
                            ),
                            child: Text(
                              'Masuk',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                  SizedBox(height: 5.h),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        // Aksi untuk lupa kata sandi
                      },
                      child: Text(
                        'Lupa kata sandi?',
                        style: TextStyle(
                          color: Color(0xFFF4EEA9),
                          fontSize: 14.sp,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 55.h),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        // Aksi untuk Daftar
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Tidak punya akun?',
                            style: TextStyle(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              fontSize: 14.sp,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          Text(
                            'Daftar disini',
                            style: TextStyle(
                              color: Color(0xFFF4EEA9),
                              fontSize: 14.sp,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
