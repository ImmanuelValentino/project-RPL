import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = true;
  bool _isPremium = false;
  String _userEmail = '';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        setState(() => _userEmail = user.email ?? 'No Email');

        final data = await Supabase.instance.client
            .from('profiles')
            .select('is_premium')
            .eq('id', user.id)
            .single();

        setState(() {
          _isPremium = data['is_premium'] ?? false;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Pesan Error: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
      setState(() => _isLoading = false);
    }
  }

  Future<void> _logout() async {
    await Supabase.instance.client.auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Profil Saya')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: _isPremium ? Colors.amber[100] : Colors.white,
            child: ListTile(
              leading: Icon(
                _isPremium ? Icons.workspace_premium : Icons.account_circle,
                size: 40,
                color: _isPremium ? Colors.orange : Colors.indigo,
              ),
              title: Text(_userEmail, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(_isPremium ? 'Member Alchemist Pro' : 'Akun WengTrade Basic'),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: _logout,
            icon: const Icon(Icons.logout, color: Colors.white),
            label: const Text('Keluar (Logout)', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red[400]),
          )
        ],
      ),
    );
  }
}