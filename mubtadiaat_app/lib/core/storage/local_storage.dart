import 'package:hive_flutter/hive_flutter.dart';

abstract class LocalStorage {
  Future<void> init();
  Future<void> saveString(String key, String value);
  String? getString(String key);
  Future<void> remove(String key);
  Future<void> clearAll();
}

class LocalStorageImpl implements LocalStorage {
  static const String boxName = 'app_cache';

  @override
  Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(boxName);
  }

  @override
  Future<void> saveString(String key, String value) async {
    final box = Hive.box(boxName);
    await box.put(key, value);
  }

  @override
  String? getString(String key) {
    final box = Hive.box(boxName);
    return box.get(key) as String?;
  }

  @override
  Future<void> remove(String key) async {
    final box = Hive.box(boxName);
    await box.delete(key);
  }

  @override
  Future<void> clearAll() async {
    final box = Hive.box(boxName);
    await box.clear();
  }
}
