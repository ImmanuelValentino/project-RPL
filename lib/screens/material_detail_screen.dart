// Created by Immanuel
import 'dart:ui';
import 'dart:async'; // Untuk menggunakan Timer
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_markdown/flutter_markdown.dart'; // Import baru

class MaterialDetailScreen extends StatefulWidget {
  final String slug;

  const MaterialDetailScreen({super.key, required this.slug});

  @override
  State<MaterialDetailScreen> createState() => _MaterialDetailScreenState();
}

class _MaterialDetailScreenState extends State<MaterialDetailScreen> {
  bool _isLoading = true;
  bool _isPremium = false;
  bool _isCheckoutLoading = false;
  Map<String, dynamic>? _moduleData;

  Timer? _paymentTimer;

  // Pastikan timer dimatikan saat user pindah/keluar dari halaman ini
  @override
  void dispose() {
    _paymentTimer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  Future<void> _loadContent() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return;

      final results = await Future.wait([
        Supabase.instance.client.from('profiles').select('is_premium').eq('id', user.id).single(),
        Supabase.instance.client.from('modules').select().eq('slug', widget.slug).single(),
      ]);

      setState(() {
        _isPremium = results[0]['is_premium'] ?? false;
        _moduleData = results[1];
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading content: $e');
      setState(() => _isLoading = false);
    }
  }

  // FUNGSI CHECKOUT YANG SUDAH DIPERBAIKI DENGAN AUTO-CLOSE
  Future<void> _startCheckout() async {
    setState(() => _isCheckoutLoading = true);
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) throw 'User tidak ditemukan.';

      final url = Uri.parse('https://wengtrade-api.immanuel.my.id/create-subscription');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': user.id,
          'email': user.email ?? 'user@wengtrade.com',
          'amount': 50000
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success']) {
        final checkoutUrl = Uri.parse(responseData['checkout_url']);

        if (await canLaunchUrl(checkoutUrl)) {
          // 1. Buka Xendit di dalam In-App Webview
          await launchUrl(checkoutUrl, mode: LaunchMode.inAppWebView);

          // 2. Mulai Polling: Cek database tiap 3 detik
          _paymentTimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
            try {
              final checkUser = await Supabase.instance.client
                  .from('profiles')
                  .select('is_premium')
                  .eq('id', user.id)
                  .single();

              // 3. Jika sudah bayar, aksi keajaiban dimulai
              if (checkUser['is_premium'] == true) {
                timer.cancel(); // Matikan timer
                await closeInAppWebView(); // Tutup layar Xendit

                if (mounted) {
                  // Langsung ubah UI jadi premium tanpa perlu pindah halaman!
                  setState(() {
                    _isPremium = true;
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Pembayaran Berhasil! Selamat datang di Alchemist Pro 🚀'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              }
            } catch (e) {
              // Biarkan kosong, abaikan error saat mengecek
            }
          });
        }
      } else {
        throw responseData['message'] ?? 'Gagal menghubungi server.';
      }
    } catch (e) {
      debugPrint('Error Checkout: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isCheckoutLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_moduleData?['title'] ?? 'Memuat...')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.indigo))
          : _moduleData == null
          ? const Center(child: Text('Materi tidak ditemukan.'))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_moduleData!['title'], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.indigo)),
            const SizedBox(height: 16),

            // SEKARANG MENGGUNAKAN MARKDOWN UNTUK BASIC
            MarkdownBody(
              data: _moduleData!['content_basic'] ?? '',
              styleSheet: MarkdownStyleSheet(
                p: const TextStyle(fontSize: 16, height: 1.5),
              ),
            ),

            const SizedBox(height: 24),

            if (_isPremium)
              _buildPremiumContent(_moduleData!['content_premium'] ?? '')
            else
              _buildLockedOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumContent(String content) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.amber[50], borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.amber)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.workspace_premium, color: Colors.orange),
              SizedBox(width: 8),
              Text('Strategi Alchemist Pro', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
            ],
          ),
          const SizedBox(height: 12),
          // SEKARANG MENGGUNAKAN MARKDOWN UNTUK PREMIUM
          MarkdownBody(
            data: content,
            styleSheet: MarkdownStyleSheet(
              p: const TextStyle(fontSize: 16, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLockedOverlay() {
    return Stack(
      alignment: Alignment.center,
      children: [
        ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: const Text(
            'Bagian ini berisi strategi entri rahasia yang sangat akurat. Segera upgrade akun Anda untuk membukanya.',
            style: TextStyle(fontSize: 16, height: 1.5),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              const Icon(Icons.lock_outline, size: 48, color: Colors.indigo),
              const SizedBox(height: 12),
              const Text('Konten Pro', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  onPressed: _isCheckoutLoading ? null : _startCheckout,
                  child: _isCheckoutLoading
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('Upgrade Pro (Rp 50.000)', style: TextStyle(color: Colors.white)),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}