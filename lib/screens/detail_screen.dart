import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:intl/intl.dart';

class DetailScreen extends StatefulWidget {
  final Map<String, dynamic> asset;

  const DetailScreen({super.key, required this.asset});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  InAppWebViewController? webViewController;
  late final String _tradingViewHtml;

  @override
  void initState() {
    super.initState();
    _tradingViewHtml = _buildTradingViewHtml(widget.asset['apiSymbol'], widget.asset['market']);
  }

  String _buildTradingViewHtml(String apiSymbol, String marketType) {
    String tvSymbol = apiSymbol;
    if (marketType == 'Crypto') {
      tvSymbol = apiSymbol.replaceAll('USDT', 'USD');
    } else if (marketType == 'S&P 500') {
      tvSymbol = apiSymbol;
    } else if (marketType == 'IDX') {
      tvSymbol = "IDX:${apiSymbol.replaceAll('.JK', '')}";
    }

    return """
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TradingView Chart</title>
    <script type="text/javascript" src="https://s3.tradingview.com/tv.js"></script>
    <style>
        body { margin: 0; padding: 0; height: 100vh; overflow: hidden; background-color: #f9fafb; }
        #tradingview_widget { height: 100vh; }
    </style>
</head>
<body>
    <div id="tradingview_widget"></div>
    <script type="text/javascript">
        new TradingView.widget({
            "autosize": true,
            "symbol": "$tvSymbol",
            "interval": "15",
            "timezone": "Etc/UTC",
            "theme": "light",
            "style": "1",
            "locale": "en",
            "toolbar_bg": "#f1f3f6",
            "enable_publishing": false,
            "withdateranges": true,
            "hide_side_toolbar": false,
            "allow_symbol_change": false,
            "details": true,
            "hotlist": false,
            "calendar": false,
            "show_popup_button": false,
            "studies": [
                "MASimple@tv-basicstudies",
                "RSI@tv-basicstudies"
            ],
            "container_id": "tradingview_widget"
        });
    </script>
</body>
</html>
""";
  }

  @override
  Widget build(BuildContext context) {
    final bool isPositive = widget.asset['change24h'] >= 0;
    final String formattedDate = DateFormat('dd MMM yyyy, HH:mm').format(DateTime.now());

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
            '${widget.asset['symbol']} / ${widget.asset['market'] == 'IDX' ? 'IDR' : 'USD'}',
            style: const TextStyle(fontWeight: FontWeight.bold)
        ),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.asset['name'], style: const TextStyle(fontSize: 16, color: Colors.grey), overflow: TextOverflow.ellipsis),
                      Text(
                        widget.asset['market'] == 'IDX'
                            ? 'Rp ${widget.asset['price'].toStringAsFixed(0)}'
                            : '\$${widget.asset['price'].toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isPositive ? Colors.green[50] : Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${isPositive ? '+' : ''}${widget.asset['change24h'].toStringAsFixed(2)}%',
                    style: TextStyle(
                      color: isPositive ? Colors.green[700] : Colors.red[700],
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Data per: $formattedDate', style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 24),

            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InAppWebView(
                    initialData: InAppWebViewInitialData(
                      data: _tradingViewHtml,
                      mimeType: 'text/html',
                      encoding: 'utf-8',
                    ),
                    onWebViewCreated: (controller) {
                      webViewController = controller;
                    },
                    onLoadError: (controller, url, code, message) {
                      print('WebView Error: $message');
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Silakan buka tab Tools untuk berhitung.')),
                  );
                },
                icon: const Icon(Icons.calculate, color: Colors.white),
                label: const Text('Hitung Risiko Trading', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}