class ProductModel {
  final String? id; 
  final String nama;
  final int harga;
  final int stok;
  final String kategori; 

  ProductModel({
    this.id, 
    required this.nama, 
    required this.harga, 
    required this.stok,
    required this.kategori, 
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id']?.toString(), 
      nama: json['nama'] ?? '',
      harga: json['harga'] ?? 0,
      stok: json['stok'] ?? 0,
      kategori: json['kategori'] ?? 'Lainnya', 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'nama': nama,
      'harga': harga,
      'stok': stok,
      'kategori': kategori, 
    };
  }
}