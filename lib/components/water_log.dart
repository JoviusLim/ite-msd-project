import 'package:flutter/material.dart';
import '../utils/database_helper.dart';

class WaterLogPage extends StatefulWidget {
  const WaterLogPage({super.key});

  @override
  State<WaterLogPage> createState() => _WaterLogPageState();
}

class _WaterLogPageState extends State<WaterLogPage> {
  int _totalWater = 0;
  final List<int> _presetAmounts = [100, 200, 300, 500]; // in ml
  final TextEditingController _customAmountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTotalWater();
  }

  Future<void> _loadTotalWater() async {
    final total = await DatabaseHelper.instance
        .getTotalWaterIntakeForDate(DateTime.now());
    setState(() {
      _totalWater = total;
    });
  }

  Future<void> _addWaterIntake(int amount) async {
    await DatabaseHelper.instance.addWaterIntake(amount);
    await _loadTotalWater();
  }

  void _showCustomAmountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Enter custom amount'),
        content: TextField(
          controller: _customAmountController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Amount (ml)',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final amount = int.tryParse(_customAmountController.text);
              if (amount != null && amount > 0) {
                _addWaterIntake(amount);
                Navigator.pop(context);
                _customAmountController.clear();
              }
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Water Intake Log'),
      ),
      body: Column(
        children: [
          // Water Progress Card
          Card(
            margin: EdgeInsets.all(16),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Icon(
                    Icons.water_drop,
                    size: 48,
                    color: Colors.blue,
                  ),
                  SizedBox(height: 16),
                  Text(
                    '${_totalWater}ml',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text('Today\'s water intake'),
                ],
              ),
            ),
          ),

          // Quick Add Buttons
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Quick Add',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _presetAmounts.map((amount) {
                    return ElevatedButton(
                      onPressed: () => _addWaterIntake(amount),
                      child: Text('$amount ml'),
                    );
                  }).toList(),
                ),
                SizedBox(height: 16),
                OutlinedButton(
                  onPressed: _showCustomAmountDialog,
                  child: Text('Custom Amount'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _customAmountController.dispose();
    super.dispose();
  }
}
