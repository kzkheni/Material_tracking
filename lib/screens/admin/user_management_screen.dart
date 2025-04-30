import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../providers/app_state.dart';
import '../../models/user.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _operationController = TextEditingController();
  UserRole _selectedRole = UserRole.operator;
  List<String> _assignedOperations = [];

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _operationController.dispose();
    super.dispose();
  }

  void _addOperation() {
    if (_operationController.text.isNotEmpty) {
      setState(() {
        _assignedOperations.add(_operationController.text);
        _operationController.clear();
      });
    }
  }

  void _removeOperation(String operation) {
    setState(() {
      _assignedOperations.remove(operation);
    });
  }

  Future<void> _addUser() async {
    if (!_formKey.currentState!.validate()) return;

    final user = User(
      id: const Uuid().v4(),
      username: _usernameController.text,
      password: _passwordController.text,
      role: _selectedRole,
      assignedOperations: _assignedOperations,
    );

    await context.read<AppState>().addUser(user);

    // Clear form
    _usernameController.clear();
    _passwordController.clear();
    _operationController.clear();
    _assignedOperations = [];
    _selectedRole = UserRole.operator;

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User added successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Management'),
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
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter username';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<UserRole>(
                    decoration: const InputDecoration(
                      labelText: 'Role',
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedRole,
                    items: UserRole.values.map((role) {
                      return DropdownMenuItem(
                        value: role,
                        child: Text(role.toString().split('.').last),
                      );
                    }).toList(),
                    onChanged: (role) {
                      if (role != null) {
                        setState(() {
                          _selectedRole = role;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _operationController,
                          decoration: const InputDecoration(
                            labelText: 'Operation ID',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: _addOperation,
                        child: const Text('Add'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (_assignedOperations.isNotEmpty) ...[
                    const Text(
                      'Assigned Operations:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: _assignedOperations.map((operation) {
                        return Chip(
                          label: Text(operation),
                          onDeleted: () => _removeOperation(operation),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                  ],
                  ElevatedButton(
                    onPressed: _addUser,
                    child: const Text('Add User'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Existing Users',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Consumer<AppState>(
              builder: (context, appState, child) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: appState.users.length,
                  itemBuilder: (context, index) {
                    final user = appState.users[index];
                    return Card(
                      child: ListTile(
                        title: Text(user.username),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Role: ${user.role.toString().split('.').last}'),
                            if (user.assignedOperations.isNotEmpty)
                              Text(
                                'Operations: ${user.assignedOperations.join(', ')}',
                              ),
                          ],
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