import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/user.dart';
import '../models/material.dart';
import '../models/operation.dart';
import 'material_management_screen.dart';
import 'material_usage_screen.dart';

class DashboardScreen extends StatelessWidget {
  final User currentUser;

  const DashboardScreen({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      floatingActionButton: currentUser.role == 'admin'
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const MaterialManagementScreen(),
                  ),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,
      body: currentUser.role == 'admin' ? _buildAdminDashboard() : _buildOperatorDashboard(),
    );
  }

  Widget _buildAdminDashboard() {
    return ValueListenableBuilder(
      valueListenable: Hive.box<MaterialItem>('materials').listenable(),
      builder: (context, box, _) {
        final materials = box.values.toList();
        return ValueListenableBuilder(
          valueListenable: Hive.box<Operation>('operations').listenable(),
          builder: (context, operationsBox, _) {
            final operations = operationsBox.values.toList();
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Materials Overview'),
                  _buildMaterialsGrid(materials),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Operations Overview'),
                  _buildOperationsList(operations),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Low Stock Alerts'),
                  _buildLowStockAlerts(materials),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildOperatorDashboard() {
    return ValueListenableBuilder(
      valueListenable: Hive.box<Operation>('operations').listenable(),
      builder: (context, box, _) {
        final allOperations = box.values.toList();
        final assignedOperations = allOperations.where((op) => 
          currentUser.assignedOperations.contains(op.id)).toList();
        
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Your Assigned Operations'),
              _buildOperationsList(assignedOperations),
              const SizedBox(height: 24),
              _buildSectionTitle('Quick Actions'),
              QuickActions(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildMaterialsGrid(List<MaterialItem> materials) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: materials.length,
      itemBuilder: (context, index) {
        final material = materials[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  material.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text('Stock: ${material.currentStock} ${material.unitType}'),
                Text('Min Level: ${material.minimumStockLevel} ${material.unitType}'),
                Text('Unit Cost: \$${material.unitCost.toStringAsFixed(2)}'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOperationsList(List<Operation> operations) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: operations.length,
      itemBuilder: (context, index) {
        final operation = operations[index];
        return Card(
          child: ListTile(
            title: Text(operation.name),
            subtitle: Text('ID: ${operation.id}'),
            trailing: Text(
              '\$${operation.totalProcessingCost.toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            onTap: currentUser.role == 'operator'
                ? () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => MaterialUsageScreen(operation: operation),
                      ),
                    );
                  }
                : null,
          ),
        );
      },
    );
  }

  Widget _buildLowStockAlerts(List<MaterialItem> materials) {
    final lowStockMaterials = materials.where((m) => 
      m.currentStock <= m.minimumStockLevel).toList();
    
    if (lowStockMaterials.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('No low stock alerts'),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: lowStockMaterials.length,
      itemBuilder: (context, index) {
        final material = lowStockMaterials[index];
        return Card(
          color: Colors.red.shade100,
          child: ListTile(
            title: Text(material.name),
            subtitle: Text('Current Stock: ${material.currentStock} ${material.unitType}'),
            trailing: Text(
              'Min: ${material.minimumStockLevel} ${material.unitType}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ),
        );
      },
    );
  }
}

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildQuickActionButton(
          context: context,
          icon: Icons.qr_code_scanner,
          label: 'Scan Material',
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('QR scanning feature coming soon')),
            );
          },
        ),
        _buildQuickActionButton(
          context: context,
          icon: Icons.add_circle_outline,
          label: 'Log Usage',
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Select an operation to log usage')),
            );
          },
        ),
      ],
    );
  }

  Widget _buildQuickActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(icon, size: 40),
          onPressed: onPressed,
        ),
        Text(label),
      ],
    );
  }
} 