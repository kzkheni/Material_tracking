import 'package:hive/hive.dart';

part 'material_usage.g.dart';

@HiveType(typeId: 2)
class MaterialUsage {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String materialId;
  
  @HiveField(2)
  final double quantityUsed;
  
  @HiveField(3)
  final DateTime timestamp;
  
  @HiveField(4)
  final String operatorId;
  
  @HiveField(5)
  final String operationId;
  
  @HiveField(6)
  final double totalCost;

  MaterialUsage({
    required this.id,
    required this.materialId,
    required this.quantityUsed,
    required this.timestamp,
    required this.operatorId,
    required this.operationId,
    required this.totalCost,
  });
} 