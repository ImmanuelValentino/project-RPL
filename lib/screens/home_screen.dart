// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/api_service.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> marketData = [];
  bool isLoading = true;

  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // Variabel untuk Dropdown Filter
  String selectedMarket = 'Semua';
  final List<String> marketOptions = ['Semua', 'Crypto', 'S&P 500', 'IDX'];

  // Variabel untuk menyimpan nama kota user
  String? userCity;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _fetchUserCity(); // Panggil fungsi untuk mengambil kota saat layar pertama kali dibuka
  }

  // Fungsi untuk menarik data kota dari Supabase
  Future<void> _fetchUserCity() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        final data = await Supabase.instance.client
            .from('profiles')
            .select('city')
            .eq('id', user.id)
            .maybeSingle();

        if (data != null && data['city'] != null && mounted) {
          setState(() {
            userCity = data['city'];
          });
        }
      }
    } catch (e) {
      debugPrint('Error fetch city: $e');
    }
  }

  Future<void> _loadInitialData() async {
    if (!mounted) return;
    setState(() => isLoading = true);

    try {
      final data = await ApiService.fetchInitialData();
      if (mounted) {
        setState(() {
          marketData = data;
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error saat memuat data: $e');
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Color _getMarketColor(String market) {
    switch (market) {
      case 'Crypto': return Colors.orange;
      case 'S&P 500': return Colors.blue;
      case 'IDX': return Colors.redAccent;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Logika filter gabungan: Pencarian teks & Pilihan Dropdown
    final displayedData = marketData.where((asset) {
      final matchesSearch = asset['symbol'].toLowerCase().contains(searchQuery.toLowerCase()) ||
          asset['name'].toLowerCase().contains(searchQuery.toLowerCase());

      final matchesMarket = selectedMarket == 'Semua' || asset['market'] == selectedMarket;

      return matchesSearch && matchesMarket;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Global Market', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            // Jika userCity sudah berhasil ditarik, tampilkan kotaknya di sebelah judul
            if (userCity != null) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.indigo[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_on, size: 14, color: Colors.indigo),
                    const SizedBox(width: 4),
                    Text(
                      userCity!,
                      style: const TextStyle(fontSize: 12, color: Colors.indigo, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ]
          ],
        ),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.indigo),
            onPressed: _loadInitialData,
          )
        ],
      ),
      body: Column(
        children: [
          // Bagian Search Bar dan Dropdown Filter
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                // Search Bar
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) => setState(() => searchQuery = value),
                    decoration: InputDecoration(
                      hintText: 'Cari aset...',
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      suffixIcon: searchQuery.isNotEmpty
                          ? IconButton(
                        icon: const Icon(Icons.clear, size: 20),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => searchQuery = '');
                        },
                      )
                          : null,
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Dropdown Filter Pasar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.indigo[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedMarket,
                      icon: const Icon(Icons.filter_list, color: Colors.indigo),
                      style: const TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold),
                      dropdownColor: Colors.white,
                      items: marketOptions.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            selectedMarket = newValue;
                          });
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bagian List Data
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : displayedData.isEmpty
                ? Center(child: Text(searchQuery.isEmpty ? 'Gagal memuat aset.' : 'Aset tidak ditemukan.', style: const TextStyle(color: Colors.grey)))
                : RefreshIndicator(
              onRefresh: _loadInitialData,
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: displayedData.length,
                itemBuilder: (context, index) {
                  final asset = displayedData[index];
                  final bool isPositive = asset['change24h'] >= 0;

                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    color: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey[200]!),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => DetailScreen(asset: asset)),
                        );
                      },
                      child: ListTile(
                        contentPadding: const EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 4),
                        leading: CircleAvatar(
                          backgroundColor: _getMarketColor(asset['market']).withOpacity(0.1),
                          child: Text(
                            asset['symbol'].substring(0, 1),
                            style: TextStyle(fontWeight: FontWeight.bold, color: _getMarketColor(asset['market'])),
                          ),
                        ),
                        title: Row(
                          children: [
                            Text(asset['symbol'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                              decoration: BoxDecoration(
                                color: _getMarketColor(asset['market']),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(asset['market'], style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        subtitle: Text(asset['name'], style: const TextStyle(fontSize: 12)),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              asset['market'] == 'IDX'
                                  ? 'Rp ${asset['price'].toStringAsFixed(0)}'
                                  : '\$${asset['price'].toStringAsFixed(2)}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: isPositive ? Colors.green[50] : Colors.red[50],
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '${isPositive ? '+' : ''}${asset['change24h'].toStringAsFixed(2)}%',
                                style: TextStyle(
                                  color: isPositive ? Colors.green[700] : Colors.red[700],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}