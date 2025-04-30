import 'package:uuid/uuid.dart';
import '../models/material.dart';
import '../models/user.dart';
import '../models/operation.dart';

class InitialData {
  static List<MaterialItem> get defaultMaterials => [
        MaterialItem(
          id: const Uuid().v4(),
          name: 'Steel Sheet',
          unitCost: 25.0,
          unitType: 'kg',
          currentStock: 1000.0,
          minimumStockLevel: 200.0,
        ),
        MaterialItem(
          id: const Uuid().v4(),
          name: 'Aluminum Bar',
          unitCost: 15.0,
          unitType: 'm',
          currentStock: 500.0,
          minimumStockLevel: 100.0,
        ),
        MaterialItem(
          id: const Uuid().v4(),
          name: 'Copper Wire',
          unitCost: 8.0,
          unitType: 'm',
          currentStock: 2000.0,
          minimumStockLevel: 500.0,
        ),
      ];

  static List<User> get defaultUsers => [
        User(
          id: const Uuid().v4(),
          username: 'admin',
          password: 'admin123',
          role: 'admin',
          assignedOperations: [],
        ),
        User(
          id: const Uuid().v4(),
          username: 'operator1',
          password: 'operator123',
          role: 'operator',
          assignedOperations: ['OP001', 'OP002'],
        ),
        User(
          id: const Uuid().v4(),
          username: 'operator2',
          password: 'operator123',
          role: 'operator',
          assignedOperations: ['OP003', 'OP004'],
        ),
      ];

  static List<Operation> get defaultOperations => [
        Operation(
          id: 'OP001',
          name: 'Cutting',
          laborCost: 10.0,
          energyCost: 5.0,
          otherCosts: 2.0,
          desiredMargin: 20.0,
        ),
        Operation(
          id: 'OP002',
          name: 'Welding',
          laborCost: 15.0,
          energyCost: 8.0,
          otherCosts: 3.0,
          desiredMargin: 25.0,
        ),
        Operation(
          id: 'OP003',
          name: 'Polishing',
          laborCost: 8.0,
          energyCost: 3.0,
          otherCosts: 1.0,
          desiredMargin: 15.0,
        ),
        Operation(
          id: 'OP004',
          name: 'Assembly',
          laborCost: 20.0,
          energyCost: 10.0,
          otherCosts: 5.0,
          desiredMargin: 30.0,
        ),
      ];
} 