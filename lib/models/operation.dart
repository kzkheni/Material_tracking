import 'package:hive/hive.dart';

part 'operation.g.dart';

@HiveType(typeId: 3)
class Operation {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final double laborCost;
  
  @HiveField(3)
  final double energyCost;
  
  @HiveField(4)
  final double otherCosts;
  
  @HiveField(5)
  final double desiredMargin;

  Operation({
    required this.id,
    required this.name,
    required this.laborCost,
    required this.energyCost,
    required this.otherCosts,
    required this.desiredMargin,
  });

  double get totalProcessingCost => laborCost + energyCost + otherCosts;
} 