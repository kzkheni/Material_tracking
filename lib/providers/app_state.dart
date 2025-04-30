import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/material.dart';
import '../models/user.dart';
import '../models/material_usage.dart';
import '../models/operation.dart';

class AppState with ChangeNotifier {
  late Box<Material> _materialsBox;
  late Box<User> _usersBox;
  late Box<MaterialUsage> _usageBox;
  late Box<Operation> _operationsBox;
  
  User? _currentUser;
  List<Material> _materials = [];
  List<User> _users = [];
  List<MaterialUsage> _usageHistory = [];
  List<Operation> _operations = [];

  User? get currentUser => _currentUser;
  List<Material> get materials => _materials;
  List<User> get users => _users;
  List<MaterialUsage> get usageHistory => _usageHistory;
  List<Operation> get operations => _operations;

  Future<void> initialize() async {
    _materialsBox = await Hive.openBox<Material>('materials');
    _usersBox = await Hive.openBox<User>('users');
    _usageBox = await Hive.openBox<MaterialUsage>('usage');
    _operationsBox = await Hive.openBox<Operation>('operations');
    
    _loadData();
  }

  void _loadData() {
    _materials = _materialsBox.values.toList();
    _users = _usersBox.values.toList();
    _usageHistory = _usageBox.values.toList();
    _operations = _operationsBox.values.toList();
    notifyListeners();
  }

  Future<void> login(String username, String password) async {
    final user = _users.firstWhere(
      (u) => u.username == username && u.password == password,
      orElse: () => throw Exception('Invalid credentials'),
    );
    _currentUser = user;
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  Future<void> addMaterial(Material material) async {
    await _materialsBox.put(material.id, material);
    _loadData();
  }

  Future<void> addUser(User user) async {
    await _usersBox.put(user.id, user);
    _loadData();
  }

  Future<void> recordMaterialUsage(MaterialUsage usage) async {
    await _usageBox.put(usage.id, usage);
    _loadData();
  }

  Future<void> addOperation(Operation operation) async {
    await _operationsBox.put(operation.id, operation);
    _loadData();
  }

  List<MaterialUsage> getMaterialUsageByDate(DateTime date) {
    return _usageHistory.where((usage) => 
      usage.timestamp.year == date.year &&
      usage.timestamp.month == date.month &&
      usage.timestamp.day == date.day
    ).toList();
  }

  List<Material> getLowStockMaterials() {
    return _materials.where((material) => 
      material.currentStock <= material.minimumStockLevel
    ).toList();
  }
} 