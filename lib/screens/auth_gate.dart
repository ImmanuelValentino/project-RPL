// Created by Immanuel
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'auth_screen.dart';
import 'education_screen.dart'; // Gantilah dengan file yang berisi layout utama kamu
import 'main_layout.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      // Memantau status autentikasi secara real-time
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        // Tampilkan loading saat sedang mengecek status session
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Colors.indigo),
            ),
          );
        }

        // Mengambil data session
        final session = snapshot.hasData ? snapshot.data!.session : null;

        if (session != null) {
          // JIKA SUDAH LOGIN: Arahkan ke Halaman Utama (EducationScreen atau MainLayout)
          // Di sini saya arahkan ke EducationScreen sebagai contoh
          return const MainLayout();
        }

        // JIKA BELUM LOGIN: Tampilkan halaman Auth (Login/Register)
        return const AuthScreen();
      },
    );
  }
}