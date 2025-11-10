import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/shared_prefs_helper.dart';

class SettingsScreen extends StatefulWidget {
  final Function(bool) onThemeChanged;
  const SettingsScreen({required this.onThemeChanged, Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDark = SharedPrefsHelper.getTheme();
  String _currency = SharedPrefsHelper.getCurrency();
  String _rateText = '';

  final List<String> _currencies = ['CAD', 'USD', 'EUR', 'INR'];

  Future<void> _toggleTheme(bool val) async {
    setState(() => _isDark = val);
    await SharedPrefsHelper.setTheme(val);
    widget.onThemeChanged(val);
  }

  Future<void> _changeCurrency(String newCode) async {
    setState(() => _currency = newCode);
    await SharedPrefsHelper.setCurrency(newCode);
  }

  Future<void> _fetchExchangeRate() async {
    setState(() => _rateText = 'Loading...');
    try {
      final uri = Uri.parse('https://api.exchangerate-api.com/v4/latest/USD');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final rates = data['rates'] as Map<String, dynamic>;
        final rate = rates[_currency];
        setState(() => _rateText = '1 USD = $rate $_currency');
      } else {
        setState(() => _rateText = 'API error: ${response.statusCode}');
      }
    } catch (e) {
      setState(() => _rateText = 'Error fetching rate');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                const Text('Dark Theme'),
                const SizedBox(width: 12),
                Switch(value: _isDark, onChanged: _toggleTheme),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Currency'),
                const SizedBox(width: 12),
                DropdownButton<String>(
                  value: _currency,
                  items: _currencies.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (val) {
                    if (val != null) _changeCurrency(val);
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton(
                onPressed: _fetchExchangeRate,
                child: const Text('Fetch USD → selected currency rate')),
            const SizedBox(height: 8),
            Text(_rateText),
          ],
        ),
      ),
    );
  }
}
