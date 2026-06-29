import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/location_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  bool _isLogin = true; // Toggle antara Login dan Register
  bool _isLoading = false;

  void _submit() async {
    setState(() => _isLoading = true);
    try {
      // 1. Ambil Data Lokasi (Berjalan di background, tidak bikin crash kalau ditolak)
      final locationData = await LocationService.getLocationData();
      double? lat;
      double? lng;
      String? city;

      if (locationData != null) {
        lat = locationData['latitude'];
        lng = locationData['longitude'];
        city = locationData['city'];
        debugPrint('Lokasi terdeteksi: $city ($lat, $lng)');
      } else {
        debugPrint('Lokasi gagal didapatkan atau izin ditolak user.');
      }

      // 2. Eksekusi Login / Register
      if (_isLogin) {
        await _authService.login(_emailController.text, _passwordController.text);
      } else {
        await _authService.register(_emailController.text, _passwordController.text);

        // Sengaja tidak langsung dipindah halamannya kalau baru daftar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registrasi Berhasil! Silakan Login')),
        );
        setState(() => _isLogin = true);
      }

      // 3. Simpan Koordinat & Kota ke Database (Tabel 'profiles')
      // Kita cek apakah user sudah berhasil terautentikasi
      final user = Supabase.instance.client.auth.currentUser;

      // Jika user berhasil masuk/terdaftar DAN lokasi berhasil didapatkan
      if (user != null && locationData != null) {
        await Supabase.instance.client.from('profiles').upsert({
          'id': user.id, // Primary Key yang nyambung ke auth.users
          'email': user.email,
          'latitude': lat,
          'longitude': lng,
          'city': city,
        });
        debugPrint('Data lokasi berhasil disimpan ke database!');
      }

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      // Pengecekan 'mounted' penting agar tidak error saat layar berganti otomatis via AuthGate
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigo[900]!, Colors.indigo[600]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.auto_graph, size: 64, color: Colors.indigo),
                    const SizedBox(height: 16),
                    const Text(
                      'WengTrade',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.indigo),
                    ),
                    const Text('Screener & Learning Hub', style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 32),
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text(
                          _isLogin ? 'Masuk' : 'Daftar',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => setState(() => _isLogin = !_isLogin),
                      child: Text(_isLogin ? 'Belum punya akun? Daftar' : 'Sudah punya akun? Login'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}