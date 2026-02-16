
import 'package:get_it/get_it.dart';
import 'core_functionality/constants/app_config.dart';
import 'core_functionality/network/http_client/request_handler.dart';
import 'core_functionality/storage/local_storage.dart';
import 'core_functionality/storage/storage_controller.dart';
import 'features/auth/data/repositories/auth_repo.dart';
import 'global/utils/device_info.dart';

final locator = GetIt.instance;

Future<void> init() async {
  // Initialize LocalStorage FIRST
  LocalStorage localStorage = LocalStorage();
  await localStorage.initLocalStorage();

  // Register LocalStorage BEFORE LocalStorageService tries to use it
  locator.registerLazySingleton<LocalStorage>(() => localStorage);

  // Now initialize LocalStorageService (it can access LocalStorage from GetIt)
  LocalStorageService storageService = await LocalStorageService.getInstance();
  locator.registerLazySingleton<LocalStorageService>(() => storageService);

  // Initialize RequestHandler (it can now access LocalStorageService)
  RequestHandler requestHandler = await RequestHandler.create();
  locator.registerLazySingleton<RequestHandler>(() => requestHandler);

  // // Register AuthRepository
  // locator.registerLazySingleton<AuthRepository>(() => AuthRepository());

  // Initialize App URL
  AppUrlExtension.initializeUrl(defaultUrlLink: ApiBaseUrl.isDev);

  // Get Device Info
  await GetDeviceInfo.getDeviceInfo();
}