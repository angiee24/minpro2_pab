import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product_model.dart';
import '../services/supabase_service.dart';
import 'form_product_page.dart';
import 'auth_page.dart';

class HomePage extends StatefulWidget {
  final Function toggleTheme;

  const HomePage({super.key, required this.toggleTheme});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final service = SupabaseService();
  
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  List<ProductModel> allProducts = []; 
  List<ProductModel> displayedProducts = []; 
  
  bool isLoading = true;
  String? errorMessage;

  final TextEditingController _searchController = TextEditingController();
  
  String _sortBy = 'Terbaru';
  String _filterStok = 'Semua Stok';
  String _filterKategori = 'Semua Kategori'; 

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future loadData() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });
      final data = await service.getProducts();
      if (!mounted) return;
      setState(() {
        allProducts = data;
        _applyFilters(); 
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  void _applyFilters() {
    List<ProductModel> temp = List.from(allProducts);

    if (_filterKategori != 'Semua Kategori') {
      temp = temp.where((p) => p.kategori == _filterKategori).toList();
    }
    if (_filterStok == 'Tersedia') {
      temp = temp.where((p) => p.stok > 0).toList();
    } else if (_filterStok == 'Stok Menipis') {
      temp = temp.where((p) => p.stok > 0 && p.stok < 5).toList();
    } else if (_filterStok == 'Habis') {
      temp = temp.where((p) => p.stok <= 0).toList();
    }

    String query = _searchController.text.toLowerCase();
    if (query.isNotEmpty) {
      temp = temp.where((p) => p.nama.toLowerCase().contains(query)).toList();
    }

    if (_sortBy == 'Nama (A-Z)') {
      temp.sort((a, b) => a.nama.toLowerCase().compareTo(b.nama.toLowerCase()));
    } else if (_sortBy == 'Harga Terendah') {
      temp.sort((a, b) => a.harga.compareTo(b.harga));
    } else if (_sortBy == 'Harga Tertinggi') {
      temp.sort((a, b) => b.harga.compareTo(a.harga));
    } else if (_sortBy == 'Stok Paling Sedikit') {
      temp.sort((a, b) => a.stok.compareTo(b.stok));
    }

    setState(() {
      displayedProducts = temp;
    });
  }

  Color _getCategoryColor(String kategori) {
    switch (kategori) {
      case 'Makanan Ringan': return Colors.orange;
      case 'Minuman': return Colors.blue;
      case 'Obat Herbal': return Colors.green;
      case 'Bahan Pokok': return Colors.brown;
      default: return Colors.grey;
    }
  }

  Future<void> _logout() async {
    setState(() => isLoading = true);
    try {
      await service.signOut();
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => AuthPage(toggleTheme: widget.toggleTheme)),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal Logout: $e"), backgroundColor: Colors.red),
      );
    }
  }

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text("Konfirmasi Logout"),
          content: const Text("Apakah kamu yakin ingin keluar dari aplikasi?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("Batal", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                Navigator.pop(dialogContext);
                _logout();
              },
              child: const Text("Ya, Keluar", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showProfileDialog() {
    final user = Supabase.instance.client.auth.currentUser;
    final displayName = user?.userMetadata?['display_name'] ?? user?.email ?? "User";

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) { 
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          contentPadding: const EdgeInsets.all(24),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.blue.shade100,
                child: Icon(Icons.person, size: 40, color: Colors.blue.shade800),
              ),
              const SizedBox(height: 16),
              const Text("Login sebagai:", style: TextStyle(color: Colors.grey, fontSize: 12)),
              Text(displayName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 4),
              Text(user?.email ?? "", style: TextStyle(color: Colors.grey.shade600, fontSize: 12)), 
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade600,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  icon: const Icon(Icons.logout),
                  label: const Text("Logout"),
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    _showLogoutConfirmation();
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }

  void konfirmasiHapus(BuildContext context, ProductModel product) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Konfirmasi Hapus"),
          content: Text("Apakah kamu yakin ingin menghapus '${product.nama}'?"),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("Batal", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                Navigator.pop(dialogContext);
                final messenger = ScaffoldMessenger.of(context);
                setState(() => isLoading = true);
                try {
                  await service.deleteProduct(product.id!);
                  messenger.showSnackBar(SnackBar(content: Text("${product.nama} berhasil dihapus"), backgroundColor: Colors.red.shade400));
                } catch (e) {
                  messenger.showSnackBar(SnackBar(content: Text("Gagal hapus: $e"), backgroundColor: Colors.red));
                }
                loadData();
              },
              child: const Text("Hapus", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int totalProduk = allProducts.length;
    int stokHabis = allProducts.where((p) => p.stok <= 0).length;
    int stokMenipis = allProducts.where((p) => p.stok > 0 && p.stok < 5).length;
    
    List<ProductModel> sortedByStock = List.from(allProducts);
    sortedByStock.sort((a, b) => b.stok.compareTo(a.stok)); 
    List<ProductModel> top5Products = sortedByStock.take(5).toList();
    List<ProductModel> top3Products = sortedByStock.take(3).toList();
    double maxStok = top5Products.isEmpty ? 1 : top5Products.first.stok.toDouble();
    if (maxStok == 0) maxStok = 1; 

    bool isDark = Theme.of(context).brightness == Brightness.dark;

    final currentUser = Supabase.instance.client.auth.currentUser;
    final String displayName = currentUser?.userMetadata?['display_name'] ?? (currentUser?.email?.split('@')[0] ?? "User");

    return DefaultTabController(
      length: 2, 
      child: Builder(
        builder: (BuildContext tabContext) {
          return Scaffold(
            key: _scaffoldKey,
            backgroundColor: isDark ? const Color(0xFF1A1D27) : const Color(0xFFF5F6FA),
            
            appBar: AppBar(
              backgroundColor: isDark ? const Color(0xFF242735) : Colors.blue.shade700,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.menu, color: Colors.white),
                onPressed: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
              ),
              title: const Text("Stok Produk UMKM", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18)),
              centerTitle: true,
              actions: [
                IconButton(icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode, color: Colors.white), onPressed: () => widget.toggleTheme()),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _showProfileDialog,
                  child: CircleAvatar(backgroundColor: isDark ? Colors.grey.shade600 : Colors.blue.shade900, child: const Icon(Icons.person, color: Colors.white, size: 20)),
                ),
                const SizedBox(width: 16),
              ],
              bottom: const TabBar(
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white54,
                indicatorColor: Colors.white,
                indicatorWeight: 3,
                tabs: [
                  Tab(icon: Icon(Icons.dashboard_rounded), text: "Dashboard"),
                  Tab(icon: Icon(Icons.inventory_2_rounded), text: "Daftar Produk"),
                ],
              ),
            ),

            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF242735) : Colors.blue.shade700,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.person, size: 30, color: isDark ? const Color(0xFF242735) : Colors.blue.shade700),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "Digitalisasi UMKM",
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 12),
                        ),
                        Text(
                          displayName,
                          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.dashboard_rounded, color: Colors.blue),
                    title: const Text("Dashboard"),
                    onTap: () {
                      Navigator.pop(context); 
                      DefaultTabController.of(tabContext).animateTo(0); 
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.inventory_2_rounded, color: Colors.green),
                    title: const Text("Daftar Produk"),
                    onTap: () {
                      Navigator.pop(context); 
                      DefaultTabController.of(tabContext).animateTo(1); 
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.add_box_rounded, color: Colors.orange),
                    title: const Text("Tambah Produk Baru"),
                    onTap: () async {
                      Navigator.pop(context);
                      final result = await Navigator.push(context, MaterialPageRoute(builder: (_) => const FormProductPage()));
                      if (result == true) {
                        _showSuccessSnackBar("Produk baru berhasil ditambahkan!");
                        loadData(); 
                      }
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.logout_rounded, color: Colors.red),
                    title: const Text("Logout"),
                    onTap: () {
                      Navigator.pop(context);
                      _showLogoutConfirmation();
                    },
                  ),
                ],
              ),
            ),

            body: TabBarView(
              children: [
                RefreshIndicator(
                  onRefresh: loadData,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity, height: 160,
                          color: isDark ? const Color(0xFF1A1D27) : Colors.white,
                          child: Stack(
                            children: [
                              Align(alignment: Alignment.centerRight, child: Padding(padding: const EdgeInsets.all(16.0), child: Image.asset('assets/header_illust.png', fit: BoxFit.contain, errorBuilder: (c, e, s) => const Icon(Icons.image, size: 50, color: Colors.grey)))),
                              Positioned(
                                top: 40, left: 20,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Halo, $displayName! 👋", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
                                    const SizedBox(height: 6),
                                    Text("Digitalisasi UMKM", style: TextStyle(fontSize: 13, height: 1.4, fontWeight: FontWeight.w500, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                          child: Row(
                            children: [
                              Expanded(child: _buildDashboardCard("Total", "$totalProduk", isDark ? Colors.blue.shade700 : Colors.blue.shade500, Icons.inventory_2)),
                              const SizedBox(width: 8),
                              Expanded(child: _buildDashboardCard("Menipis", "$stokMenipis", Colors.orange.shade500, Icons.warning_amber_rounded)),
                              const SizedBox(width: 8),
                              Expanded(child: _buildDashboardCard("Habis", "$stokHabis", Colors.red.shade500, Icons.remove_shopping_cart)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF242735) : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: isDark ? null : Border.all(color: Colors.grey.shade200),
                              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
                            ),
                            child: IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Grafik Stok Barang", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF2C3E50))),
                                        const SizedBox(height: 6),
                                        Divider(height: 1, color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
                                        const SizedBox(height: 6),
                                        Text("Top 5 Terbanyak", style: TextStyle(fontSize: 11, color: isDark ? Colors.grey.shade400 : Colors.grey.shade500)),
                                        const SizedBox(height: 12),
                                        SizedBox(
                                          height: 100,
                                          child: top5Products.isEmpty 
                                            ? const Center(child: Text("Belum ada data", style: TextStyle(color: Colors.grey, fontSize: 12)))
                                            : Row(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: top5Products.map((p) {
                                                  double ratio = p.stok / maxStok;
                                                  return Column(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      Text("${p.stok}", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
                                                      const SizedBox(height: 4),
                                                      _buildBarChartItem(ratio * 60, ratio.clamp(0.4, 1.0), isDark),
                                                      const SizedBox(height: 4),
                                                      Text(p.nama.length > 5 ? "${p.nama.substring(0, 5)}.." : p.nama, style: const TextStyle(fontSize: 9, color: Colors.grey)),
                                                    ],
                                                  );
                                                }).toList(),
                                              ),
                                        ),
                                        Container(height: 2, color: isDark ? Colors.blue.shade900 : Colors.blue.shade100, margin: const EdgeInsets.only(top: 2)),
                                      ],
                                    ),
                                  ),
                                  VerticalDivider(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200, thickness: 1, width: 24),
                                  Expanded(
                                    flex: 4,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Stok Terlaris", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF2C3E50))),
                                        const SizedBox(height: 6),
                                        const Divider(height: 1, color: Colors.transparent), 
                                        const SizedBox(height: 6),
                                        if (top3Products.isEmpty)
                                          const Text("Belum ada data", style: TextStyle(fontSize: 11, color: Colors.grey))
                                        else
                                          ...top3Products.map((product) => Padding(
                                            padding: const EdgeInsets.only(bottom: 8.0),
                                            child: Row(
                                              children: [
                                                Container(width: 10, height: 10, decoration: BoxDecoration(color: _getCategoryColor(product.kategori), borderRadius: BorderRadius.circular(2))),
                                                const SizedBox(width: 6),
                                                Expanded(child: Text(product.nama, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis)),
                                                Text("${product.stok}x", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                              ],
                                            ),
                                          )),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                RefreshIndicator(
                  onRefresh: loadData,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 120.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: TextField(
                              controller: _searchController,
                              onChanged: (value) => _applyFilters(),
                              decoration: InputDecoration(
                                hintText: "Cari nama produk...",
                                prefixIcon: Icon(Icons.search, color: Colors.blue.shade700),
                                filled: true,
                                fillColor: isDark ? const Color(0xFF242735) : Colors.white,
                                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(child: _buildDropdown(label: "Urutkan", currentValue: _sortBy, options: ['Terbaru', 'Nama (A-Z)', 'Harga Terendah', 'Harga Tertinggi', 'Stok Paling Sedikit'], onChanged: (val) { setState(() => _sortBy = val!); _applyFilters(); }, isDark: isDark)),
                                    const SizedBox(width: 8),
                                    Expanded(child: _buildDropdown(label: "Status Stok", currentValue: _filterStok, options: ['Semua Stok', 'Tersedia', 'Stok Menipis', 'Habis'], onChanged: (val) { setState(() => _filterStok = val!); _applyFilters(); }, isDark: isDark)),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                SizedBox(width: double.infinity, child: _buildDropdown(label: "Kategori Produk", currentValue: _filterKategori, options: ['Semua Kategori', 'Makanan Ringan', 'Minuman', 'Obat Herbal', 'Bahan Pokok', 'Lainnya'], onChanged: (val) { setState(() => _filterKategori = val!); _applyFilters(); }, isDark: isDark)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(color: isDark ? const Color(0xFF242735) : Colors.white, borderRadius: BorderRadius.circular(12)),
                            child: Column(
                              children: [
                                if (isLoading) const Padding(padding: EdgeInsets.all(40.0), child: Center(child: CircularProgressIndicator()))
                                else if (errorMessage != null) Padding(padding: const EdgeInsets.all(40.0), child: Center(child: Text("Error: $errorMessage", style: const TextStyle(color: Colors.red))))
                                else if (allProducts.isEmpty) const Padding(padding: EdgeInsets.all(40.0), child: Center(child: Text("Belum ada data produk.")))
                                else if (displayedProducts.isEmpty) const Padding(padding: EdgeInsets.all(40.0), child: Center(child: Column(children: [Icon(Icons.search_off, size: 40, color: Colors.grey), SizedBox(height: 10), Text("Produk tidak ditemukan.", style: TextStyle(color: Colors.grey))])) )
                                else
                                  ListView.separated(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: displayedProducts.length, 
                                    separatorBuilder: (context, index) => Divider(height: 1, color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
                                    itemBuilder: (context, index) {
                                      final product = displayedProducts[index]; 
                                      bool isOutOfStock = product.stok <= 0;
                                      bool isLowStock = product.stok > 0 && product.stok < 5;
                                      Color iconColor = isOutOfStock ? Colors.red : (isLowStock ? Colors.orange : Colors.blue.shade700);
                                      Color bgColor = isOutOfStock ? Colors.red.shade50 : (isLowStock ? Colors.orange.shade50 : Colors.blue.shade50);
                                      
                                      return ListTile(
                                        leading: CircleAvatar(
                                          radius: 18,
                                          backgroundColor: isDark ? Colors.grey.shade800 : bgColor,
                                          child: Icon(isOutOfStock || isLowStock ? Icons.warning_amber_rounded : Icons.inventory_2, size: 18, color: iconColor),
                                        ),
                                        title: Text(product.nama, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                                        subtitle: Padding(
                                          padding: const EdgeInsets.only(top: 4.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("Stok: ${product.stok} | Rp ${product.harga}", style: TextStyle(fontSize: 12, color: isOutOfStock ? Colors.red.shade300 : (isLowStock ? Colors.orange.shade700 : null))),
                                              const SizedBox(height: 6),
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                decoration: BoxDecoration(color: _getCategoryColor(product.kategori).withValues(alpha: 0.15), borderRadius: BorderRadius.circular(4)),
                                                child: Text(product.kategori, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: _getCategoryColor(product.kategori))),
                                              ),
                                            ],
                                          ),
                                        ),
                                        isThreeLine: true,
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(icon: const Icon(Icons.edit, color: Colors.blue, size: 20), 
                                              onPressed: () async { 
                                                final result = await Navigator.push(context, MaterialPageRoute(builder: (_) => FormProductPage(product: product))); 
                                                if (result == true) {
                                                  _showSuccessSnackBar("Data produk telah diperbarui!");
                                                  loadData(); 
                                                }
                                              }),
                                            IconButton(icon: const Icon(Icons.delete, color: Colors.red, size: 20), onPressed: () => konfirmasiHapus(context, product)),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            bottomNavigationBar: Container(
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
                      decoration: BoxDecoration(color: isDark ? const Color(0xFF1A1D27).withValues(alpha: 0.9) : Colors.white.withValues(alpha: 0.9), borderRadius: const BorderRadius.vertical(top: Radius.circular(20))),
                      child: Row(
                        children: [
                          Expanded(child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade700, padding: const EdgeInsets.symmetric(vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))), 
                            onPressed: () async { 
                              final result = await Navigator.push(context, MaterialPageRoute(builder: (_) => const FormProductPage())); 
                              if (result == true) {
                                _showSuccessSnackBar("Produk baru berhasil ditambahkan!");
                                loadData(); 
                              }
                            }, 
                            child: const Text("Tambah Produk", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: isDark ? Colors.grey.shade800 : Colors.grey.shade300, padding: const EdgeInsets.symmetric(vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                              onPressed: () {
                                if (allProducts.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Data kosong!"), backgroundColor: Colors.orange));
                                } else {
                                  showModalBottomSheet(
                                    context: context,
                                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                                    builder: (context) {
                                      return Padding(
                                        padding: const EdgeInsets.all(24.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.inventory, size: 50, color: Colors.blue.shade700), const SizedBox(height: 16),
                                            const Text("Kelola Stok", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), const SizedBox(height: 10),
                                            const Text("Untuk memperbarui stok, silakan klik ikon pensil (edit) pada masing-masing produk.", textAlign: TextAlign.center), const SizedBox(height: 24),
                                            SizedBox(width: double.infinity, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade700), onPressed: () => Navigator.pop(context), child: const Text("Mengerti", style: TextStyle(color: Colors.white))))
                                          ],
                                        ),
                                      );
                                    }
                                  );
                                }
                              },
                              child: Text("Kelola Stok", style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontWeight: FontWeight.bold)),
                            ),
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
      ),
    );
  }

  Widget _buildDashboardCard(String title, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white.withValues(alpha: 0.5), size: 20),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 11)),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildBarChartItem(double height, double opacity, bool isDark) {
    return Container(
      width: 14,
      height: height,
      decoration: BoxDecoration(
        color: isDark ? Colors.blue.shade400.withValues(alpha: opacity) : Colors.blue.shade500.withValues(alpha: opacity),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(3)),
      ),
    );
  }

  Widget _buildDropdown({required String label, required String currentValue, required List<String> options, required void Function(String?) onChanged, required bool isDark}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(color: isDark ? const Color(0xFF1A1D27) : Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true, value: currentValue, icon: const Icon(Icons.arrow_drop_down, size: 20), isDense: true,
              style: TextStyle(fontSize: 12, color: isDark ? Colors.white : Colors.black87, fontWeight: FontWeight.w500),
              onChanged: onChanged,
              items: options.map<DropdownMenuItem<String>>((String value) => DropdownMenuItem<String>(value: value, child: Text(value, overflow: TextOverflow.ellipsis))).toList(),
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}