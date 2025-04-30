import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import 'material_scan_screen.dart';
import 'usage_log_screen.dart';

class OperatorDashboard extends StatelessWidget {
  const OperatorDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Operator Dashboard'),
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
            title: 'Scan Material',
            icon: Icons.qr_code_scanner,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MaterialScanScreen(),
              ),
            ),
          ),
          _DashboardCard(
            title: 'Log Usage',
            icon: Icons.edit_note,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const UsageLogScreen(),
              ),
            ),
          ),
          _DashboardCard(
            title: 'View Tasks',
            icon: Icons.task,
            onTap: () {
              final user = context.read<AppState>().currentUser;
              if (user != null) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Assigned Operations'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: user.assignedOperations
                          .map((operation) => ListTile(
                                title: Text(operation),
                                onTap: () {
                                  Navigator.pop(context);
                                  // Navigate to operation details
                                },
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
              }
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