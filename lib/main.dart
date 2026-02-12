
import 'package:flutter/cupertino.dart';
import 'src/app.dart';
import 'src/initializer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(const MyApp());
}
