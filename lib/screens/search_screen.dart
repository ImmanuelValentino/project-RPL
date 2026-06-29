import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<dynamic> allData = [];
  List<dynamic> filteredData = [];
  bool isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadDataForSearch();
  }

  Future<void> _loadDataForSearch() async {
    final data = await ApiService.fetchInitialData();
    if (mounted) {
      setState(() {
        allData = data;
        isLoading = false;
      });
      _applyFilters();
    }
  }

  void _applyFilters() {
    String keyword = _searchController.text.toLowerCase().trim();
    List<dynamic> results = allData;

    if (keyword.isNotEmpty) {
      results = results.where((asset) {
        String s1 = (asset['symbol'] ?? '').toString().toLowerCase();
        String s2 = (asset['name'] ?? '').toString().toLowerCase();
        return s1.contains(keyword) || s2.contains(keyword);
      }).toList();
    }

    setState(() {
      filteredData = results;
    });
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
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Pencarian Global', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.white,
            child: TextField(
              controller: _searchController,
              onChanged: (value) => _applyFilters(),
              decoration: InputDecoration(
                hintText: 'Cari BTC, AAPL, GOTO...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredData.isEmpty
                ? const Center(child: Text('Aset tidak ditemukan.', style: TextStyle(color: Colors.grey)))
                : ListView.builder(
              itemCount: filteredData.length,
              itemBuilder: (context, index) {
                final asset = filteredData[index];
                final bool isPositive = asset['change24h'] >= 0;

                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(asset: asset),
                      ),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    color: Colors.white,
                    elevation: 0.5,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: _getMarketColor(asset['market']).withOpacity(0.1),
                        child: Text(
                          asset['symbol'].substring(0, 1),
                          style: TextStyle(fontWeight: FontWeight.bold, color: _getMarketColor(asset['market'])),
                        ),
                      ),
                      title: Row(
                        children: [
                          Text(asset['symbol'], style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                            decoration: BoxDecoration(
                              color: _getMarketColor(asset['market']),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              asset['market'],
                              style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      subtitle: Text(asset['name'], style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            asset['market'] == 'IDX'
                                ? 'Rp ${asset['price'].toStringAsFixed(0)}'
                                : '\$${asset['price'].toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: isPositive ? Colors.green[50] : Colors.red[50],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${isPositive ? '+' : ''}${asset['change24h'].toStringAsFixed(2)}%',
                              style: TextStyle(
                                color: isPositive ? Colors.green[700] : Colors.red[700],
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
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
        ],
      ),
    );
  }
}