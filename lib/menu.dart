import 'package:cihuy/drawer.dart';
import 'package:cihuy/pembayaran.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'keranjang.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userName = "Tidak Ada Nama";
  List<dynamic> menuItems = [];

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
    fetchMenuItems();
    readUser();
  }

  Future<void> fetchMenuItems() async {
    try {
      // Ganti URL berikut dengan endpoint API kamu
      final response =
          await http.get(Uri.parse('http://localhost/api/ambilpaket.php'));

      if (response.statusCode == 200) {
        // Parse data JSON dari API
        final data = json.decode(response.body);
        setState(() {
          menuItems = data['data']; // Simpan data menu ke dalam list
        });
      } else {
        throw Exception('Failed to load menu');
      }
    } catch (e) {
      print('Error fetching menu: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: Container(
          decoration: BoxDecoration(
            color: Color((0xFFF80404)),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
          child: AppBar(
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ayam Mrothol Ambarbinangun',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Jl. Gatak',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Color(0xFFF4EEA9),
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 13.w,
                      backgroundImage: AssetImage('assets/images/logo.png'),
                    ),
                    Text(
                      userName, // Jika userName null, tampilkan 'Loading...'
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFF4EEA9),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      drawer: DrawerPad(),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 16.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Container(
                decoration: BoxDecoration(
                  color: Color((0xFFF80404)),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search,
                        color: const Color.fromARGB(255, 255, 255, 255)),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Cari...',
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                            color: const Color.fromARGB(255, 255, 255, 255)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.h),
            menuItems.isEmpty
                ? Center(
                    child:
                        CircularProgressIndicator()) // Tampilkan loading jika data belum ada
                : Expanded(
                    child: ListView.builder(
                      itemCount: menuItems.length,
                      itemBuilder: (context, index) {
                        final item = menuItems[index];
                        return buildMenuItem(
                            context,
                            item['paket'],
                            "assets/images/${item['paket']}/${item['gambar']}",
                            item['paket']);
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

Widget buildMenuItem(
    BuildContext context, String title, String imagePath, String paketmenu) {
  return Card(
    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    color: Color((0xFFF80404)),
    child: Padding(
      padding: EdgeInsets.only(left: 2, top: 2, bottom: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 120, // Ukuran container 120x120
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white, // Latar belakang putih pada container
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
            ),
            child: Align(
              alignment: Alignment.center, // Memposisikan gambar di tengah
              child: Image.asset(
                imagePath,
                width: 110, // Ukuran gambar 100x100
                height: 110,
                fit: BoxFit
                    .contain, // Gambar akan menyesuaikan ukuran tanpa mengubah rasio
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(
                      top: 20, left: 15), // Margin hanya di atas
                  child: Text(
                    'paket ${title}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: const Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Container(
                  margin: EdgeInsets.only(top: 12),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(79, 0, 0, 0),
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(
                          10), // Gunakan Radius.circular untuk sudut tertentu
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Text(
                          'selengkapnya',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 16), // Margin kanan
                        child: Transform(
                          transform: Matrix4.rotationY(
                              3.14159), // Efek mirror (flip horizontal)
                          alignment: Alignment.center,
                          child: IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios, // Ikon yang dibalik
                              size: 30,
                              color: const Color.fromARGB(255, 255, 255, 255),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MenuPaket(paket: paketmenu)),
                              );
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class MenuPaket extends StatefulWidget {
  final String paket;

  MenuPaket({required this.paket});

  @override
  _MenuPaketState createState() => _MenuPaketState();
}

class _MenuPaketState extends State<MenuPaket> {
  List<dynamic> menuItems = [];
  List<CartItem> cartItems = [];

  @override
  void initState() {
    super.initState();
    fetchMenuItems();
    loadCartItems();
  }

  Future<void> fetchMenuItems() async {
    try {
      final response = await http.get(Uri.parse(
          'http://localhost/api/ambildaftarmenu.php?paket=${widget.paket}'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          menuItems = data['data'];
        });
      } else {
        throw Exception('Failed to load menu');
      }
    } catch (e) {
      print('Error fetching menu: $e');
    }
  }

  Future<void> saveCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final cartItemsJson = cartItems.map((item) => item.toJson()).toList();
    await prefs.setString('cartItems', jsonEncode(cartItemsJson));
  }

  Future<void> loadCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final cartItemsString = prefs.getString('cartItems');
    if (cartItemsString != null) {
      final cartItemsJson = jsonDecode(cartItemsString) as List;
      setState(() {
        cartItems =
            cartItemsJson.map((item) => CartItem.fromJson(item)).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(248, 255, 0, 0),
        flexibleSpace: Center(
          child: Text(
            'Paket Crispy',
            style: TextStyle(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(248, 255, 0, 0),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search,
                        color: const Color.fromARGB(255, 255, 255, 255)),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Cari...',
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                            color: const Color.fromARGB(255, 255, 255, 255)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 32),
            // List of items
            menuItems.isEmpty
                ? Center(child: CircularProgressIndicator())
                : Expanded(
                    child: ListView.builder(
                      itemCount: menuItems.length,
                      itemBuilder: (context, index) {
                        final item = menuItems[index];
                        return buildMenuItem(
                          item['nama'],
                          item['deskripsi'],
                          'assets/images/${item['paket']}/${item['gambar']}',
                          item['harga'],
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
      floatingActionButton: cartItems.isNotEmpty
          ? CircleAvatar(
              radius: 30,
              backgroundColor: Color.fromARGB(248, 255, 0, 0),
              child: IconButton(
                icon: Icon(Icons.shopping_cart, color: Colors.white),
                onPressed: () {
                  // Navigasi ke halaman keranjang
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CartPage(cartItems: cartItems),
                    ),
                  );
                },
              ),
            )
          : null,
    );
  }

  Widget buildMenuItem(
      String title, String description, String imagePath, int price) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      color: const Color.fromARGB(248, 255, 0, 0),
      child: Padding(
        padding: EdgeInsets.all(2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Align(
                alignment: Alignment.center,
                child: Image.asset(
                  imagePath,
                  width: 110,
                  height: 110,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment
                      .center, // Pastikan elemen sejajar vertikal
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment
                            .center, // Konten teks berada di tengah vertikal
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: const Color.fromARGB(255, 255, 255, 1),
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            description,
                            style: TextStyle(
                              color: const Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Rp $price',
                            style: TextStyle(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment
                          .center, // Tombol berada di tengah vertikal
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          child: IconButton(
                            icon: Icon(Icons.add, color: Colors.black),
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      TambahMenuPage(nama: title),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TambahMenuPage extends StatefulWidget {
  final String nama;

  TambahMenuPage({required this.nama});

  @override
  _TambahMenuPageState createState() => _TambahMenuPageState();
}

class _TambahMenuPageState extends State<TambahMenuPage> {
  String _selectedFlavor = 'Pedas';
  String _selectedPortion = 'Sedang';
  List<CartItem> cartItems = [];
  List<dynamic> menuItem = [];

  @override
  void initState() {
    super.initState();
    fetchMenuItems();
    loadCartItems();
  }

  Future<void> fetchMenuItems() async {
    try {
      final response = await http.get(
          Uri.parse('http://localhost/api/ambilmenu.php?nama=${widget.nama}'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          // Mengambil list data langsung dari JSON response
          menuItem = List<Map<String, dynamic>>.from(data['data']);
        });
      } else {
        throw Exception('Failed to load menu');
      }
    } catch (e) {
      print('Error fetching menu: $e');
    }
  }

  Future<void> saveCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final cartItemsJson = cartItems.map((item) => item.toJson()).toList();
    await prefs.setString('cartItems', jsonEncode(cartItemsJson));
  }

  Future<void> loadCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final cartItemsString = prefs.getString('cartItems');
    if (cartItemsString != null) {
      final cartItemsJson = jsonDecode(cartItemsString) as List;
      setState(() {
        cartItems =
            cartItemsJson.map((item) => CartItem.fromJson(item)).toList();
      });
    }
  }

  void addToCart(String title, String paket, String imagePath, int price,
      String rasa, String portion) {
    final existingIndex = cartItems.indexWhere((item) =>
        item.title == title && item.rasa == rasa && item.portion == portion);

    if (existingIndex != -1) {
      setState(() {
        cartItems[existingIndex].incrementQuantity();
      });
    } else {
      setState(() {
        cartItems.add(CartItem(
            title: title,
            paket: paket,
            imagePath: imagePath,
            price: price,
            rasa: rasa,
            portion: portion));
      });
    }

    saveCartItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(248, 255, 0, 0),
        title: Text(
          '${menuItem.isNotEmpty ? menuItem[0]['nama'] : 'Loading...'}',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: menuItem.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(248, 255, 0, 0),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(100),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                      ),
                      child: Container(
                        height: 230,
                        width: 230,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              'assets/images/${menuItem[0]['paket']}/${menuItem[0]['gambar']}',
                            ),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${menuItem[0]['nama']}',
                          style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(248, 255, 0, 0),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Rp.${menuItem[0]['harga']}',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(248, 255, 0, 0),
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Pilihan Rasa',
                          style: TextStyle(
                              color: Color.fromARGB(248, 255, 0, 0),
                              fontSize: 18),
                        ),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(248, 255, 0, 0),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Color.fromARGB(248, 255, 0, 0),
                              width: 1,
                            ),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: DropdownButton<String>(
                            value: _selectedFlavor,
                            isExpanded: true,
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedFlavor = newValue!;
                              });
                            },
                            items: <String>['Pedas', 'Original']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 255, 255, 1)),
                                ),
                              );
                            }).toList(),
                            dropdownColor: Color.fromARGB(248, 255, 0, 0),
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Porsi',
                          style: TextStyle(
                              color: Color.fromARGB(248, 255, 0, 0),
                              fontSize: 18),
                        ),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(248, 255, 0, 0),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Color.fromARGB(248, 255, 0, 0),
                              width: 1,
                            ),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: DropdownButton<String>(
                            value: _selectedPortion,
                            isExpanded: true,
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedPortion = newValue!;
                              });
                            },
                            items: <String>['Sedang', 'Besar']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 255, 255, 1)),
                                ),
                              );
                            }).toList(),
                            dropdownColor: Color.fromARGB(248, 255, 0, 0),
                          ),
                        ),
                        Spacer(), // Tambahkan spacer agar elemen berikutnya berada di bawah
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.shopping_cart,
                                color: Color.fromARGB(248, 255, 0, 0),
                                size: 50,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CartPage(
                                      cartItems: cartItems,
                                    ),
                                  ),
                                );
                              },
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                addToCart(
                                  menuItem[0]['nama'],
                                  menuItem[0]['paket'],
                                  menuItem[0]['gambar'],
                                  menuItem[0]['harga'],
                                  _selectedFlavor,
                                  _selectedPortion,
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Berhasil Menambahkan ${menuItem[0]['nama']}'),
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.add,
                                size: 50,
                                color: Colors.white,
                              ),
                              label: Text(
                                'Tambahkan',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromARGB(248, 255, 0, 0),
                              ),
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

class CartPage extends StatefulWidget {
  final List<CartItem> cartItems;

  CartPage({required this.cartItems});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  void updateCartInPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final cartItemsJson =
        widget.cartItems.map((item) => item.toJson()).toList();
    await prefs.setString('cartItems', jsonEncode(cartItemsJson));
  }

  void decrementItemQuantity(CartItem cartItem) {
    setState(() {
      final index = widget.cartItems.indexWhere((item) =>
          item.title == cartItem.title &&
          item.rasa == cartItem.rasa &&
          item.portion == cartItem.portion);
      if (index != -1) {
        if (widget.cartItems[index].quantity > 1) {
          widget.cartItems[index] = CartItem(
            title: cartItem.title,
            paket: cartItem.paket,
            price: cartItem.price,
            rasa: cartItem.rasa,
            portion: cartItem.portion,
            quantity: cartItem.quantity - 1,
            imagePath: cartItem.imagePath,
          );
        } else {
          widget.cartItems.removeAt(index);
        }
        updateCartInPreferences();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    int totalPrice = widget.cartItems
        .fold(0, (sum, item) => sum + (item.price * item.quantity));

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
                itemCount: widget.cartItems.length,
                itemBuilder: (context, index) {
                  final cartItem = widget.cartItems[index];
                  return Card(
                    color: const Color.fromARGB(248, 255, 0, 0),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              'assets/images/${cartItem.paket}/${cartItem.imagePath}',
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cartItem.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  cartItem.rasa,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Rp.${cartItem.price}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
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
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Rp.$totalPrice',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              PaymentScreen(cartItems: widget.cartItems)),
                    );
                  },
                  child: const Text(
                    'Pesan',
                    style: TextStyle(
                        color: const Color.fromARGB(248, 255, 0, 0),
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
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
