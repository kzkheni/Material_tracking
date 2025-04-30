import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/material.dart';
import '../models/operation.dart';

class MaterialUsageScreen extends StatefulWidget {
  final Operation operation;

  const MaterialUsageScreen({super.key, required this.operation});

  @override
  State<MaterialUsageScreen> createState() => _MaterialUsageScreenState();
}

class _MaterialUsageScreenState extends State<MaterialUsageScreen> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  MaterialItem? _selectedMaterial;

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _logUsage() async {
    if (_formKey.currentState!.validate() && _selectedMaterial != null) {
      final quantity = double.parse(_quantityController.text);
      
      // Update material stock
      final materialsBox = Hive.box<MaterialItem>('materials');
      final materialIndex = materialsBox.values.toList().indexWhere(
        (m) => m.id == _selectedMaterial!.id,
      );
      
      if (materialIndex != -1) {
        final updatedMaterial = MaterialItem(
          id: _selectedMaterial!.id,
          name: _selectedMaterial!.name,
          unitCost: _selectedMaterial!.unitCost,
          unitType: _selectedMaterial!.unitType,
          currentStock: _selectedMaterial!.currentStock - quantity,
          minimumStockLevel: _selectedMaterial!.minimumStockLevel,
        );
        
        await materialsBox.putAt(materialIndex, updatedMaterial);

        if (mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Material usage logged successfully')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Log Usage - ${widget.operation.name}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              ValueListenableBuilder(
                valueListenable: Hive.box<MaterialItem>('materials').listenable(),
                builder: (context, box, _) {
                  final materials = box.values.toList();
                  return DropdownButtonFormField<MaterialItem>(
                    value: _selectedMaterial,
                    decoration: const InputDecoration(
                      labelText: 'Select Material',
                      border: OutlineInputBorder(),
                    ),
                    items: materials.map((material) {
                      return DropdownMenuItem(
                        value: material,
                        child: Text('${material.name} (${material.currentStock} ${material.unitType})'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedMaterial = value;
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
                  if (_selectedMaterial != null) {
                    final quantity = double.parse(value);
                    if (quantity > _selectedMaterial!.currentStock) {
                      return 'Quantity exceeds available stock';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              if (_selectedMaterial != null) ...[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
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
                        Text('Material Cost: \$${_selectedMaterial!.unitCost.toStringAsFixed(2)}'),
                        Text('Processing Cost: \$${widget.operation.totalProcessingCost.toStringAsFixed(2)}'),
                        const Divider(),
                        Text(
                          'Total Cost: \$${(_selectedMaterial!.unitCost + widget.operation.totalProcessingCost).toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
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