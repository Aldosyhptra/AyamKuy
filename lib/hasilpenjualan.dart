import 'package:flutter/material.dart';
import 'dart:convert';
import 'keranjang.dart';
import 'package:http/http.dart' as http;

class HasilPenjualan extends StatefulWidget {
  @override
  _HasilPenjualanState createState() => _HasilPenjualanState();
}

class _HasilPenjualanState extends State<HasilPenjualan> {
  List<TransactionDetails> transactionDetails = [];
  bool isLoading = true;
  bool isPerDay =
      true; // Flag untuk menentukan periode (per hari atau per bulan)

  @override
  void initState() {
    super.initState();
    fetchTransactionData();
  }

  Future<void> fetchTransactionData() async {
    try {
      final response = await http
          .get(Uri.parse('http://localhost/api/tampil-transaksi.php'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> transactions = responseData['data'];

        setState(() {
          transactionDetails = transactions
              .map((transaction) => TransactionDetails.fromJson(transaction))
              .toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load transactions');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Fungsi untuk memeriksa apakah transaksi terjadi hari ini
  bool isTransactionToday(String transactionDate) {
    DateTime now = DateTime.now();
    DateTime transactionDateTime =
        DateTime.parse(transactionDate.split(' ')[0]);
    return now.year == transactionDateTime.year &&
        now.month == transactionDateTime.month &&
        now.day == transactionDateTime.day;
  }

  // Fungsi untuk memeriksa apakah transaksi terjadi pada bulan yang sama
  bool isTransactionThisMonth(String transactionDate) {
    DateTime now = DateTime.now();
    DateTime transactionDateTime =
        DateTime.parse(transactionDate.split(' ')[0]);
    return now.year == transactionDateTime.year &&
        now.month == transactionDateTime.month;
  }

  // Fungsi untuk menampilkan data berdasarkan periode yang dipilih
  List<TransactionDetails> getFilteredTransactions() {
    if (isPerDay) {
      return transactionDetails.where((transaction) {
        return isTransactionToday(transaction.tanggal);
      }).toList();
    } else {
      return transactionDetails.where((transaction) {
        return isTransactionThisMonth(transaction.tanggal);
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(248, 255, 0, 0),
        title: const Text(
          "Ringkasan Penjualan",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isPerDay = true;
                    });
                  },
                  child: Text("Per Hari"),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isPerDay = false;
                    });
                  },
                  child: Text("Per Bulan"),
                ),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : getFilteredTransactions().isEmpty
                    ? const Center(
                        child: Text(
                          "Tidak ada data transaksi",
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        itemCount: getFilteredTransactions().length,
                        itemBuilder: (context, index) {
                          final transaction = getFilteredTransactions()[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 6.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              side: const BorderSide(
                                  color: Color.fromARGB(248, 255, 0, 0)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Kiri: Detail Item
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Tanggal dan Waktu
                                      Text(
                                        '${transaction.tanggal}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Kanan: Harga dan ID
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      // Total Harga
                                      Text(
                                        'Rp${transaction.totalHarga}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(248, 255, 0, 0),
                                        ),
                                      ),
                                      const SizedBox(height: 4.0),
                                      // Order ID
                                      Text(
                                        'Order ID: ${transaction.id}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
