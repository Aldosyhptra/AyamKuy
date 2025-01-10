import 'package:cihuy/struk.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'keranjang.dart';

class PaymentScreen extends StatefulWidget {
  final List<CartItem> cartItems;

  PaymentScreen({required this.cartItems});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedPaymentMethod = "DANA";
  @override
  void initState() {
    super.initState();
    loadCartItems();
  }

  Future<void> submitPembayaran() async {
    final String apiUrl = 'http://localhost/api/pencatatan-transaksi.php';

    final cartData = widget.cartItems.map((item) => item.toJson()).toList();
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'CartItems': cartData,
        'metode': _selectedPaymentMethod,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        final insertedId = int.parse(data['inserted_id'].toString());
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => StrukPage(insertId: insertedId),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red.withOpacity(0.5),
            content: Text('Error: ${data['message']}'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red.withOpacity(0.5),
          content: Text('Gagal tersambung ke server'),
        ),
      );
    }
  }

  Future<void> loadCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final cartItemsString = prefs.getString('cartItems');
    if (cartItemsString != null) {
      final cartItemsJson = jsonDecode(cartItemsString) as List;
      setState(() {
        widget.cartItems.clear();
        widget.cartItems.addAll(
          cartItemsJson.map((item) => CartItem.fromJson(item)).toList(),
        );
      });
      print(widget.cartItems.map((item) => item.toJson()).toList());
    }
  }

  Future<void> clearCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('cartItems');
  }

  @override
  Widget build(BuildContext context) {
    int totalPrice = widget.cartItems
        .fold(0, (sum, item) => sum + (item.price * item.quantity));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Pesanan",
          style: TextStyle(
            color: Color.fromARGB(248, 255, 0, 0),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color.fromARGB(248, 255, 0, 0)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color.fromARGB(248, 255, 0, 0),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Rp.$totalPrice',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Metode Pembayaran",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                PaymentOptionTile(
                  "DANA",
                  _selectedPaymentMethod == "DANA",
                  () => setState(() => _selectedPaymentMethod = "DANA"),
                ),
                PaymentOptionTile(
                  "OVO",
                  _selectedPaymentMethod == "OVO",
                  () => setState(() => _selectedPaymentMethod = "OVO"),
                ),
                PaymentOptionTile(
                  "Go-Pay",
                  _selectedPaymentMethod == "Go-Pay",
                  () => setState(() => _selectedPaymentMethod = "Go-Pay"),
                ),
                PaymentOptionTile(
                  "ShopeePay",
                  _selectedPaymentMethod == "ShopeePay",
                  () => setState(() => _selectedPaymentMethod = "ShopeePay"),
                ),
                PaymentOptionTile(
                  "Cash",
                  _selectedPaymentMethod == "Cash",
                  () => setState(() => _selectedPaymentMethod = "Cash"),
                ),
              ],
            ),
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color.fromARGB(248, 255, 0, 0),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30),
                topLeft: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Rp.$totalPrice',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      submitPembayaran();
                      clearCartItems();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      "Bayar Sekarang",
                      style: TextStyle(
                        color: Color.fromARGB(248, 255, 0, 0),
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PaymentOptionTile extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onSelect;

  PaymentOptionTile(this.label, this.isSelected, this.onSelect);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Color.fromARGB(248, 255, 0, 0) : Colors.grey,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: Color.fromARGB(248, 255, 0, 0),
              ),
          ],
        ),
      ),
    );
  }
}
