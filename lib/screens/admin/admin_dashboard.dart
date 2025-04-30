import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import 'material_management_screen.dart';
import 'user_management_screen.dart';
import 'analytics_screen.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AppState>().logout();
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        children: [
          _DashboardCard(
            title: 'Material Management',
            icon: Icons.inventory,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MaterialManagementScreen(),
              ),
            ),
          ),
          _DashboardCard(
            title: 'User Management',
            icon: Icons.people,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const UserManagementScreen(),
              ),
            ),
          ),
          _DashboardCard(
            title: 'Analytics',
            icon: Icons.analytics,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AnalyticsScreen(),
              ),
            ),
          ),
          _DashboardCard(
            title: 'Low Stock Alerts',
            icon: Icons.warning,
            onTap: () {
              final lowStockMaterials = context.read<AppState>().getLowStockMaterials();
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Low Stock Alerts'),
                  content: lowStockMaterials.isEmpty
                      ? const Text('No materials are low on stock')
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: lowStockMaterials
                              .map((material) => ListTile(
                                    title: Text(material.name),
                                    subtitle: Text(
                                        'Current: ${material.currentStock} ${material.unitType}'),
                                  ))
                              .toList(),
                        ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
} 