// url: 'https://mfxgjcqjgcqpdmgrsxmj.supabase.co', // URL dari dashboard
// anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1meGdqY3FqZ2NxcGRtZ3JzeG1qIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzU1OTI0NjcsImV4cCI6MjA5MTE2ODQ2N30.t2zS_-lyMEj4qfGeB_Pi0B7JOYuXLfU9hPV0s6CZ64w', // Anon Key dari dashboard kamu

// Created by Immanuel
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/auth_gate.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  // Inisialisasi Supabase dengan URL dan Anon Key 
  await Supabase.initialize(
    url: 'https://mfxgjcqjgcqpdmgrsxmj.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1meGdqY3FqZ2NxcGRtZ3JzeG1qIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzU1OTI0NjcsImV4cCI6MjA5MTE2ODQ2N30.t2zS_-lyMEj4qfGeB_Pi0B7JOYuXLfU9hPV0s6CZ64w',
  );



  runApp(const WengTradeApp());
}

class WengTradeApp extends StatelessWidget {
  const WengTradeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WengTrade',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
        // Global style untuk AppBar agar seragam di seluruh aplikasi
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.black),
        ),
      ),
      // AuthGate akan menentukan apakah menampilkan Login atau Dashboard
      home: const AuthGate(),
    );
  }
}