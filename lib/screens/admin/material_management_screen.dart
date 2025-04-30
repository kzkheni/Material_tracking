import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../providers/app_state.dart';
import '../../models/material.dart';

class MaterialManagementScreen extends StatefulWidget {
  const MaterialManagementScreen({super.key});

  @override
  State<MaterialManagementScreen> createState() => _MaterialManagementScreenState();
}

class _MaterialManagementScreenState extends State<MaterialManagementScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _unitCostController = TextEditingController();
  final _unitTypeController = TextEditingController();
  final _currentStockController = TextEditingController();
  final _minimumStockController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _unitCostController.dispose();
    _unitTypeController.dispose();
    _currentStockController.dispose();
    _minimumStockController.dispose();
    super.dispose();
  }

  Future<void> _addMaterial() async {
    if (!_formKey.currentState!.validate()) return;

    final material = Material(
      id: const Uuid().v4(),
      name: _nameController.text,
      unitCost: double.parse(_unitCostController.text),
      unitType: _unitTypeController.text,
      currentStock: double.parse(_currentStockController.text),
      minimumStockLevel: double.parse(_minimumStockController.text),
    );

    await context.read<AppState>().addMaterial(material);

    // Clear form
    _nameController.clear();
    _unitCostController.clear();
    _unitTypeController.clear();
    _currentStockController.clear();
    _minimumStockController.clear();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Material added successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Material Management'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Material Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter material name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _unitCostController,
                    decoration: const InputDecoration(
                      labelText: 'Unit Cost',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter unit cost';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _unitTypeController,
                    decoration: const InputDecoration(
                      labelText: 'Unit Type (e.g., kg, pcs)',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter unit type';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _currentStockController,
                    decoration: const InputDecoration(
                      labelText: 'Current Stock',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter current stock';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _minimumStockController,
                    decoration: const InputDecoration(
                      labelText: 'Minimum Stock Level',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter minimum stock level';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _addMaterial,
                    child: const Text('Add Material'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Existing Materials',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Consumer<AppState>(
              builder: (context, appState, child) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: appState.materials.length,
                  itemBuilder: (context, index) {
                    final material = appState.materials[index];
                    return Card(
                      child: ListTile(
                        title: Text(material.name),
                        subtitle: Text(
                          'Stock: ${material.currentStock} ${material.unitType}\n'
                          'Unit Cost: \$${material.unitCost}',
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            // Implement delete functionality
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
} 