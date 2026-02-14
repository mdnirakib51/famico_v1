
import 'package:get_it/get_it.dart';
import 'core_functionality/constants/app_config.dart';
import 'core_functionality/storage/local_storage.dart';
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
  AppUrlExtention.initializeUrl(defaultUrlLink: ApiBaseUrl.isDev);

  // Get Device Info
  await GetDeviceInfo.getDeviceInfo();
}