import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 1)
class User {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String username;
  
  @HiveField(2)
  final String password;
  
  @HiveField(3)
  final String role;
  
  @HiveField(4)
  final List<String> assignedOperations;

  User({
    required this.id,
    required this.username,
    required this.password,
    required this.role,
    required this.assignedOperations,
  });
} 