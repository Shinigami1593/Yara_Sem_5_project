import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:yatra_app/feature/auth/domain/entity/user_entity.dart';

part 'auth_api_model.g.dart';

@JsonSerializable()
class UserApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? userId;
  final String name;
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String? role;
  final DateTime? createdAt;
  final String? profilePicture;

  const UserApiModel({
    this.userId,
    required this.name,
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    this.role = 'user',
    this.createdAt,
    this.profilePicture
  });

  factory UserApiModel.fromJson(Map<String, dynamic> json) =>
      _$UserApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserApiModelToJson(this);

  /// Factory constructor from full name (used in form logic)
  factory UserApiModel.fromFullName({
    String? userId,
    required String fullName,
    required String email,
    required String password,
    String? role,
    DateTime? createdAt,
    String? profilePicture
  }) {
    List<String> nameParts = fullName.trim().split(' ');
    String first = nameParts.first;
    String last = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
    return UserApiModel(
      userId: userId,
      name: fullName,
      email: email,
      password: password,
      firstName: first,
      lastName: last,
      role: role,
      createdAt: createdAt,
      profilePicture: profilePicture
    );
  }

  // From Entity
  factory UserApiModel.fromEntity(UserEntity entity) {
    return UserApiModel(
      userId: entity.userId,
      name: entity.name,
      email: entity.email,
      password: entity.password,
      firstName: entity.firstName,
      lastName: entity.lastName,
      role: entity.role,
      createdAt: entity.createdAt,
      profilePicture: entity.profilePicture
    );
  }

  // To Entity
  UserEntity toEntity() {
    return UserEntity(
      userId: userId,
      name: name,
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
      role: role,
      createdAt: createdAt,
      profilePicture: profilePicture
    );
  }

  // To Entity List
  static List<UserEntity> toEntityList(List<UserApiModel> entityList) {
    return entityList.map((data) => data.toEntity()).toList();
  }

  // From Entity List
  static List<UserApiModel> fromEntityList(List<UserEntity> entityList) {
    return entityList.map((entity) => UserApiModel.fromEntity(entity)).toList();
  }

  @override
  List<Object?> get props => [userId, name, email, password, firstName, lastName, role, createdAt, profilePicture];
}
