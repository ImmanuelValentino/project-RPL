// Created by Immanuel
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'material_detail_screen.dart';

class EducationScreen extends StatefulWidget {
  const EducationScreen({super.key});

  @override
  State<EducationScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends State<EducationScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _modules = [];

  @override
  void initState() {
    super.initState();
    _fetchModules();
  }

  // Menarik daftar modul dari tabel 'modules' di Supabase
  Future<void> _fetchModules() async {
    try {
      final data = await Supabase.instance.client
          .from('modules')
          .select()
          .order('order_index', ascending: true);

      setState(() {
        _modules = List<Map<String, dynamic>>.from(data);
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching modules: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pusat Literasi'), centerTitle: true),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.indigo))
          : RefreshIndicator(
        onRefresh: _fetchModules,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildHeaderBanner(),
            const SizedBox(height: 24),
            const Text('Modul Pembelajaran', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            // Menampilkan daftar modul secara dinamis dari database
            if (_modules.isEmpty)
              const Center(child: Text('Belum ada materi tersedia.'))
            else
              ..._modules.asMap().entries.map((entry) {
                int idx = entry.key;
                var module = entry.value;
                return _buildModuleCard(
                  context,
                  idx + 1,
                  module['title'],
                  module['slug'], // Kita kirim slug untuk pencarian di halaman detail
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderBanner() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.indigo,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        children: [
          Icon(Icons.school, color: Colors.white, size: 40),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('WengTrade', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text('Ubah pengetahuan menjadi profit. Hindari FOMO.', style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModuleCard(BuildContext context, int number, String title, String slug) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.indigo[50],
          child: Text(number.toString(), style: const TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold)),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MaterialDetailScreen(slug: slug),
            ),
          );
        },
      ),
    );
  }
}