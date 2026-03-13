# Angela Caroline Budiman (2409116008) Sistem Informasi A'2024

# 📱 Aplikasi Stok Produk UMKM

Aplikasi manajemen stok barang (Inventory) berbasis Flutter yang dirancang khusus untuk pelaku UMKM. Aplikasi ini mengusung tema **Modern Clean & Soft UI** untuk memberikan pengalaman pengguna yang nyaman, intuitif, dan profesional dalam mengelola data produk secara real-time.

---

## 📝 Deskripsi Aplikasi
Aplikasi ini membantu pemilik usaha untuk mendigitalisasi pencatatan stok barang mereka. Terhubung langsung dengan **Supabase** sebagai backend (Database & Auth), memungkinkan pengguna untuk memantau jumlah stok, kategori produk, hingga harga barang di mana saja dan kapan saja. Desain aplikasi difokuskan pada keterbacaan data yang tinggi dengan estetika minimalis.

## 🚀 Fitur Utama
* **Authentication:** Sistem Login dan Register yang aman menggunakan Supabase Auth.
* **Dashboard Analytics:** Ringkasan total produk, stok menipis, dan stok habis dalam bentuk kartu informasi yang informatif.
* **Inventory Management (CRUD):** Tambah, Lihat, Edit, dan Hapus data produk secara real-time.
* **Smart Search & Filter:** Memudahkan pencarian produk berdasarkan nama, kategori, maupun status ketersediaan stok.
* **Modern Soft UI:** Antarmuka bersih dengan bayangan lembut (soft shadow) dan sudut melengkung (rounded corners).
* **Dark & Light Mode:** Dukungan tema gelap dan terang yang menyesuaikan preferensi mata pengguna.
* **Real-time Notifications:** SnackBar informatif yang muncul hanya saat aksi (simpan/edit/hapus) berhasil dilakukan.

## 🛠️ Widget yang Digunakan
Aplikasi ini dibangun menggunakan berbagai widget Flutter untuk mencapai tampilan yang modern:

### 1. Layout & Structure
* `Scaffold`: Struktur dasar halaman aplikasi.
* `AppBar`: Bagian atas untuk judul dan aksi tema.
* `Drawer`: Navigasi samping yang minimalis.
* `DefaultTabController & TabBar`: Untuk memisahkan tampilan Dashboard dan Daftar Produk.

### 2. Form & Inputs
* `TextFormField`: Input data nama, harga, dan stok dengan validasi.
* `DropdownButtonFormField`: Pemilihan kategori produk yang rapi.
* `TextEditingController`: Mengontrol dan mengambil data dari input teks.

### 3. Data Display
* `ListView.separated`: Menampilkan daftar produk dengan pembatas yang bersih.
* `Card / Container`: Digunakan sebagai pembungkus item dengan efek *Soft Shadow*.
* `CircleAvatar`: Menampilkan ikon kategori atau profil pengguna.
* `IntrinsicHeight`: Menyeimbangkan tinggi elemen pada dashboard.

### 4. Interactive Elements
* `ElevatedButton`: Tombol utama dengan desain modern.
* `IconButton`: Untuk aksi cepat seperti edit dan hapus.
* `RefreshIndicator`: Fitur *pull-to-refresh* untuk memperbarui data manual.
* `SnackBar`: Memberikan feedback visual setelah melakukan aksi.

---

## 📸 Tampilan Desain
Desain aplikasi ini menggunakan pendekatan **Soft UI/Modern Clean** yang mengutamakan *whitespace* dan kontras tipografi yang jelas.

> **Status Proyek:** ✅ Selesai (Final Version)
