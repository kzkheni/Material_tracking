import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/app_state.dart';
import '../../models/material.dart';
import '../../models/material_usage.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  DateTime _selectedDate = DateTime.now();
  Material? _selectedMaterial;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _selectDate(context),
                    child: Text(
                      DateFormat('MMM d, yyyy').format(_selectedDate),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Consumer<AppState>(
                    builder: (context, appState, child) {
                      return DropdownButtonFormField<Material>(
                        decoration: const InputDecoration(
                          labelText: 'Filter by Material',
                          border: OutlineInputBorder(),
                        ),
                        value: _selectedMaterial,
                        items: [
                          const DropdownMenuItem(
                            value: null,
                            child: Text('All Materials'),
                          ),
                          ...appState.materials.map((material) {
                            return DropdownMenuItem(
                              value: material,
                              child: Text(material.name),
                            );
                          }).toList(),
                        ],
                        onChanged: (material) {
                          setState(() {
                            _selectedMaterial = material;
                          });
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Consumer<AppState>(
              builder: (context, appState, child) {
                final usageHistory = appState.getMaterialUsageByDate(_selectedDate);
                final filteredUsage = _selectedMaterial != null
                    ? usageHistory.where((usage) => usage.materialId == _selectedMaterial!.id).toList()
                    : usageHistory;

                if (filteredUsage.isEmpty) {
                  return const Center(
                    child: Text('No usage data for selected date'),
                  );
                }

                double totalCost = 0;
                for (var usage in filteredUsage) {
                  totalCost += usage.totalCost;
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Daily Summary',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text('Total Materials Used: ${filteredUsage.length}'),
                            Text('Total Cost: \$${totalCost.toStringAsFixed(2)}'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Usage Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredUsage.length,
                      itemBuilder: (context, index) {
                        final usage = filteredUsage[index];
                        final material = appState.materials.firstWhere(
                          (m) => m.id == usage.materialId,
                        );
                        return Card(
                          child: ListTile(
                            title: Text(material.name),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Quantity: ${usage.quantityUsed} ${material.unitType}'),
                                Text('Cost: \$${usage.totalCost.toStringAsFixed(2)}'),
                                Text(
                                  'Time: ${DateFormat('HH:mm').format(usage.timestamp)}',
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
} 