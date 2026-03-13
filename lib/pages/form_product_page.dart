import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/supabase_service.dart';

class FormProductPage extends StatefulWidget {
  final ProductModel? product;
  const FormProductPage({super.key, this.product});

  @override
  State<FormProductPage> createState() => _FormProductPageState();
}

class _FormProductPageState extends State<FormProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _hargaController = TextEditingController();
  final _stokController = TextEditingController();
  final _service = SupabaseService();
  bool _isLoading = false;

  final List<String> _kategoriList = ['Makanan Ringan', 'Minuman', 'Obat Herbal', 'Bahan Pokok', 'Lainnya'];
  String _selectedKategori = 'Makanan Ringan';

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _namaController.text = widget.product!.nama;
      _hargaController.text = widget.product!.harga.toString();
      _stokController.text = widget.product!.stok.toString();
      
      if (_kategoriList.contains(widget.product!.kategori)) {
        _selectedKategori = widget.product!.kategori;
      } else {
        _selectedKategori = 'Lainnya';
      }
    }
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    // --- TAMBAHAN LOGIKA CEK PERUBAHAN DATA (KHUSUS EDIT) ---
    if (widget.product != null) {
      bool isNamaSama = _namaController.text.trim() == widget.product!.nama;
      bool isHargaSama = int.parse(_hargaController.text) == widget.product!.harga;
      bool isStokSama = int.parse(_stokController.text) == widget.product!.stok;
      bool isKategoriSama = _selectedKategori == widget.product!.kategori;

      // Kalau tidak ada yang diubah sama sekali
      if (isNamaSama && isHargaSama && isStokSama && isKategoriSama) {
        // Munculkan notifikasi bahwa tidak ada perubahan
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Tidak ada perubahan data yang disimpan."), 
            backgroundColor: Colors.blueGrey, // Warna netral untuk info
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.pop(context); // Tutup halaman
        return; // Hentikan proses simpan ke database
      }
    }
    // --------------------------------------------------------

    setState(() => _isLoading = true);

    try {
      final existingProducts = await _service.getProducts();
      final inputName = _namaController.text.trim().toLowerCase();
      
      bool isDuplicate = existingProducts.any((p) => 
        p.nama.toLowerCase() == inputName && p.id != widget.product?.id
      );

      if (isDuplicate) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Oops! Produk dengan nama tersebut sudah ada."), 
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
          ),
        );
        setState(() => _isLoading = false);
        return;
      }

      final product = ProductModel(
        id: widget.product?.id,
        nama: _namaController.text.trim(),
        harga: int.parse(_hargaController.text),
        stok: int.parse(_stokController.text),
        kategori: _selectedKategori, 
      );

      if (widget.product == null) {
        await _service.addProduct(product);
      } else {
        await _service.updateProduct(product);
      }

      if (!mounted) return;
      // Kirim sinyal "true" kalau beneran berhasil simpan dan ada perubahan
      Navigator.pop(context, true); 
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF1A1D27) : const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF242735) : Colors.blue.shade700,
        elevation: 0,
        title: Text(widget.product == null ? "Tambah Produk" : "Edit Produk", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel("Nama Produk"),
                  _buildTextField(_namaController, "Masukkan nama produk", Icons.shopping_bag_outlined),
                  const SizedBox(height: 20),
                  
                  _buildLabel("Kategori Produk"),
                  DropdownButtonFormField<String>(
                    value: _selectedKategori, 
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.category_outlined, color: Colors.blue.shade700),
                      filled: true,
                      fillColor: isDark ? const Color(0xFF242735) : Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                    items: _kategoriList.map((String kategori) {
                      return DropdownMenuItem(value: kategori, child: Text(kategori));
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedKategori = newValue!;
                      });
                    },
                  ),
                  const SizedBox(height: 20),

                  _buildLabel("Harga (Rp)"),
                  _buildTextField(_hargaController, "0", Icons.payments_outlined, isNumber: true),
                  const SizedBox(height: 20),
                  
                  _buildLabel("Jumlah Stok"),
                  _buildTextField(_stokController, "0", Icons.inventory_2_outlined, isNumber: true),
                  const SizedBox(height: 40),
                  
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: _isLoading ? null : _saveProduct,
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("SIMPAN DATA", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(padding: const EdgeInsets.only(bottom: 8.0), child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)));
  }

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon, {bool isNumber = false}) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.blue.shade700),
        filled: true,
        fillColor: isDark ? const Color(0xFF242735) : Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) return "Field ini wajib diisi";
        
        if (isNumber) {
          final parsedValue = int.tryParse(value);
          if (parsedValue == null) return "Harus berupa angka valid";
          if (parsedValue < 0) return "Tidak boleh menggunakan angka minus (-)";
        }
        
        return null;
      },
    );
  }
}