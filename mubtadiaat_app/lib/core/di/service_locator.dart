import 'package:get_it/get_it.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../storage/secure_storage.dart';
import '../storage/local_storage.dart';
import '../network/api_interceptor.dart';
import '../network/api_client.dart';
import '../network/network_info.dart';

final sl = GetIt.instance;

Future<void> initServiceLocator() async {
  // External
  sl.registerLazySingleton(() => const FlutterSecureStorage());
  
  // Storage
  sl.registerLazySingleton<SecureStorage>(() => SecureStorageImpl(sl()));
  sl.registerLazySingleton<LocalStorage>(() => LocalStorageImpl());

  // Network
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());
  sl.registerLazySingleton(() => ApiInterceptor(sl()));
  sl.registerLazySingleton(() => ApiClient(sl()));
  
  // Repositories & Use Cases will be registered here later...
}
