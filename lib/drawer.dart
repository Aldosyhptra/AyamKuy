import 'package:cihuy/hasilpenjualan.dart';
import 'package:cihuy/menu.dart';
import 'package:cihuy/riwayat-transaksi.dart';
import 'package:cihuy/stok.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DrawerPad extends StatefulWidget {
  @override
  _DrawerPadState createState() => _DrawerPadState();
}

class _DrawerPadState extends State<DrawerPad> {
  String userName = "Tidak Ada Nama";

  Future<void> readUser() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedUserName = prefs.getString('namauser');
    if (savedUserName != null) {
      setState(() {
        userName = savedUserName; // Simpan data ke dalam variabel
      });
    }
  }

  void initState() {
    super.initState();
    readUser();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Bagian Header dengan warna berbeda
          Container(
            height: 240.h, // Atur tinggi sesuai kebutuhan
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Color((0xFFF80404)),
              ),
              child: Column(
                children: [
                  // Gambar dan Nama di tengah
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                        width: 80.w,
                        height: 80.h,
                      ),
                    ],
                  ),
                  SizedBox(
                      height: 1), // Menambahkan jarak antara gambar dan teks
                  Center(
                    child: Text(
                      userName, // Ganti teks sesuai kebutuhan
                      style: TextStyle(
                        color: Color(0xFFF4EEA9), // Mengubah warna teks
                        fontSize: 15.sp,
                      ),
                    ),
                  ),
                  SizedBox(height: 3), // Menambahkan jarak antara teks
                  // Menu 2 di kiri
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0), // Menambahkan padding kiri
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment
                            .start, // Mengatur posisi teks di kiri
                        children: [
                          Text(
                            'Ayam Mrothol Ambarbinangun', // Ganti teks sesuai kebutuhan
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white, // Mengubah warna teks
                              fontSize: 13.sp,
                            ),
                          ),
                          SizedBox(height: 3), // Menambahkan jarak antara teks
                          Text(
                            'Jl. Sunan Kudus,Tamantirto, Kec. Kasihan,Bantul', // Ganti teks sesuai kebutuhan
                            style: TextStyle(
                              color: Color(0xFFF4EEA9), // Mengubah warna teks
                              fontSize: 10.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bagian Body dengan warna merah
          Expanded(
            child: Container(
              color: Colors.white, // Warna latar belakang untuk seluruh body
              child: ListView(
                children: [
                  // Menu Home
                  ExpansionTile(
                    leading: Icon(Icons.analytics,
                        color: const Color.fromARGB(255, 0, 0, 0)),
                    title: Text('Menu',
                        style: TextStyle(
                            color: const Color.fromARGB(255, 0, 0, 0))),
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.store,
                            color: const Color.fromARGB(255, 0, 0, 0)),
                        title: Text('Penjualan',
                            style: TextStyle(
                                color: const Color.fromARGB(255, 0, 0, 0))),
                        onTap: () {
                          // Tambahkan aksi untuk menu Penjualan
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    HomePage()), // Ganti dengan halaman Penjualan
                          );
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.article,
                            color: const Color.fromARGB(255, 0, 0, 0)),
                        title: Text('Riwayat Transaksi',
                            style: TextStyle(
                                color: const Color.fromARGB(255, 0, 0, 0))),
                        onTap: () {
                          // Tambahkan aksi untuk menu Struk
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    TransactionHistoryPage()), // Ganti dengan halaman Struk
                          );
                        },
                      ),
                    ],
                  ),
                  ListTile(
                    leading: Icon(Icons.trolley,
                        color: const Color.fromARGB(
                            255, 0, 0, 0)), // Mengubah warna icon
                    title: Text('Stok',
                        style: TextStyle(
                            color: const Color.fromARGB(
                                255, 8, 8, 8))), // Mengubah warna teks
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => StokPage()),
                      );
                    },
                  ),
                  // Menu Stok dengan dropdown
                  // Menu Hasil Penjualan
                  ExpansionTile(
                    leading: Icon(Icons.analytics,
                        color: const Color.fromARGB(255, 0, 0, 0)),
                    title: Text('Hasil Penjualan',
                        style: TextStyle(
                            color: const Color.fromARGB(255, 0, 0, 0))),
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.attach_money,
                            color: const Color.fromARGB(255, 0, 0, 0)),
                        title: Text('Laci Uang',
                            style: TextStyle(
                                color: const Color.fromARGB(255, 0, 0, 0))),
                        onTap: () {
                          // Tambahkan aksi untuk menu Penjualan
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    HomePage()), // Ganti dengan halaman Penjualan
                          );
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.sticky_note_2,
                            color: const Color.fromARGB(255, 0, 0, 0)),
                        title: Text('Ringkasan Penjualan',
                            style: TextStyle(
                                color: const Color.fromARGB(255, 0, 0, 0))),
                        onTap: () {
                          // Tambahkan aksi untuk menu Struk
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    HasilPenjualan()), // Ganti dengan halaman Struk
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
