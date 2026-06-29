# TEMPLATE PENGUJIAN BLACK BOX (MANUAL TESTING)
**Nama Aplikasi:** WengTrade (crypto_screener)  
**Dokumen Pengujian:** Template Skenario Pengujian Fungsional (Manual)  
**Diuji Oleh:** [Nama Penguji]  
**Tanggal Pengujian:** [Tanggal]  

---

## 1. PENDAHULUAN
Dokumen ini berisi template pengujian *Black Box* untuk aplikasi **WengTrade**. Pengujian dirancang untuk memverifikasi fungsionalitas sistem dari sudut pandang pengguna akhir tanpa melihat struktur kode internal secara langsung. 

Teknik pengujian yang digunakan meliputi:
1. **Equivalence Partitioning (EP):** Membagi domain input ke dalam kelas data valid dan tidak valid.
2. **Boundary Value Analysis (BVA):** Menguji nilai batas pada rentang input (nilai ekstrem minimum dan maksimum).
3. **Decision Table (Tabel Keputusan):** Menguji logika kombinasi input boolean untuk menghasilkan output tertentu.

---

## 2. FORMAT PENGISIAN HASIL UJI
Untuk setiap skenario pengujian di bawah, penguji manual diharapkan mengisi kolom berikut:
* **Hasil Aktual:** Kondisi riil yang terjadi pada layar aplikasi saat langkah dijalankan.
* **Status:** Diisi **PASS** jika *Hasil Aktual* sesuai dengan *Hasil yang Diharapkan*, atau **FAIL** jika tidak sesuai.
* **Catatan:** Catatan tambahan atau tangkapan layar (jika terjadi error).

---

## 3. UNIT PENGUJIAN & SKENARIO

### FITUR 1: AUTENTIKASI PENGGUNA (LOGIN & REGISTER)
* **File Terkait:** [auth_screen.dart](file:///c:/Kuliah/Coding/RPL/crypto_screener/lib/screens/auth_screen.dart) & [auth_service.dart](file:///c:/Kuliah/Coding/RPL/crypto_screener/lib/services/auth_service.dart)

| ID Uji | Skenario Pengujian | Langkah Pengujian | Data Uji | Hasil yang Diharapkan | Hasil Aktual | Status (PASS/FAIL) |
| :---: | :--- | :--- | :--- | :--- | :--- | :---: |
| **AUT-01** | Registrasi akun baru dengan format valid | 1. Buka aplikasi.<br>2. Klik link "Daftar".<br>3. Masukkan email & password.<br>4. Klik tombol "Daftar". | Email: `user.baru@gmail.com`<br>Password: `password123` | Registrasi berhasil, muncul SnackBar "Registrasi Berhasil! Silakan Login", dan form beralih otomatis ke mode Login. | | |
| **AUT-02** | Login menggunakan akun terdaftar | 1. Pastikan di mode Login.<br>2. Masukkan email & password valid.<br>3. Klik tombol "Masuk". | Email: `user.baru@gmail.com`<br>Password: `password123` | Login berhasil, pengguna dialihkan ke halaman utama (Global Market). | | |
| **AUT-03** | Login dengan password salah | 1. Masukkan email valid.<br>2. Masukkan password salah.<br>3. Klik tombol "Masuk". | Email: `user.baru@gmail.com`<br>Password: `salahpass` | Muncul SnackBar bertuliskan pesan error kegagalan autentikasi dari sistem/Supabase. | | |
| **AUT-04** | Deteksi Lokasi saat Autentikasi (GPS Aktif) | 1. Aktifkan GPS perangkat.<br>2. Izinkan akses lokasi bagi aplikasi.<br>3. Jalankan login/register. | Akses GPS: **DISETUJUI** | Aplikasi berhasil menarik data kota tempat login dan menampilkannya di bagian AppBar halaman utama. | | |
| **AUT-05** | Fallback Deteksi Lokasi (GPS Nonaktif/Izin Ditolak) | 1. Matikan GPS perangkat atau tolak izin lokasi.<br>2. Jalankan login/register. | Akses GPS: **DITOLAK** | Aplikasi tetap login tanpa crash; data lokasi di AppBar kosong atau menggunakan nilai default. | | |

---

### FITUR 2: GLOBAL MARKET SCREENER (PENCARIAN & FILTER)
* **File Terkait:** [home_screen.dart](file:///c:/Kuliah/Coding/RPL/crypto_screener/lib/screens/home_screen.dart) & [api_service.dart](file:///c:/Kuliah/Coding/RPL/crypto_screener/lib/services/api_service.dart)

| ID Uji | Skenario Pengujian | Langkah Pengujian | Data Uji | Hasil yang Diharapkan | Hasil Aktual | Status (PASS/FAIL) |
| :---: | :--- | :--- | :--- | :--- | :--- | :---: |
| **SCR-01** | Memuat data pasar awal | 1. Masuk ke halaman utama.<br>2. Amati visual saat memuat. | Koneksi Internet Aktif | Terdapat indikator loading (`CircularProgressIndicator`) kemudian menampilkan daftar aset global yang berisi nama, simbol, harga, dan persentase perubahan. | | |
| **SCR-02** | Pencarian aset berdasarkan Simbol | 1. Ketik simbol koin/saham pada search bar. | Kueri: `BTC` | Daftar terfilter secara *real-time* hanya menampilkan aset dengan simbol `BTC` (Bitcoin). | | |
| **SCR-03** | Pencarian aset berdasarkan Nama (Case-Insensitive) | 1. Ketik nama aset dengan huruf kecil/besar di search bar. | Kueri: `ethereum` | Daftar terfilter secara *real-time* menampilkan `ETH` (Ethereum) terlepas dari huruf kapital kueri. | | |
| **SCR-04** | Filter daftar aset menggunakan Dropdown Pasar | 1. Klik dropdown kategori pasar.<br>2. Pilih pasar tertentu. | Kategori: `Crypto` | Hanya aset dari pasar kripto (seperti BTC, ETH) yang tampil di daftar. | | |
| **SCR-05** | Refresh data secara manual | 1. Klik tombol Refresh pada AppBar atau lakukan gestur *Pull-to-Refresh*. | Aksi: Refresh | Indikator memuat muncul kembali, data diperbarui dari API eksternal. | | |

---

### FITUR 3: DETAIL ASET & GRAFIK TRADINGVIEW
* **File Terkait:** [detail_screen.dart](file:///c:/Kuliah/Coding/RPL/crypto_screener/lib/screens/detail_screen.dart)

| ID Uji | Skenario Pengujian | Langkah Pengujian | Data Uji | Hasil yang Diharapkan | Hasil Aktual | Status (PASS/FAIL) |
| :---: | :--- | :--- | :--- | :--- | :--- | :---: |
| **DET-01** | Membuka detail informasi aset | 1. Klik salah satu item aset pada daftar di halaman utama. | Aset: `BTC` | Halaman detail `BTC` terbuka, menampilkan nama, harga terkini (USD/IDR), perubahan persentase, dan waktu pemutakhiran data. | | |
| **DET-02** | Memuat grafik candlestick interaktif | 1. Masuk ke halaman detail aset.<br>2. Amati komponen WebView. | Koneksi Internet Aktif | Grafik TradingView (candlestick chart) termuat sepenuhnya di dalam WebView internal dengan indikator teknis MA & RSI. | | |
| **DET-03** | Pemicuan kalkulator risiko dari halaman detail | 1. Klik tombol "Hitung Risiko Trading" di bagian bawah layar detail. | Aksi: Klik tombol | Layar detail tertutup kembali ke Home, dan muncul SnackBar *"Silakan buka tab Tools untuk berhitung."* | | |

---

### FITUR 4: KALKULATOR RISIKO (POSITION SIZING)
* **File Terkait:** [risk_calculator_screen.dart](file:///c:/Kuliah/Coding/RPL/crypto_screener/lib/screens/risk_calculator_screen.dart)

Kalkulator menghitung berdasarkan rumus:
* $\text{Maksimal Kerugian} = \text{Total Modal} \times \left(\frac{\text{Risiko \%}}{100}\right)$
* $\text{Selisih Harga} = | \text{Harga Beli} - \text{Harga Stop Loss} |$
* $\text{Maksimal Unit yang Dibeli} = \frac{\text{Maksimal Kerugian}}{\text{Selisih Harga}}$
* $\text{Total Uang Transaksi} = \text{Maksimal Unit} \times \text{Harga Beli}$

#### A. Penerapan Equivalence Partitioning (EP)

| Parameter Input | Kategori Kelas Uji | Partisi Input Uji | Output yang Diharapkan | Status (PASS/FAIL) |
| :--- | :--- | :--- | :--- | :---: |
| **Total Modal (Capital)** | **Valid** | Angka $> 0$ (misal: `1000`) | Input diterima, kalkulasi berjalan normal. | |
| | **Invalid (Nol/Negatif)** | Angka $\le 0$ (misal: `0`, `-500`) | Perhitungan tidak berjalan / tidak ada perubahan hasil. | |
| | **Invalid (Non-numerik)** | Karakter teks (misal: `abc`) | Input diabaikan (dianggap `0`), kalkulasi tidak berjalan. | |
| **Persentase Risiko (%)** | **Valid** | Angka $0 < \text{Risiko} \le 100$ (misal: `2`) | Input diterima, kalkulasi berjalan normal. | |
| | **Invalid (Nol/Negatif)** | Angka $\le 0$ (misal: `0`, `-1`) | Perhitungan tidak berjalan / tidak ada perubahan hasil. | |
| | **Invalid ($> 100$)** | Angka $> 100$ (misal: `150`) | (Opsional jika dibatasi) Kalkulasi terhenti atau menghasilkan nilai tak logis. | |
| | **Invalid (Non-numerik)** | Karakter teks (misal: `xyz`) | Input diabaikan (dianggap `0`), kalkulasi terhenti. | |
| **Harga Beli (Entry Price)** | **Valid** | Angka $> 0$ (misal: `100`) | Input diterima, kalkulasi berjalan normal. | |
| | **Invalid (Nol/Negatif)** | Angka $\le 0$ (misal: `0`, `-10`) | Perhitungan tidak berjalan / tidak ada perubahan hasil. | |
| | **Invalid (Non-numerik)** | Karakter teks (misal: `abc`) | Input diabaikan (dianggap `0`), kalkulasi terhenti. | |
| **Harga Stop Loss (SL)** | **Valid** | Angka $> 0$ dan $\ne$ Harga Beli | Input diterima, kalkulasi berjalan normal. | |
| | **Invalid (Nol/Negatif)** | Angka $\le 0$ (misal: `0`, `-5`) | Perhitungan tidak berjalan / tidak ada perubahan hasil. | |
| | **Invalid (Sama dengan Entry)**| Angka == Harga Beli (misal: `100`) | Pembagian dengan nol terjadi di rumus $\to$ Perhitungan terhenti. | |
| | **Invalid (Non-numerik)** | Karakter teks (misal: `xyz`) | Input diabaikan (dianggap `0`), kalkulasi terhenti. | |

#### B. Penerapan Boundary Value Analysis (BVA)

| Parameter Input | Tipe Batas | Nilai Uji | Output yang Diharapkan | Hasil Aktual | Status (PASS/FAIL) |
| :--- | :--- | :--- | :--- | :--- | :---: |
| **Total Modal ($)** | Limit Bawah Tidak Valid | `0` | Kalkulasi tidak berjalan (Hasil tetap \$0.00). | | |
| | Limit Bawah Valid | `0.01` | Kalkulasi berjalan untuk modal mikro. | | |
| **Risiko (%)** | Limit Bawah Tidak Valid | `0` | Kalkulasi tidak berjalan. | | |
| | Limit Bawah Valid | `0.1` | Kalkulasi berjalan dengan nilai risiko sangat kecil. | | |
| | Limit Atas Valid | `100.0` | Kalkulasi berjalan (merisikokan seluruh modal). | | |
| | Limit Atas Tidak Valid | `100.1` | Sistem memberikan peringatan atau menolak kalkulasi $>100\%$. | | |
| **Harga Beli ($)** | Limit Bawah Tidak Valid | `0` | Kalkulasi tidak berjalan. | | |
| | Limit Bawah Valid | `0.01` | Kalkulasi berjalan normal. | | |
| **Selisih (Beli - SL)** | Limit Bawah Tidak Valid | `0` | Kalkulasi tidak berjalan (menghindari error pembagian dengan nol). | | |
| | Limit Bawah Valid | `0.01` | Kalkulasi berjalan dengan selisih yang sangat tipis. | | |

#### C. Tabel Keputusan (Decision Table)

Kondisi perhitungan kalkulator diatur oleh kode logika program:  
`if (capital > 0 && riskPercent > 0 && entryPrice > 0 && stopLossPrice > 0 && priceDifference > 0)`

* **K1:** Total Modal $> 0$
* **K2:** Risiko $\% > 0$
* **K3:** Harga Beli $> 0$
* **K4:** Stop Loss $> 0$ DAN $\ne$ Harga Beli

| Kondisi & Hasil | Case 1 | Case 2 | Case 3 | Case 4 | Case 5 | Case 6 |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: |
| **K1 (Modal > 0)** | **True** | **False** | **True** | **True** | **True** | **True** |
| **K2 (Risiko % > 0)** | **True** | **True** | **False** | **True** | **True** | **True** |
| **K3 (Harga Beli > 0)** | **True** | **True** | **True** | **False** | **True** | **True** |
| **K4 (SL > 0 & != Entry)**| **True** | **True** | **True** | **True** | **False** | **True** |
| **K5 (Selisih > 0)** | **True** | **True** | **True** | **True** | **True** | **False** |
| **Output (Kalkulasi Berhasil)**| **SUCCESS** | **ERROR** | **ERROR** | **ERROR** | **ERROR** | **ERROR** |
| **Hasil Pengujian Manual** | [ ] Pass<br>[ ] Fail | [ ] Pass<br>[ ] Fail | [ ] Pass<br>[ ] Fail | [ ] Pass<br>[ ] Fail | [ ] Pass<br>[ ] Fail | [ ] Pass<br>[ ] Fail |

---

### FITUR 5: PUSAT LITERASI (EDUKASI) & INTEGRASI PEMBAYARAN
* **File Terkait:** [education_screen.dart](file:///c:/Kuliah/Coding/RPL/crypto_screener/lib/screens/education_screen.dart) & [material_detail_screen.dart](file:///c:/Kuliah/Coding/RPL/crypto_screener/lib/screens/material_detail_screen.dart)

| ID Uji | Skenario Pengujian | Langkah Pengujian | Data Uji | Hasil yang Diharapkan | Hasil Aktual | Status (PASS/FAIL) |
| :---: | :--- | :--- | :--- | :--- | :--- | :---: |
| **EDU-01** | Akses modul pembelajaran gratis (Basic) | 1. Masuk ke tab Edukasi.<br>2. Klik modul berlabel gratis/basic. | Akun: Standar (Bukan Pro) | Modul terbuka, teks penjelasan dasar (Markdown) ditampilkan dengan jelas. | | |
| **EDU-02** | Akses modul premium (Strategi Pro) saat belum berlangganan | 1. Klik modul berlabel Premium.<br>2. Amati tampilan materi pro. | Akun: Standar (Bukan Pro) | Materi strategi premium ditutupi efek blur (*Locked Overlay*) dan muncul tombol "Upgrade Pro (Rp 50.000)". | | |
| **EDU-03** | Inisiasi Pembayaran Upgrade Pro | 1. Klik tombol "Upgrade Pro (Rp 50.000)". | Aksi: Klik tombol | Indikator loading checkout muncul, lalu memicu pembukaan halaman tagihan pembayaran Xendit dalam Webview internal. | | |
| **EDU-04** | Pembatalan Transaksi Pembayaran | 1. Buka halaman tagihan Xendit.<br>2. Tutup Webview secara manual tanpa membayar. | Aksi: Tutup Webview | Sesi terhenti, pengguna kembali ke halaman modul, status akun tetap standar (konten premium masih ter-blur). | | |
| **EDU-05** | Polling Pembayaran & Auto-Unlock Konten Pro | 1. Klik "Upgrade Pro".<br>2. Selesaikan pembayaran tagihan.<br>3. Amati perubahan halaman secara otomatis. | Simulasi Pembayaran Sukses | Setelah pembayaran dikonfirmasi (melalui polling database tiap 3 detik), WebView pembayaran menutup otomatis, UI diperbarui, efek blur hilang, dan muncul SnackBar sukses. | | |

---

### FITUR 6: MANAJEMEN PROFIL & LOGOUT
* **File Terkait:** [profile_screen.dart](file:///c:/Kuliah/Coding/RPL/crypto_screener/lib/screens/profile_screen.dart)

| ID Uji | Skenario Pengujian | Langkah Pengujian | Data Uji | Hasil yang Diharapkan | Hasil Aktual | Status (PASS/FAIL) |
| :---: | :--- | :--- | :--- | :--- | :--- | :---: |
| **PRO-01** | Tampilan Informasi Profil Pengguna | 1. Buka tab Profil.<br>2. Verifikasi data email dan lokasi. | Akun: Sedang Login | Layar menampilkan alamat email pengguna dan data kota tempat login saat ini secara akurat. | | |
| **PRO-02** | Proses Logout Akun | 1. Klik tombol "Keluar (Logout)". | Aksi: Klik tombol | Sesi pengguna dihapus, pengguna langsung diarahkan kembali ke halaman Autentikasi (`AuthScreen`). | | |
