import 'dart:convert';

class CartItem {
  final String title;
  final String paket;
  final String imagePath;
  final String rasa;
  final String portion;
  final int price; // Harus int
  int quantity; // Harus int

  CartItem({
    required this.title,
    required this.paket,
    required this.imagePath,
    required this.rasa,
    required this.portion,
    required this.price,
    this.quantity = 1,
  });

  void incrementQuantity() {
    quantity++;
  }

  static CartItem fromJson(Map<String, dynamic> json) => CartItem(
        title: json['title'],
        paket: json['paket'],
        imagePath: json['imagePath'],
        price: int.parse(json['price'].toString()), // Pastikan int
        rasa: json['rasa'],
        portion: json['portion'],
        quantity: int.parse(json['quantity'].toString()), // Pastikan int
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'paket': paket,
        'imagePath': imagePath,
        'price': price,
        'rasa': rasa,
        'portion': portion,
        'quantity': quantity,
      };
}

class TransactionDetails {
  final int id;
  final String metodePembayaran;
  final String tanggal;
  final List<CartItem> items;
  final int totalHarga; // Total harga dihitung berdasarkan item

  TransactionDetails({
    required this.id,
    required this.metodePembayaran,
    required this.tanggal,
    required this.items,
    required this.totalHarga,
  });

  factory TransactionDetails.fromJson(Map<String, dynamic> json) {
    // Decode 'data' yang merupakan string JSON
    final List<dynamic> decodedItems = jsonDecode(json['data']);

    // Parse items (cart items)
    List<CartItem> items = [];
    int totalHarga = 0;

    for (var item in decodedItems) {
      if (item is Map<String, dynamic> &&
          item.containsKey('price') &&
          item.containsKey('quantity')) {
        final cartItem = CartItem.fromJson(item);
        items.add(cartItem);
        totalHarga += cartItem.price * cartItem.quantity; // Hitung total harga
      }
    }

    // Ambil metode pembayaran dan tanggal dari decodedItems
    final metodePembayaran = decodedItems.firstWhere(
          (item) =>
              item is Map<String, dynamic> &&
              item.containsKey('metode_pembayaran'),
          orElse: () => {},
        )['metode_pembayaran'] ??
        '';

    final tanggal = decodedItems.firstWhere(
          (item) => item is Map<String, dynamic> && item.containsKey('tanggal'),
          orElse: () => {},
        )['tanggal'] ??
        '';

    return TransactionDetails(
      id: json['id'] ?? 0,
      metodePembayaran: metodePembayaran,
      tanggal: tanggal,
      items: items,
      totalHarga: totalHarga, // Total harga dihitung
    );
  }
}

class StokItem {
  final String nama;
  int jumlah;

  StokItem({
    required this.nama,
    this.jumlah = 1, // Default jumlah 1
  });

  // Method untuk increment jumlah
  void incrementQuantity() {
    jumlah++;
  }

  // Convert StokItem ke Map<String, dynamic> untuk penyimpanan
  Map<String, dynamic> toJson() => {
        'nama': nama,
        'jumlah': jumlah,
      };

  // Convert Map<String, dynamic> ke StokItem
  static StokItem fromJson(Map<String, dynamic> json) => StokItem(
        nama: json['nama'],
        jumlah: json['jumlah'] ?? 1, // Default jika null
      );
}
