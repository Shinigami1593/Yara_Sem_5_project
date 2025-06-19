import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

part 'auth_hive_model.g.dart';

@HiveType(typeId: 0) // You can replace 0 with your own HiveTableConstant if used
class UserHiveModel extends Equatable {
  @HiveField(0)
  final String userId;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String password;

  UserHiveModel({
    String? userId,
    required this.name,
    required this.email,
    required this.password,
  }) : userId = userId ?? const Uuid().v4();

  // Initial default values
  const UserHiveModel.initial()
      : userId = '',
        name = '',
        email = '',
        password = '';

  @override
  List<Object?> get props => [userId, name, email, password];
}
