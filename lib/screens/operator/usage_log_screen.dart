import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../providers/app_state.dart';
import '../../models/material.dart';
import '../../models/material_usage.dart';

class UsageLogScreen extends StatefulWidget {
  const UsageLogScreen({super.key});

  @override
  State<UsageLogScreen> createState() => _UsageLogScreenState();
}

class _UsageLogScreenState extends State<UsageLogScreen> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  final _operationController = TextEditingController();
  Material? _selectedMaterial;

  @override
  void dispose() {
    _quantityController.dispose();
    _operationController.dispose();
    super.dispose();
  }

  Future<void> _logUsage() async {
    if (!_formKey.currentState!.validate() || _selectedMaterial == null) return;

    final user = context.read<AppState>().currentUser;
    if (user == null) return;

    final usage = MaterialUsage(
      id: const Uuid().v4(),
      materialId: _selectedMaterial!.id,
      quantityUsed: double.parse(_quantityController.text),
      timestamp: DateTime.now(),
      operatorId: user.id,
      operationId: _operationController.text,
      totalCost: _selectedMaterial!.unitCost * double.parse(_quantityController.text),
    );

    await context.read<AppState>().recordMaterialUsage(usage);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usage logged successfully')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log Material Usage'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Consumer<AppState>(
                builder: (context, appState, child) {
                  return DropdownButtonFormField<Material>(
                    decoration: const InputDecoration(
                      labelText: 'Select Material',
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedMaterial,
                    items: appState.materials.map((material) {
                      return DropdownMenuItem(
                        value: material,
                        child: Text(material.name),
                      );
                    }).toList(),
                    onChanged: (material) {
                      setState(() {
                        _selectedMaterial = material;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a material';
                      }
                      return null;
                    },
                  );
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(
                  labelText: 'Quantity Used',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter quantity';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  if (_selectedMaterial != null &&
                      double.parse(value) > _selectedMaterial!.currentStock) {
                    return 'Quantity exceeds available stock';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _operationController,
                decoration: const InputDecoration(
                  labelText: 'Operation ID',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter operation ID';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              if (_selectedMaterial != null) ...[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Cost Calculation',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text('Unit Cost: \$${_selectedMaterial!.unitCost}'),
                        if (_quantityController.text.isNotEmpty)
                          Text(
                            'Total Cost: \$${_selectedMaterial!.unitCost * double.tryParse(_quantityController.text) ?? 0}',
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              ElevatedButton(
                onPressed: _logUsage,
                child: const Text('Log Usage'),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 