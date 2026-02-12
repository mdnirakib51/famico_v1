
import 'package:get_it/get_it.dart';

import 'domain/local/preferences/local_storage.dart';
import 'domain/service/http_client.dart';
import 'global/utils/device_info.dart';

final locator = GetIt.instance;

Future<void> init() async {
  // Initialize LocalStorage
  LocalStorage localStorage = LocalStorage();
  await localStorage.initLocalStorage();

  // Register dependencies with GetIt
  locator.registerLazySingleton<LocalStorage>(() => localStorage);
  // locator.registerLazySingleton<RequestHandler>(() => RequestHandler(dio: Dio()));

  // Initialize App URL
  AppUrlExtention.initializeUrl(defaultUrlLink: UrlLink.isDev);

  // Get Device Info
  await GetDeviceInfo.getDeviceInfo();
}