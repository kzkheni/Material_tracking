import 'package:hive_flutter/hive_flutter.dart';
import '../models/material.dart';
import '../models/user.dart';
import '../models/operation.dart';
import '../utils/initial_data.dart';

class InitializationService {
  static Future<void> initializeApp() async {
    // Initialize Hive
    await Hive.initFlutter();
    
    // Register adapters
    Hive.registerAdapter(MaterialItemAdapter());
    Hive.registerAdapter(UserAdapter());
    Hive.registerAdapter(OperationAdapter());

    // Open boxes
    await Hive.openBox<MaterialItem>('materials');
    await Hive.openBox<User>('users');
    await Hive.openBox<Operation>('operations');

    // Check if app is already initialized
    final materialsBox = Hive.box<MaterialItem>('materials');
    if (materialsBox.isEmpty) {
      // Add default materials
      for (var material in InitialData.defaultMaterials) {
        await materialsBox.add(material);
      }

      // Add default users
      final usersBox = Hive.box<User>('users');
      for (var user in InitialData.defaultUsers) {
        await usersBox.add(user);
      }

      // Add default operations
      final operationsBox = Hive.box<Operation>('operations');
      for (var operation in InitialData.defaultOperations) {
        await operationsBox.add(operation);
      }
    }
  }
} 