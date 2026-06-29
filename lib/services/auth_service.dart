import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // REGISTER: Password otomatis di-encrypt oleh Supabase
  Future<AuthResponse> register(String email, String password) async {
    return await _supabase.auth.signUp(
      email: email,
      password: password,
    );
  }

  // LOGIN
  Future<AuthResponse> login(String email, String password) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // LOGOUT
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // Cek apakah ada user yang sedang login
  User? get currentUser => _supabase.auth.currentUser;
}