import 'package:get_storage/get_storage.dart';

class SkiiveLocalStorage {
  static final SkiiveLocalStorage _instance = SkiiveLocalStorage._internal();

  factory SkiiveLocalStorage() {
    return _instance;
  }

  SkiiveLocalStorage._internal();

  final _storage = GetStorage();

  // GEneric method to save data
  Future<void> saveData<Skiive>(String key, Skiive value) async {
    await _storage.write(key, value);
  }

  // Generic method to read data
  Skiive? readData<Skiive>(String key) {
    return _storage.read<Skiive>(key);
  }

  // Generic method to remove data
  Future<void> removeData(String key) async {
    await _storage.remove(key);
  }

  // Clear all data in storage
  Future<void> clearAll() async {
    await _storage.erase();
  }
}
