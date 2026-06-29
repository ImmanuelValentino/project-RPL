// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class ApiService {
  static const String _apiKey = 'd6n42ghr01qir35j40hgd6n42ghr01qir35j40i0';
  static const String _baseUrl = 'https://wengtrade-ihsg.immanuel.my.id';

  // PORTOFOLIO REBALANCED: 15 Kripto | 15 S&P 500 | 15 IDX
  static const List<Map<String, dynamic>> _assets = [

    // --- TOP 15 CRYPTOCURRENCY ---
    {'symbol': 'BINANCE:BTCUSDT', 'display': 'BTC', 'name': 'Bitcoin', 'market': 'Crypto'},
    {'symbol': 'BINANCE:ETHUSDT', 'display': 'ETH', 'name': 'Ethereum', 'market': 'Crypto'},
    {'symbol': 'BINANCE:BNBUSDT', 'display': 'BNB', 'name': 'Binance Coin', 'market': 'Crypto'},
    {'symbol': 'BINANCE:SOLUSDT', 'display': 'SOL', 'name': 'Solana', 'market': 'Crypto'},
    {'symbol': 'BINANCE:XRPUSDT', 'display': 'XRP', 'name': 'Ripple', 'market': 'Crypto'},
    {'symbol': 'BINANCE:ADAUSDT', 'display': 'ADA', 'name': 'Cardano', 'market': 'Crypto'},
    {'symbol': 'BINANCE:DOGEUSDT', 'display': 'DOGE', 'name': 'Dogecoin', 'market': 'Crypto'},
    {'symbol': 'BINANCE:AVAXUSDT', 'display': 'AVAX', 'name': 'Avalanche', 'market': 'Crypto'},
    {'symbol': 'BINANCE:SHIBUSDT', 'display': 'SHIB', 'name': 'Shiba Inu', 'market': 'Crypto'},
    {'symbol': 'BINANCE:DOTUSDT', 'display': 'DOT', 'name': 'Polkadot', 'market': 'Crypto'},
    {'symbol': 'BINANCE:LINKUSDT', 'display': 'LINK', 'name': 'Chainlink', 'market': 'Crypto'},
    {'symbol': 'BINANCE:MATICUSDT', 'display': 'MATIC', 'name': 'Polygon', 'market': 'Crypto'},
    {'symbol': 'BINANCE:TRXUSDT', 'display': 'TRX', 'name': 'TRON', 'market': 'Crypto'},
    {'symbol': 'BINANCE:BCHUSDT', 'display': 'BCH', 'name': 'Bitcoin Cash', 'market': 'Crypto'},
    {'symbol': 'BINANCE:LTCUSDT', 'display': 'LTC', 'name': 'Litecoin', 'market': 'Crypto'},

    // --- TOP 15 S&P 500 (US STOCKS) ---
    {'symbol': 'AAPL', 'display': 'AAPL', 'name': 'Apple Inc.', 'market': 'S&P 500'},
    {'symbol': 'MSFT', 'display': 'MSFT', 'name': 'Microsoft Corp.', 'market': 'S&P 500'},
    {'symbol': 'NVDA', 'display': 'NVDA', 'name': 'NVIDIA Corp.', 'market': 'S&P 500'},
    {'symbol': 'AMZN', 'display': 'AMZN', 'name': 'Amazon.com Inc.', 'market': 'S&P 500'},
    {'symbol': 'GOOGL', 'display': 'GOOGL', 'name': 'Alphabet Inc.', 'market': 'S&P 500'},
    {'symbol': 'META', 'display': 'META', 'name': 'Meta Platforms Inc.', 'market': 'S&P 500'},
    {'symbol': 'TSLA', 'display': 'TSLA', 'name': 'Tesla Inc.', 'market': 'S&P 500'},
    {'symbol': 'BRK.B', 'display': 'BRK.B', 'name': 'Berkshire Hathaway', 'market': 'S&P 500'},
    {'symbol': 'LLY', 'display': 'LLY', 'name': 'Eli Lilly and Co.', 'market': 'S&P 500'},
    {'symbol': 'JPM', 'display': 'JPM', 'name': 'JPMorgan Chase', 'market': 'S&P 500'},
    {'symbol': 'V', 'display': 'V', 'name': 'Visa Inc.', 'market': 'S&P 500'},
    {'symbol': 'WMT', 'display': 'WMT', 'name': 'Walmart Inc.', 'market': 'S&P 500'},
    {'symbol': 'UNH', 'display': 'UNH', 'name': 'UnitedHealth Group', 'market': 'S&P 500'},
    {'symbol': 'JNJ', 'display': 'JNJ', 'name': 'Johnson & Johnson', 'market': 'S&P 500'},
    {'symbol': 'PG', 'display': 'PG', 'name': 'Procter & Gamble', 'market': 'S&P 500'},

    // --- TOP 15 IHSG (INDONESIA STOCKS) ---
    {'symbol': 'BBCA.JK', 'display': 'BBCA', 'name': 'Bank Central Asia Tbk', 'market': 'IDX'},
    {'symbol': 'BBRI.JK', 'display': 'BBRI', 'name': 'Bank Rakyat Indonesia', 'market': 'IDX'},
    {'symbol': 'BMRI.JK', 'display': 'BMRI', 'name': 'Bank Mandiri Tbk', 'market': 'IDX'},
    {'symbol': 'BBNI.JK', 'display': 'BBNI', 'name': 'Bank Negara Indonesia', 'market': 'IDX'},
    {'symbol': 'ASII.JK', 'display': 'ASII', 'name': 'Astra International', 'market': 'IDX'},
    {'symbol': 'TLKM.JK', 'display': 'TLKM', 'name': 'Telkom Indonesia Tbk', 'market': 'IDX'},
    {'symbol': 'AMMN.JK', 'display': 'AMMN', 'name': 'Amman Mineral Tbk', 'market': 'IDX'},
    {'symbol': 'BREN.JK', 'display': 'BREN', 'name': 'Barito Renewables', 'market': 'IDX'},
    {'symbol': 'TPIA.JK', 'display': 'TPIA', 'name': 'Chandra Asri Pacific', 'market': 'IDX'},
    {'symbol': 'GOTO.JK', 'display': 'GOTO', 'name': 'GoTo Gojek Tokopedia', 'market': 'IDX'},
    {'symbol': 'ADRO.JK', 'display': 'ADRO', 'name': 'Adaro Energy Tbk', 'market': 'IDX'},
    {'symbol': 'PTBA.JK', 'display': 'PTBA', 'name': 'Bukit Asam Tbk', 'market': 'IDX'},
    {'symbol': 'UNTR.JK', 'display': 'UNTR', 'name': 'United Tractors Tbk', 'market': 'IDX'},
    {'symbol': 'ICBP.JK', 'display': 'ICBP', 'name': 'Indofood CBP Sukses', 'market': 'IDX'},
    {'symbol': 'INDF.JK', 'display': 'INDF', 'name': 'Indofood Sukses Makmur', 'market': 'IDX'},
  ];

  static Future<List<dynamic>> fetchInitialData() async {
    List<dynamic> results = [];

    // 1. Ambil Data Finnhub (US & Crypto) - Paralel
    final finnhubAssets = _assets.where((a) => a['market'] != 'IDX').toList();
    final List<Future<Map<String, dynamic>?>> finnhubFutures = finnhubAssets.map((asset) async {
      try {
        final url = 'https://finnhub.io/api/v1/quote?symbol=${asset['symbol']}&token=$_apiKey';
        final res = await http.get(Uri.parse(url));
        if (res.statusCode == 200) {
          final d = json.decode(res.body);
          return {
            'symbol': asset['display'],
            'name': asset['name'],
            'market': asset['market'],
            'price': (d['c'] as num?)?.toDouble() ?? 0.0,
            'change24h': (d['dp'] as num?)?.toDouble() ?? 0.0,
            'apiSymbol': asset['symbol'],
          };
        }
      } catch (e) {
        debugPrint('Error Finnhub ${asset['symbol']}: $e');
      }
      return null;
    }).toList();

    // 2. Ambil Data IDX dari Flask Python
    Future<List<Map<String, dynamic>>> fetchIdxData() async {
      List<Map<String, dynamic>> idxResults = [];
      try {
        final idxAssets = _assets.where((a) => a['market'] == 'IDX').toList();
        final idxSymbols = idxAssets.map((a) => a['symbol']).join(",");

        final url = '$_baseUrl/idx-data?symbols=$idxSymbols';
        final res = await http.get(Uri.parse(url));

        if (res.statusCode == 200) {
          final List<dynamic> idxData = json.decode(res.body);
          for (var data in idxData) {
            final sym = data['symbol'].toString();
            final original = idxAssets.firstWhere((a) => a['display'] == sym, orElse: () => <String, dynamic>{});
            if (original.isNotEmpty) {
              idxResults.add({
                'symbol': original['display'],
                'name': original['name'],
                'market': 'IDX',
                'price': (data['price'] as num?)?.toDouble() ?? 0.0,
                'change24h': (data['change24h'] as num?)?.toDouble() ?? 0.0,
                'apiSymbol': original['symbol'],
              });
            }
          }
        }
      } catch (e) {
        debugPrint("Error Parsing IDX: $e");
      }
      return idxResults;
    }

    // 3. Jalankan Bersamaan
    final finnhubResults = await Future.wait(finnhubFutures);
    final idxResults = await fetchIdxData();

    // 4. Gabungkan
    results.addAll(finnhubResults.whereType<Map<String, dynamic>>());
    results.addAll(idxResults);

    return results;
  }
}