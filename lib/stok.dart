import 'package:cihuy/keranjang.dart';
import 'package:cihuy/menu.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class StokPage extends StatefulWidget {
  @override
  _StokPageState createState() => _StokPageState();
}

class _StokPageState extends State<StokPage> {
  // Dummy data untuk stok
  List<StokItem> stokItems = [];
  List<dynamic> stoks = [];

  @override
  void initState() {
    super.initState();
    fetchMenuStoks();
  }

  Future<void> fetchMenuStoks() async {
    try {
      final response =
          await http.get(Uri.parse('http://localhost/api/tampil-stok.php'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          // Mengambil list data langsung dari JSON response
          stoks = List<Map<String, dynamic>>.from(data['data']);
        });
      } else {
        throw Exception('Failed to load menu');
      }
    } catch (e) {
      print('Error fetching menu: $e');
    }
  }

  Future<void> savestokItems() async {
    final prefs = await SharedPreferences.getInstance();
    // Mengubah stokItems menjadi JSON sebelum menyimpannya
    final stokItemsJson = stokItems.map((item) => item.toJson()).toList();
    await prefs.setString('stokItems', jsonEncode(stokItemsJson));
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Berhasil menyimpan pesanan stok')));
  }

// Fungsi untuk menambah item ke keranjang
  void addToCart(String nama) {
    final existingIndex = stokItems.indexWhere((item) => item.nama == nama);

    if (existingIndex != -1) {
      setState(() {
        stokItems[existingIndex].incrementQuantity();
      });
    } else {
      setState(() {
        stokItems.add(StokItem(nama: nama));
      });
    }

    savestokItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Stok"),
          backgroundColor: Color.fromARGB(248, 255, 0, 0),
        ),
        body: ListView.builder(
          itemCount: stoks.length,
          itemBuilder: (context, index) {
            final item = stoks[index];
            return Card(
              margin: const EdgeInsets.all(8.0),
              color: Color.fromARGB(248, 255, 0, 0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: ListTile(
                title: Text(
                  item['nama'], // Access 'nama' property of StokItem
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
                subtitle: Text(
                  "Jumlah: ${item['jumlah']}", // Access 'jumlah' property of StokItem
                  style: const TextStyle(color: Colors.white),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.add, color: Colors.white),
                  onPressed: () =>
                      addToCart(item['nama']), // Pass 'nama' property
                ),
              ),
            );
          },
        ),
        floatingActionButton: CircleAvatar(
          radius: 30,
          backgroundColor: Color.fromARGB(248, 255, 0, 0),
          child: IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartStokPage(
                    stokItems: stokItems,
                  ),
                ),
              );
            },
          ),
        ));
  }
}

class CartStokPage extends StatefulWidget {
  final List<StokItem> stokItems;

  CartStokPage({required this.stokItems});

  @override
  _CartStokPageState createState() => _CartStokPageState();
}

class _CartStokPageState extends State<CartStokPage> {
  List<StokItem> stokItems = [];

  void initState() {
    super.initState();
    loadstokItems();
  }

  Future<void> loadstokItems() async {
    final prefs = await SharedPreferences.getInstance();
    final stokItemsString = prefs.getString('stokItems');
    if (stokItemsString != null) {
      final stokItemsJson = jsonDecode(stokItemsString) as List;
      setState(() {
        stokItems =
            stokItemsJson.map((item) => StokItem.fromJson(item)).toList();
      });
      print(widget.stokItems.map((item) => item.toJson()).toList());
    }
  }

  void updateCartInPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final stokItemsJson =
        widget.stokItems.map((item) => item.toJson()).toList();
    await prefs.setString('stokItems', jsonEncode(stokItemsJson));
  }

  void decrementItemjumlah(StokItem stokItem) {
    setState(() {
      final index =
          widget.stokItems.indexWhere((item) => item.nama == stokItem.nama);
      if (index != -1) {
        if (widget.stokItems[index].jumlah > 1) {
          widget.stokItems[index] = StokItem(
            nama: stokItem.nama,
            jumlah: stokItem.jumlah - 1,
          );
        } else {
          widget.stokItems.removeAt(index);
        }
        updateCartInPreferences();
      }
    });
  }

  Future<void> submitPemesanan() async {
    final String apiUrl = 'http://localhost/api/update-stok.php';

    // Menyusun data CartItems untuk dikirimkan
    List<Map<String, dynamic>> cartData = widget.stokItems.map((item) {
      return {
        'nama': item.nama, // Mengambil 'nama' dari objek cartItem
        'jumlah': item.jumlah, // Mengambil 'jumlah' dari objek cartItem
      };
    }).toList();

    // Membuat request POST ke API
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'CartItems': cartData,
      }),
    );

    // Memeriksa status dari respons
    if (response.statusCode == 200) {
      // Jika berhasil
      print('Pemesanan berhasil');
      print(response.body);
    } else {
      // Jika gagal
      print('Terjadi kesalahan: ${response.statusCode}');
    }
  }

  Future<void> clearStokItem() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('stokItems');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Keterangan",
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
          Expanded(
            child: Container(
              color: const Color.fromARGB(255, 255, 255, 255),
              child: ListView.builder(
                itemCount: widget.stokItems.length,
                itemBuilder: (context, index) {
                  final cartItem = widget.stokItems[index];
                  return Card(
                    color: const Color.fromARGB(248, 255, 0, 0),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: ListTile(
                      title: Text(
                        cartItem.nama,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Jumlah: ${cartItem.jumlah}',
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            child: IconButton(
                              icon: const Icon(Icons.remove,
                                  color: const Color.fromARGB(248, 255, 0, 0)),
                              onPressed: () => decrementItemjumlah(cartItem),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: const BoxDecoration(
              color: const Color.fromARGB(248, 255, 0, 0),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        submitPemesanan();
                        clearStokItem();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                      },
                      child: const Text(
                        'Pesan Stok',
                        style: TextStyle(
                            color: const Color.fromARGB(248, 255, 0, 0),
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
