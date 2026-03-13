# Angela Caroline Budiman (2409116008) Sistem Informasi A'2024

# 📱 Aplikasi Stok Produk UMKM

Aplikasi manajemen stok barang (Inventory) berbasis Flutter yang dirancang khusus untuk pelaku UMKM. Aplikasi ini mengusung tema Modern Clean & Soft UI untuk memberikan pengalaman pengguna yang nyaman, intuitif, dan profesional dalam mengelola data produk secara real-time.

---

## 📌 Deskripsi Aplikasi
Aplikasi ini membantu pemilik usaha untuk mendigitalisasi pencatatan stok barang mereka. Terhubung langsung dengan Supabase sebagai backend (Database & Auth), memungkinkan pengguna untuk memantau jumlah stok, kategori produk, hingga harga barang di mana saja dan kapan saja. Desain aplikasi difokuskan pada keterbacaan data yang tinggi dengan estetika minimalis.

## Fitur Utama
* **Authentication:** Sistem Login dan Register yang aman menggunakan Supabase Auth.
* **Dashboard Analytics:** Ringkasan total produk, stok menipis, dan stok habis dalam bentuk kartu informasi yang informatif.
* **Inventory Management (CRUD):** Tambah, Lihat, Edit, dan Hapus data produk secara real-time.
* **Smart Search & Filter:** Memudahkan pencarian produk berdasarkan nama, kategori, maupun status ketersediaan stok.
* **Modern Soft UI:** Antarmuka bersih dengan bayangan lembut (soft shadow) dan sudut melengkung (rounded corners).
* **Dark & Light Mode:** Dukungan tema gelap dan terang yang menyesuaikan preferensi mata pengguna.
* **Real-time Notifications:** SnackBar informatif yang muncul hanya saat aksi (simpan/edit/hapus) berhasil dilakukan.

## Widget yang Digunakan
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

## Struktur File
<img width="298" height="917" alt="image" src="https://github.com/user-attachments/assets/e1d5c2cf-74f1-4241-a8f2-5040a5c96224" />

Berikut adalah struktur direktori yang digunakan dalam proyek ini:

* **📁 lib/** (Folder utama kode Dart)
  * **📄 main.dart**  
    Merupakan titik awal (entry point) dari aplikasi Flutter. File ini digunakan untuk menjalankan aplikasi serta mengatur konfigurasi dasar seperti tema dan routing.

  * **📁 config/**
    * **📄 supabase_config.dart**  
      Berisi konfigurasi untuk menghubungkan aplikasi dengan layanan backend Supabase.

  * **📁 models/**
    * **📄 product_model.dart**  
      Berisi model data yang digunakan untuk merepresentasikan struktur data produk dari database.

  * **📁 services/**
    * **📄 supabase_service.dart**  
      Berisi logika aplikasi untuk berkomunikasi dengan Supabase, seperti proses autentikasi dan operasi CRUD (Create, Read, Update, Delete) pada data produk.

  * **📁 pages/** (Antarmuka Pengguna)
    * **📄 auth_page.dart**  
      Halaman yang digunakan untuk proses login dan registrasi pengguna.

    * **📄 home_page.dart**  
      Halaman utama aplikasi yang menampilkan dashboard dan daftar inventaris produk.

    * **📄 form_product_page.dart**  
      Halaman formulir yang digunakan untuk menambahkan atau mengedit data produk.

* **📁 assets/**
  * **📄 header_illust.png**  
    Berisi aset gambar yang digunakan untuk mempercantik tampilan dashboard aplikasi.

* **File Pendukung**

  * **📄 .env**  
    Digunakan untuk menyimpan variabel lingkungan seperti URL dan API Key Supabase agar lebih aman.

  * **📄 pubspec.yaml**  
    File konfigurasi proyek Flutter yang berisi daftar dependensi library serta pengaturan aset yang digunakan dalam aplikasi.

  * **📄 README.md**  
    Berisi dokumentasi proyek seperti deskripsi aplikasi, struktur proyek, dan cara menjalankan aplikasi.: Dokumentasi lengkap mengenai proyek ini.

## 📸 Tampilan Desain
Desain aplikasi ini menggunakan pendekatan Soft UI/Modern Clean yang mengutamakan whitespace dan kontras tipografi yang jelas.

## Tampilan Aplikasi (Light Mode/Dark Mode)

<img width="1919" height="968" alt="image" src="https://github.com/user-attachments/assets/08314517-10f4-4e9f-882f-476494a6b89f" />

Gambar ini menampilkan halaman login aplikasi pada mode terang (Light Mode).  
Pada halaman ini pengguna diminta untuk memasukkan email dan password untuk masuk ke dalam aplikasi. Tampilan menggunakan latar belakang terang agar lebih nyaman digunakan pada kondisi pencahayaan normal.

<img width="1919" height="965" alt="image" src="https://github.com/user-attachments/assets/fb3464aa-2bda-461e-ba4c-2b10119beef3" />

Gambar ini menampilkan halaman login aplikasi pada mode gelap (Dark Mode).  
Mode ini menggunakan latar belakang gelap yang bertujuan untuk mengurangi kelelahan mata saat aplikasi digunakan dalam kondisi pencahayaan rendah.

<img width="1919" height="967" alt="image" src="https://github.com/user-attachments/assets/a09959b2-e32a-406e-bf57-7d6a4ac9110e" />

Gambar ini menampilkan halaman Dashboard pada mode terang (Light Mode).  
Pada halaman ini pengguna dapat melihat ringkasan informasi inventaris, seperti jumlah produk yang tersedia serta statistik data yang ditampilkan dalam bentuk kartu informasi.

<img width="1919" height="965" alt="image" src="https://github.com/user-attachments/assets/11034401-c53f-49b5-a2b3-3c361da4e6e4" />

Gambar ini menampilkan halaman Dashboard pada mode gelap (Dark Mode).  
Tampilan ini memiliki fungsi yang sama dengan Dashboard pada Light Mode, namun menggunakan tema gelap untuk memberikan kenyamanan visual bagi pengguna yang menggunakan aplikasi pada kondisi pencahayaan rendah.

### Navigation Drawer
<img width="371" height="967" alt="image" src="https://github.com/user-attachments/assets/c5a2be05-8003-418c-9716-381cbbf96a78" />

Menu Navigation Drawer digunakan untuk memudahkan pengguna dalam berpindah antar halaman di dalam aplikasi.  
Menu ini biasanya berisi beberapa navigasi utama seperti Dashboard, Daftar Produk, Profil, serta pengaturan lainnya.

### Profile
<img width="330" height="316" alt="image" src="https://github.com/user-attachments/assets/a9b2a3d3-05a4-43b7-ad95-e14402dcd704" />

Halaman Profile menampilkan informasi akun pengguna yang sedang login.  
Pada halaman ini pengguna dapat melihat data akun yang terdaftar di sistem.

### Dashboard
<img width="1919" height="963" alt="image" src="https://github.com/user-attachments/assets/1f21d7b4-81d4-45e5-beef-1cca375e6b15" />

Halaman Dashboard merupakan halaman utama setelah pengguna berhasil login.  
Halaman ini menampilkan ringkasan informasi seperti statistik produk dan gambaran umum inventaris yang tersedia pada aplikasi.

### Daftar Produk
<img width="1919" height="963" alt="image" src="https://github.com/user-attachments/assets/6e5d7697-d50d-46d1-b13d-273acda79ab7" />

Halaman Daftar Produk menampilkan seluruh data produk yang tersimpan dalam database.  
Pengguna dapat melihat informasi produk seperti nama produk, jumlah stok, dan melakukan pengelolaan data produk.


## Validasi dan Notifikasi
Bagian ini menampilkan berbagai validasi input dan notifikasi sistem yang bertujuan untuk memastikan data yang dimasukkan oleh pengguna sesuai dengan aturan yang telah ditentukan.

### Email dan Password wajib diisi
<img width="551" height="230" alt="image" src="https://github.com/user-attachments/assets/1897e339-c23c-4a5c-938a-cbaa8c631944" />

Sistem akan menampilkan pesan peringatan jika pengguna mencoba login atau register tanpa mengisi email dan password.

### Password Minimal 6 Karakter
<img width="532" height="114" alt="image" src="https://github.com/user-attachments/assets/62979cdb-0b1c-41c3-88b6-4425c5161048" />

Validasi ini memastikan bahwa password yang dimasukkan memiliki minimal 6 karakter untuk meningkatkan keamanan akun pengguna.

### Format Gmail wajib sesuai
<img width="525" height="108" alt="image" src="https://github.com/user-attachments/assets/cb85a50c-b4a3-4f30-bcea-a87cc9fafa5d" />
<img width="523" height="111" alt="image" src="https://github.com/user-attachments/assets/66f44d35-18e0-48c6-b2c3-eeeabf8d1d5f" />

Sistem akan memeriksa apakah format email yang dimasukkan sudah benar sesuai dengan format email yang valid.


### Email Tidak Dapat Sama/Duplikat
<img width="554" height="413" alt="image" src="https://github.com/user-attachments/assets/43ee986d-0701-49c3-a2fd-431ecc6422c0" />

Jika pengguna mencoba melakukan registrasi dengan email yang sudah terdaftar sebelumnya, sistem akan menampilkan notifikasi bahwa email tersebut tidak dapat digunakan kembali.

### Email dan Password Wajib Benar
<img width="542" height="273" alt="image" src="https://github.com/user-attachments/assets/6c54f53e-6e15-4711-9f0c-86769b97b0ed" />

Jika pengguna memasukkan email atau password yang salah saat login, sistem akan menampilkan notifikasi bahwa data login tidak valid.

### Tambah Produk (Semua Wajib Terisi)
<img width="1919" height="958" alt="image" src="https://github.com/user-attachments/assets/e7f98ec8-173f-4d9a-8499-a926fb21dd39" />

Saat menambahkan produk baru, seluruh field pada formulir harus diisi. Jika ada field yang kosong, sistem akan menampilkan pesan validasi.

### Wajib Berupa Angka dan Tidak Dapat diawali dengan tanda (-)
<img width="604" height="281" alt="image" src="https://github.com/user-attachments/assets/b4ef2a73-5500-4a06-9180-d6b991f6e1e8" />

Pada input stok produk, sistem hanya menerima angka positif serta tidak dapat berupa huruf dan tidak memperbolehkan nilai negatif untuk menjaga keakuratan data inventaris.

### Notifikasi Tidak Ada Perubahan Stok
<img width="408" height="76" alt="image" src="https://github.com/user-attachments/assets/609fb565-cfbd-47f8-9965-fc43dfd1af80" />

Jika pengguna mencoba memperbarui stok tanpa melakukan perubahan pada nilai stok, sistem akan menampilkan notifikasi bahwa tidak ada perubahan data.

### Notifikasi Stok Berhasil Diperbarui
<img width="281" height="61" alt="image" src="https://github.com/user-attachments/assets/e05e736d-9a0e-4778-a8c1-e8b9762e8b35" />

Notifikasi ini muncul ketika pengguna berhasil memperbarui jumlah stok produk di dalam sistem.

### Notifikasi Produk Berhasil ditambah
<img width="324" height="53" alt="image" src="https://github.com/user-attachments/assets/d574d7f8-4e7a-4f65-b854-9dd50ac35a75" />

Notifikasi ini menandakan bahwa data produk baru berhasil ditambahkan ke dalam database.

### Notifikasi Produk Sudah Ada
<img width="431" height="54" alt="image" src="https://github.com/user-attachments/assets/7085563f-14e6-4a21-a4b2-6ff7693bc3b5" />

Jika pengguna mencoba menambahkan produk dengan nama yang sudah ada di database, sistem akan menampilkan notifikasi bahwa produk tersebut sudah terdaftar.

## Tools yang digunakan

* **Frontend:** Flutter (Dart)
* **Backend:** Supabase (Database & Auth)
* **State Management:** StatefulWidget & setState
* **Local Env:** flutter_dotenv

---
2026 Angela Caroline Budiman - Sistem Informasi A'2024








