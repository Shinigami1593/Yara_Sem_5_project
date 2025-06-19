import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:yatra_app/app/constant/hive_table_constant.dart';
import 'package:yatra_app/feature/auth/data/model/auth_hive_model.dart';

class HiveService {
  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);

    Hive.registerAdapter(UserHiveModelAdapter());
  }

  // USER (Auth)
  Future<void> register(UserHiveModel user) async {
    final box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    await box.put(user.userId, user);
  }

  Future<List<UserHiveModel>> getAllUsers() async {
    final box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    return box.values.toList();
  }

  Future<void> deleteUser(String userId) async {
    final box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    await box.delete(userId);
  }

  Future<UserHiveModel?> login(String email, String password) async {
    final box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    final user = box.values.firstWhere(
      (u) => u.email == email && u.password == password,
      orElse: () => throw Exception('Invalid email or password'),
    );
    return user;
  }

  Future<UserHiveModel?> getCurrentUser() async {
    final box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    return box.values.isNotEmpty ? box.values.first : null;
  }

  Future<void> clearAll() async {
    await Hive.deleteFromDisk();
    await Hive.deleteBoxFromDisk(HiveTableConstant.userBox);
  }

  Future<void> close() async {
    await Hive.close();
  }
}
