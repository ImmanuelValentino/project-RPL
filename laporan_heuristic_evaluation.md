# LAPORAN HEURISTIC EVALUATION

**Nama Aplikasi:** WengTrade (crypto_screener)  
**Disusun oleh:** Antigravity AI Coding Assistant  
**Tanggal:** 15 Juni 2026  

---

## DAFTAR ISI
1. [EXECUTIVE SUMMARY](#executive-summary)
2. [PENDAHULUAN](#pendahuluan)
3. [METODE PELAKSANAAN](#metode-pelaksanaan)
   - [Usability Heuristics](#usability-heuristics)
   - [Severity Rating](#severity-rating)
4. [LANGKAH EVALUASI](#langkah-evaluasi)
5. [TEMUAN](#temuan)
   - [Temuan Positif](#temuan-positif)
   - [Temuan Negatif](#temuan-negatif)
6. [RANGKUMAN REKOMENDASI](#rangkuman-rekomendasi)

---

## EXECUTIVE SUMMARY

Laporan ini menyajikan hasil **Heuristic Evaluation** untuk aplikasi **WengTrade** (crypto_screener), sebuah platform pemantauan pasar global (Screener) dan pusat edukasi trading. Evaluasi dilakukan berdasarkan 10 Usability Heuristics dari Jakob Nielsen untuk mengidentifikasi kekuatan desain antarmuka serta menemukan hambatan kegunaan (usability issues) yang dihadapi oleh pengguna.

Proses evaluasi berhasil mengidentifikasi beberapa kekuatan utama aplikasi, seperti konsistensi tema visual yang rapi, pemanfaatan visualisasi data real-time, dan status sistem yang informatif saat memproses data. Namun, terdapat beberapa temuan negatif yang memerlukan perhatian segera, khususnya terkait minimnya konfirmasi pada tindakan krusial (seperti logout), alur navigasi antar-tab yang tidak otomatis, serta tidak adanya validasi input pada kalkulator risiko yang dapat memicu kesalahan komputasi bagi pengguna.

Rekomendasi taktis telah disusun di akhir laporan ini untuk memandu tim pengembang dalam meningkatkan pengalaman pengguna (UX) secara iteratif, mulai dari perbaikan kosmetik hingga pencegahan error tingkat kritis.

---

## PENDAHULUAN

**WengTrade** adalah aplikasi berbasis Flutter yang dirancang sebagai asisten pemantau pasar finansial dan media edukasi trading bagi investor pemula maupun berpengalaman. Aplikasi ini memfasilitasi pengguna untuk menyaring instrumen keuangan dari tiga pasar utama: **Cryptocurrency** (Binance), **S&P 500** (Saham AS via Finnhub), dan **IDX** (Bursa Efek Indonesia via custom API).

### Fitur Utama Aplikasi:
1. **Global Screener**: Daftar harga instrumen keuangan real-time lengkap dengan persentase perubahan 24 jam.
2. **Interactive Chart**: Integrasi TradingView candlestick chart interaktif melalui Webview internal.
3. **Pusat Literasi (Edukasi)**: Modul panduan belajar trading dinamis yang terbagi menjadi konten gratis (Basic) dan konten premium (Pro) menggunakan skema pembayaran terintegrasi Xendit.
4. **Kalkulator Risiko**: Alat penghitung ukuran posisi (position sizing) berdasarkan modal, persentase risiko, harga beli, dan titik stop loss.
5. **Manajemen Akun & Lokasi**: Integrasi deteksi lokasi GPS saat login untuk merekam profil kota pengguna secara real-time.

---

## METODE PELAKSANAAN

### Usability Heuristics
Evaluasi ini mengacu pada **10 Usability Heuristics** oleh Jakob Nielsen:

1. **Visibility of System Status**  
   Sistem harus selalu memberi informasi kepada pengguna tentang apa yang terjadi, melalui feedback yang sesuai dalam waktu yang wajar.
2. **Match Between System and The Real World**  
   Sistem harus berbicara dengan bahasa pengguna, menggunakan kata-kata, frasa, dan konsep yang akrab bagi pengguna, bukan istilah yang berorientasi sistem.
3. **User Control and Freedom**  
   Pengguna sering memilih fungsi secara tidak sengaja dan membutuhkan “emergency exit” yang jelas untuk meninggalkan kondisi yang tidak dikehendaki tanpa melalui proses panjang (misalnya tombol back, undo, cancel).
4. **Consistency and Standard**  
   Sistem memiliki standar dalam menyajikan elemen, kode, kata/istilah yang konsisten di tiap halaman sehingga pengguna tidak bingung.
5. **Error Prevention**  
   Desain yang mencegah pengguna melakukan kesalahan jauh lebih baik daripada sekadar menampilkan pesan error yang baik.
6. **Recognition Rather Than Recall**  
   Perkecil beban memori pengguna dengan membuat objek, tindakan, dan opsi terlihat jelas. Pengguna tidak perlu mengingat informasi dari satu bagian ke bagian lainnya.
7. **Flexibility and Efficiency of Use**  
   Sistem memberi keleluasan aksi untuk mengakomodasi pengguna pemula hingga pengguna mahir (shortcut/akselerator).
8. **Aesthetic and Minimalist Design**  
   Desain antarmuka harus bersih, tidak mengandung informasi yang tidak relevan atau jarang dibutuhkan yang dapat mengganggu visibilitas info penting.
9. **Help Users Recognize, Diagnose, and Recover from Errors**  
   Pesan error harus dinyatakan dalam bahasa sederhana (bukan kode teknis), menunjukkan masalah secara tepat, dan menyarankan solusi konstruktif.
10. **Help and Documentation**  
    Sistem menyediakan dokumentasi dan fitur bantuan yang mudah dicari, berfokus pada tugas pengguna, dan menyajikan langkah konkrit.

---

### SEVERITY RATING

Skala keparahan masalah dinilai menggunakan angka **0 sampai 4**:

| Rating | Deskripsi | Penjelasan |
| :---: | :--- | :--- |
| **0** | **Bukan Masalah Usability** | Masalah ditemukan tetapi tidak mengganggu aspek usability. |
| **1** | **Cosmetic Problem** | Cukup mengganggu visual/estetika, tetapi tidak menghambat penyelesaian tugas. Perbaikan prioritas rendah. |
| **2** | **Minor Usability Problem** | Masalah yang menyebabkan kesulitan kecil bagi pengguna saat menyelesaikan tugas. Prioritas perbaikan sedang. |
| **3** | **Major Usability Problem** | Masalah besar yang sangat penting untuk diperbaiki karena menghambat alur kerja penting. Prioritas perbaikan tinggi. |
| **4** | **Usability Catastrophe** | Masalah kritis yang wajib diperbaiki sebelum aplikasi dirilis karena membuat fitur tidak dapat digunakan. |

---

## LANGKAH EVALUASI

1. **Eksplorasi Kode & Fungsionalitas**: Evaluator menganalisis kode sumber di direktori `lib/` untuk memahami alur logika di balik UI.
2. **Identifikasi Masalah**: Setiap layar (Screens) dan layanan (Services) diperiksa kepatuhannya terhadap 10 Usability Heuristics.
3. **Pemberian Severity Rating**: Menilai tingkat dampak dari setiap masalah kegunaan yang diidentifikasi.
4. **Penyusunan Rekomendasi**: Merumuskan solusi perbaikan yang realistis untuk diterapkan pada struktur Flutter saat ini.

---

## TEMUAN

### TEMUAN POSITIF

Berikut adalah aspek-aspek kegunaan yang telah diimplementasikan dengan sangat baik pada aplikasi WengTrade:

| No | Prinsip Heuristik | Deskripsi Temuan Positif | Kode File |
| :---: | :--- | :--- | :--- |
| 1 | **Visibility of System Status** | Penggunaan `CircularProgressIndicator` yang konsisten saat memuat data pasar awal di `HomeScreen`, modul edukasi di `EducationScreen`, dan pemrosesan tautan pembayaran di `MaterialDetailScreen`. Pengguna mendapat konfirmasi instan berupa SnackBar saat registrasi sukses dan saat status Pro aktif setelah polling database selesai. | [home_screen.dart](file:///c:/Kuliah/Coding/RPL/crypto_screener/lib/screens/home_screen.dart)<br>[material_detail_screen.dart](file:///c:/Kuliah/Coding/RPL/crypto_screener/lib/screens/material_detail_screen.dart) |
| 2 | **Match Between System & Real World** | Bahasa yang digunakan sangat akrab dengan dunia investasi dan trading. Penggunaan istilah seperti "Harga Beli", "Stop Loss", "Total Modal", "Kalkulator Risiko", dan "Screener" mempermudah pemahaman pengguna lokal Indonesia. | [risk_calculator_screen.dart](file:///c:/Kuliah/Coding/RPL/crypto_screener/lib/screens/risk_calculator_screen.dart) |
| 3 | **Consistency and Standard** | Gaya visual AppBar yang seragam di seluruh aplikasi berkat pendefinisian `appBarTheme` secara terpusat pada file `main.dart`. | [main.dart](file:///c:/Kuliah/Coding/RPL/crypto_screener/lib/main.dart) |
| 4 | **Recognition Rather Than Recall** | Pada daftar instrumen pasar, aplikasi menampilkan inisial huruf pertama aset dalam ikon lingkaran berwarna kontras serta label badges yang merepresentasikan jenis pasar (Crypto = Oranye, S&P 500 = Biru, IDX = Merah). Hal ini mempercepat identifikasi kategori aset tanpa memaksa pengguna mengingat asal instrumen. | [home_screen.dart](file:///c:/Kuliah/Coding/RPL/crypto_screener/lib/screens/home_screen.dart) |
| 5 | **Aesthetic and Minimalist Design** | Desain antarmuka bersih dan terfokus menggunakan warna dasar indigo. Tidak ada elemen visual berlebihan, dan informasi harga disajikan secara minimalis terstruktur. | Seluruh direktori [screens/](file:///c:/Kuliah/Coding/RPL/crypto_screener/lib/screens) |
| 6 | **Help and Documentation** | Adanya tab "Pusat Literasi" (`EducationScreen`) yang menyediakan panduan langkah demi langkah pembelajaran trading menggunakan format Markdown yang rapi dan mudah dibaca. | [education_screen.dart](file:///c:/Kuliah/Coding/RPL/crypto_screener/lib/screens/education_screen.dart) |

---

### TEMUAN NEGATIF

#### 1. Visibility of System Status
* **Tugas**: Pengambilan data lokasi GPS di latar belakang saat login.
* **Pengamatan**: Pada `AuthScreen`, ketika aplikasi memanggil `LocationService.getLocationData()`, jika pengguna menolak memberikan izin lokasi atau GPS tidak aktif, aplikasi hanya mencatat pesan kegagalan di konsol (`debugPrint`). Pengguna tidak menerima notifikasi atau indikator bahwa lokasi gagal dideteksi, melainkan langsung masuk ke halaman utama tanpa tahu mengapa data kota mereka tidak tampil di AppBar.
* **Rekomendasi**: Tampilkan SnackBar atau dialog informatif bernada ramah jika lokasi gagal diambil (misalnya: *"Izin lokasi ditolak, Anda dapat mengaktifkannya di pengaturan untuk menampilkan data cuaca/pasar lokal"*).
* **Kode**: **H01T01 / auth_screen.dart / Severity Rating: 2**

---

#### 2. Match Between System and the Real World
* **Tugas**: Identifikasi mata uang di kalkulator risiko.
* **Pengamatan**: Di `RiskCalculatorScreen`, seluruh isian nominal dan hasil perhitungan dilabeli dengan mata uang Dollar (`$`). Namun, aplikasi juga melacak saham Indonesia (IDX) yang dihargai dalam Rupiah (`Rp`). Hal ini membingungkan bagi pengguna lokal saat ingin menghitung risiko saham Indonesia (misal: memasukkan modal Rupiah tapi melihat label Dollar).
* **Rekomendasi**: Sediakan toggle pilihan mata uang (USD / IDR) di kalkulator risiko, atau sesuaikan mata uang kalkulator secara dinamis berdasarkan instrumen yang dipilih.
* **Kode**: **H02T01 / risk_calculator_screen.dart / Severity Rating: 2**

---

#### 3. User Control and Freedom
* **Tugas**: Mengakses kalkulator risiko dari halaman detail aset.
* **Pengamatan**: Pada halaman `DetailScreen`, terdapat tombol *"Hitung Risiko Trading"*. Saat diklik, tombol ini hanya melakukan `Navigator.pop(context)` (menutup layar detail kembali ke Home) dan memicu SnackBar bertuliskan *"Silakan buka tab Tools untuk berhitung."*. Tindakan ini memaksa pengguna melakukan navigasi manual tambahan ke tab kalkulator, alih-alih secara otomatis memindahkan tab aktif pengguna ke halaman kalkulator risiko.
* **Rekomendasi**: Ubah logika navigasi agar tombol langsung memicu perpindahan tab aktif di `MainLayout` menuju `RiskCalculatorScreen` (Index 2).
* **Kode**: **H03T01 / detail_screen.dart / Severity Rating: 3**

---

#### 4. Consistency and Standard
* **Tugas**: Konsistensi penamaan judul halaman (Header).
* **Pengamatan**: Terdapat ketidakkonsistenan antara label di `BottomNavigationBar` dengan judul di AppBar halaman masing-masing. Di bar navigasi tertulis **Edukasi**, namun judul AppBar-nya adalah **Pusat Literasi**. Di bar navigasi tertulis **Screener**, namun judul AppBar-nya adalah **Global Market**. Hal ini dapat membingungkan pengguna pemula tentang lokasi halaman mereka saat ini.
* **Rekomendasi**: Selaraskan penamaan judul halaman di AppBar agar sama dengan label menu navigasi bawah (misalnya mengubah judul AppBar menjadi *"Edukasi Trading"* dan *"Market Screener"*).
* **Kode**: **H04T01 / main_layout.dart, education_screen.dart, home_screen.dart / Severity Rating: 1**

---

#### 5. Error Prevention
* **Tugas**: Input data pada Kalkulator Risiko.
* **Pengamatan**: Pada `RiskCalculatorScreen`, tidak ada validasi input. Pengguna dapat mengosongkan kolom input, memasukkan angka 0, atau memasukkan nilai Stop Loss yang lebih tinggi dari Harga Beli (untuk posisi Buy). Akibatnya, kalkulator akan menghasilkan nilai negatif (`_positionSizeCoins` atau `_totalInvestment` bernilai negatif atau 0) tanpa memberikan tanda peringatan kesalahan input.
* **Rekomendasi**: Tampilkan pesan error validasi di bawah TextField jika nilai input tidak logis (misalnya: *"Harga Stop Loss harus lebih rendah dari Harga Beli"* atau *"Kolom tidak boleh kosong/nol"*). Nonaktifkan perhitungan jika validasi gagal.
* **Kode**: **H05T01 / risk_calculator_screen.dart / Severity Rating: 3**

* **Tugas**: Proses Logout Akun.
* **Pengamatan**: Di halaman `ProfileScreen`, tombol *"Keluar (Logout)"* akan langsung mengeluarkan pengguna dari sesi tanpa adanya konfirmasi apa pun. Pengguna yang tidak sengaja menekan tombol ini akan terpaksa memasukkan kredensial login mereka kembali dari awal.
* **Rekomendasi**: Tambahkan dialog konfirmasi (AlertDialog) sebelum proses sign-out dieksekusi (*"Apakah Anda yakin ingin keluar?"*).
* **Kode**: **H05T02 / profile_screen.dart / Severity Rating: 2**

---

#### 6. Recognition Rather Than Recall
* **Tugas**: Mentransfer data harga aset dari Detail ke Kalkulator.
* **Pengamatan**: Pengguna yang ingin menghitung risiko suatu aset di `DetailScreen` harus mengingat atau menyalin harga berjalan aset tersebut secara manual, kemudian berpindah halaman dan menuliskannya kembali pada kolom *"Harga Beli"* di `RiskCalculatorScreen`. Ini membebani memori jangka pendek pengguna (recall).
* **Rekomendasi**: Kirim data harga berjalan dan simbol aset secara otomatis sebagai argumen/parameter ke kalkulator ketika pengguna menekan tombol *"Hitung Risiko"* dari halaman detail.
* **Kode**: **H06T01 / detail_screen.dart / Severity Rating: 2**

---

#### 7. Flexibility and Efficiency of Use
* **Tugas**: Pencarian dan Penyaringan Aset Pasar.
* **Pengamatan**: Pada `HomeScreen`, filter kategori pasar diletakkan di dalam dropdown menu. Pengguna harus mengklik dropdown terlebih dahulu sebelum dapat memilih kategori pasar (Crypto, S&P 500, IDX). Hal ini kurang efisien bagi pengguna yang sering berpindah kategori pasar secara cepat.
* **Rekomendasi**: Ganti dropdown menu dengan deretan tombol pilihan cepat (pill/chip filter) seperti *"Semua"*, *"Crypto"*, *"Saham US"*, dan *"Saham Indo"* yang dapat diklik langsung dengan satu sentuhan.
* **Kode**: **H07T01 / home_screen.dart / Severity Rating: 2**

---

#### 8. Aesthetic and Minimalist Design
* **Tugas**: Pemuatan halaman grafik TradingView.
* **Pengamatan**: Saat membuka `DetailScreen`, InAppWebView memerlukan waktu beberapa detik untuk mengunduh pustaka JavaScript TradingView. Selama pemuatan tersebut, area bagan menampilkan area putih kosong yang kontras dan merusak keindahan desain gelap (indigo) yang diusung aplikasi.
* **Rekomendasi**: Tambahkan indikator loading beranimasi (shimmer effect atau spinner kecil) di atas area WebView selama status pemuatan halaman belum selesai (`onLoadStop`).
* **Kode**: **H08T01 / detail_screen.dart / Severity Rating: 1**

---

#### 9. Help Users Recognize, Diagnose and Recover from Errors
* **Tugas**: Pemuatan status transaksi Premium.
* **Pengamatan**: Pada `MaterialDetailScreen`, jika terjadi kegagalan sistem saat checkout transaksi Xendit, aplikasi menangkap error tersebut dan menampilkannya langsung ke SnackBar berupa pesan mentah (`Error: $e`). Pesan teknis ini tidak dapat dipahami oleh pengguna umum dan tidak memberikan solusi langkah pemulihan.
* **Rekomendasi**: Terjemahkan pesan error teknis menjadi instruksi yang konstruktif bagi pengguna (misal: *"Gagal menghubungi server pembayaran. Silakan periksa koneksi internet Anda atau coba beberapa saat lagi."*).
* **Kode**: **H09T01 / material_detail_screen.dart / Severity Rating: 2**

---

#### 10. Help and Documentation
* **Tugas**: Mencari materi pembelajaran di Pusat Literasi.
* **Pengamatan**: Di halaman `EducationScreen` (Pusat Literasi), modul-modul belajar ditampilkan secara linear ke bawah tanpa adanya bilah pencarian (search bar). Ketika jumlah modul di database Supabase bertambah banyak, pengguna akan kesulitan mencari topik panduan tertentu.
* **Rekomendasi**: Tambahkan bilah pencarian sederhana di bagian atas `EducationScreen` untuk memfilter materi berdasarkan kata kunci judul modul.
* **Kode**: **H10T01 / education_screen.dart / Severity Rating: 2**

---

## RANGKUMAN REKOMENDASI

Berdasarkan temuan-temuan di atas, berikut adalah rangkuman prioritas tindakan rekomendasi yang disarankan untuk segera ditindaklanjuti oleh tim pengembang:

| No | Kode Temuan | Deskripsi Rekomendasi Perbaikan | Severity | Tingkat Prioritas |
| :---: | :--- | :--- | :---: | :---: |
| 1 | **H05T01** | Tambahkan validasi logis pada kolom input kalkulator risiko (misal: Harga Beli > Stop Loss) dan tampilkan teks error di TextField untuk **mencegah kalkulasi bernilai negatif**. | **3** | **Tinggi** |
| 2 | **H03T01** | Perbaiki fungsi tombol "Hitung Risiko" di `DetailScreen` agar **otomatis memindahkan navigasi tab** utama ke index tab kalkulator risiko. | **3** | **Tinggi** |
| 3 | **H06T01** | Terapkan **pengiriman parameter harga berjalan** dari halaman detail langsung ke kolom input kalkulator secara otomatis (auto-fill). | **2** | **Sedang** |
| 4 | **H05T02** | Tambahkan dialog konfirmasi **AlertDialog** sebelum pengguna keluar (logout) dari aplikasi di halaman profil. | **2** | **Sedang** |
| 5 | **H02T01** | Tambahkan fitur **pilihan mata uang (USD/IDR)** di kalkulator risiko agar sesuai dengan jenis instrumen yang dihitung. | **2** | **Sedang** |
| 6 | **H07T01** | Ganti dropdown filter pasar di halaman utama dengan **filter chips/pills** untuk mempercepat pemfilteran aset. | **2** | **Sedang** |
| 7 | **H01T01** | Berikan pesan pemberitahuan informatif jika sistem **gagal melacak lokasi/GPS** pengguna agar mereka paham mengapa data kota kosong. | **2** | **Sedang** |
| 8 | **H09T01** | Lakukan penyamaran (masking) terhadap pesan error teknis transaksi Xendit menjadi **pesan error yang mudah dipahami & konstruktif**. | **2** | **Sedang** |
| 9 | **H10T01** | Tambahkan **fitur pencarian modul** di tab Edukasi guna mengantisipasi penambahan materi di masa depan. | **2** | **Sedang** |
| 10 | **H04T01** | Selaraskan penamaan judul halaman di AppBar dengan label tab BottomNavigationBar agar **konsisten**. | **1** | **Rendah** |
| 11 | **H08T01** | Tambahkan **shimmer loader** di area bagan TradingView saat WebView sedang mengunduh aset visual agar tidak memunculkan layar putih kosong. | **1** | **Rendah** |
