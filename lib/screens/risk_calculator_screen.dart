// lib/screens/risk_calculator_screen.dart
import 'package:flutter/material.dart';

class RiskCalculatorScreen extends StatefulWidget {
  const RiskCalculatorScreen({super.key});

  @override
  State<RiskCalculatorScreen> createState() => _RiskCalculatorScreenState();
}

class _RiskCalculatorScreenState extends State<RiskCalculatorScreen> {
  // Controller untuk membaca inputan teks dari pengguna
  final _capitalController = TextEditingController();
  final _riskPercentController = TextEditingController(text: '2'); // Default 2%
  final _entryPriceController = TextEditingController();
  final _stopLossController = TextEditingController();

  // Variabel untuk menyimpan hasil perhitungan
  double _riskAmount = 0;
  double _positionSizeCoins = 0;
  double _totalInvestment = 0;

  // Fungsi matematika inti ala Trading Alchemist
  void _calculateRisk() {
    final capital = double.tryParse(_capitalController.text) ?? 0;
    final riskPercent = double.tryParse(_riskPercentController.text) ?? 0;
    final entryPrice = double.tryParse(_entryPriceController.text) ?? 0;
    final stopLossPrice = double.tryParse(_stopLossController.text) ?? 0;

    if (capital > 0 && riskPercent > 0 && entryPrice > 0 && stopLossPrice > 0) {
      // 1. Berapa Dolar maksimal kita rela rugi?
      final maxLossAmount = capital * (riskPercent / 100);

      // 2. Berapa jarak kerugian per koin/saham?
      final priceDifference = (entryPrice - stopLossPrice).abs();

      if (priceDifference > 0) {
        // 3. Berapa unit yang boleh dibeli?
        final positionSize = maxLossAmount / priceDifference;

        // 4. Total uang yang harus dikeluarkan untuk membeli unit tersebut
        final totalInvest = positionSize * entryPrice;

        setState(() {
          _riskAmount = maxLossAmount;
          _positionSizeCoins = positionSize;
          _totalInvestment = totalInvest;
        });
      }
    }
  }

  // Membersihkan memori saat halaman ditutup
  @override
  void dispose() {
    _capitalController.dispose();
    _riskPercentController.dispose();
    _entryPriceController.dispose();
    _stopLossController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Kalkulator Risiko', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Edukasi
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.indigo[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.indigo.withOpacity(0.2)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.shield, color: Colors.indigo, size: 32),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Trading Alchemist Rule: Jangan pernah merisikokan lebih dari 1-2% total modal dalam satu transaksi.',
                      style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Form Input
            const Text('1. Tentukan Batas Modal & Risiko', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _capitalController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Total Modal (\$)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.account_balance_wallet),
                    ),
                    onChanged: (value) => _calculateRisk(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 1,
                  child: TextField(
                    controller: _riskPercentController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Risiko (%)',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => _calculateRisk(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            const Text('2. Rencana Transaksi (Trading Plan)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _entryPriceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Harga Beli (\$)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.login),
                    ),
                    onChanged: (value) => _calculateRisk(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _stopLossController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Stop Loss (\$)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.error_outline, color: Colors.red),
                    ),
                    onChanged: (value) => _calculateRisk(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Kartu Hasil Rekomendasi
            const Text('Rekomendasi Position Sizing', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 12),
            Card(
              color: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    _buildResultRow('Maksimal Kerugian (Uang Hilang)', '\$${_riskAmount.toStringAsFixed(2)}', Colors.red),
                    const Divider(height: 24),
                    _buildResultRow('Maksimal Unit/Koin yang Dibeli', _positionSizeCoins.toStringAsFixed(4), Colors.indigo),
                    const Divider(height: 24),
                    _buildResultRow('Total Uang untuk Transaksi Ini', '\$${_totalInvestment.toStringAsFixed(2)}', Colors.green),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget pembantu untuk merapikan baris hasil
  Widget _buildResultRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500)),
        ),
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: valueColor)),
      ],
    );
  }
}