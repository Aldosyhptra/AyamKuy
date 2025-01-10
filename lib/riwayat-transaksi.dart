import 'package:cihuy/struk.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'keranjang.dart';
import 'package:http/http.dart' as http;

class TransactionHistoryPage extends StatefulWidget {
  @override
  _TransactionHistoryPageState createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
  List<TransactionDetails> transactionDetails = [];
  bool isLoading = true;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(248, 255, 0, 0),
        title: const Text(
          "Riwayat Transaksi",
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
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : transactionDetails.isEmpty
              ? const Center(
                  child: Text(
                    "Tidak ada data transaksi",
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : ListView.builder(
                  itemCount: transactionDetails.length,
                  itemBuilder: (context, index) {
                    final transaction = transactionDetails[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                StrukPage(insertId: transaction.id),
                          ),
                        );
                      },
                      child: Card(
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Kiri: Detail Item
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Nama Paket
                                  Text(
                                    transaction.items
                                        .map((item) => item.title)
                                        .join(", "),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(248, 255, 0, 0),
                                    ),
                                  ),
                                  const SizedBox(height: 4.0),
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
                      ),
                    );
                  },
                ),
    );
  }
}
