import 'package:cihuy/menu.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'keranjang.dart';

class StrukPage extends StatefulWidget {
  final int insertId;

  StrukPage({required this.insertId});

  @override
  _StrukPageState createState() => _StrukPageState();
}

class _StrukPageState extends State<StrukPage> {
  TransactionDetails? transactionDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTransactionDetails();
  }

  void _showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15), // Border radius
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(248, 255, 0, 0), // Latar belakang merah
              borderRadius:
                  BorderRadius.circular(15), // Border radius pada container
            ),
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Ukuran kolom sesuai konten
              children: [
                Text(
                  'Berhasil Cetak Struk',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                // Gambar di tengah
                Image.asset(
                  'assets/images/logo.png', // Ganti dengan URL gambar sesuai keinginan
                  height: 150,
                  width: 150,
                ),
                SizedBox(height: 20),
                // Tombol untuk keluar
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                      (route) => false,
                    );
                    ; // Menutup pop-up
                  },
                  child: Text(
                    'Keluar',
                    style: TextStyle(
                      color: Color.fromARGB(248, 255, 0, 0),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Warna teks tombol
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> fetchTransactionDetails() async {
    try {
      final response = await http.get(Uri.parse(
          'http://localhost/api/pengambilan-transaksi.php?id=${widget.insertId}'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> transactionData = responseData['data'];

        if (transactionData.isNotEmpty) {
          setState(() {
            transactionDetails =
                TransactionDetails.fromJson(transactionData.first);
            isLoading = false;
          });
        } else {
          setState(() {
            transactionDetails = null;
            isLoading = false;
          });
        }
      } else {
        throw Exception('Failed to load transaction');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : transactionDetails == null
              ? Center(
                  child: Text(
                    'Transaksi tidak ditemukan.',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : Stack(
                  children: [
                    // Background merah di atas
                    Positioned.fill(
                      child: Column(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(
                              color: Color.fromARGB(248, 255, 0, 0),
                            ),
                          ),
                          Expanded(
                            flex: 7,
                            child: Container(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Konten
                    Positioned.fill(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Teks "Detail Transaksi"
                            const Text(
                              "Detail Transaksi",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Container transaksi
                            Container(
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Color.fromARGB(248, 255, 0, 0),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Column(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor:
                                              Color.fromARGB(248, 255, 0, 0),
                                          radius: 50,
                                          child: Image.asset(
                                            'assets/images/logo.png',
                                            fit: BoxFit.cover,
                                            width: 70, // Ukuran lebar gambar
                                            height: 55, // Ukuran tinggi gambar
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          transactionDetails!.tanggal,
                                          style: const TextStyle(
                                              color: Color.fromARGB(
                                                  248, 255, 0, 0),
                                              fontSize: 14),
                                        ),
                                        const SizedBox(height: 8),
                                        const Divider(
                                            color:
                                                Color.fromARGB(248, 255, 0, 0)),
                                        const SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            CircleAvatar(
                                              backgroundColor: Color.fromARGB(
                                                  248, 255, 0, 0),
                                              radius:
                                                  12, // Ukuran lingkaran untuk ikon centang
                                              child: const Icon(
                                                Icons.check,
                                                color: Colors.white,
                                                size: 16, // Ukuran ikon centang
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            const Text(
                                              'Transaksi Berhasil',
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  ...transactionDetails!.items.map(
                                    (item) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '${item.title} x${item.quantity}',
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromARGB(
                                                    248, 255, 0, 0)),
                                          ),
                                          Text(
                                            'Rp ${item.price * item.quantity}',
                                            style: const TextStyle(
                                              color: Color.fromARGB(
                                                  248, 255, 0, 0),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'Order Id : ${transactionDetails!.id}',
                                    style: const TextStyle(
                                      color: Color.fromARGB(248, 255, 0, 0),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    color: Color.fromARGB(248, 255, 0, 0),
                                    padding: const EdgeInsets.all(7.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Total Pembayaran',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromARGB(
                                                  255, 255, 255, 1)),
                                        ),
                                        Text(
                                          'Rp ${transactionDetails!.totalHarga}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(
                                                255, 255, 255, 1),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Metode Pembayaran : ',
                                          style: const TextStyle(
                                              color: Color.fromARGB(
                                                  248, 255, 0, 0)),
                                        ),
                                        Text(
                                          '${transactionDetails!.metodePembayaran}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromARGB(
                                                  248, 255, 0, 0)),
                                        ),
                                      ]),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Tombol Selesai dan Cetak Struk
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HomePage()),
                                      (route) => false,
                                    );
                                  },
                                  child: const Text(
                                    'Selesai',
                                    style: TextStyle(
                                      color: Color.fromARGB(248, 255, 0, 0),
                                      decoration: TextDecoration.underline,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    _showCustomDialog(context);
                                  },
                                  child: const Text(
                                    'Cetak Struk',
                                    style: TextStyle(
                                      color: Color.fromARGB(248, 255, 0, 0),
                                      decoration: TextDecoration.underline,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}
