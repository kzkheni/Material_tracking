import 'package:hive/hive.dart';

part 'material.g.dart';

@HiveType(typeId: 0)
class MaterialItem {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final double unitCost;
  
  @HiveField(3)
  final String unitType;
  
  @HiveField(4)
  final double currentStock;
  
  @HiveField(5)
  final double minimumStockLevel;

  MaterialItem({
    required this.id,
    required this.name,
    required this.unitCost,
    required this.unitType,
    required this.currentStock,
    required this.minimumStockLevel,
  });
} 