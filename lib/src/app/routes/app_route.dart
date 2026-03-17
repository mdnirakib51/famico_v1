
import 'package:flutter/material.dart';
import '../../features/auth/login/view/login_screen.dart';
import '../../features/auth/registration/view/registration_screen.dart';
import '../../features/on_boarding_screen/view/on_boarding_screen.dart';
import '../../features/splash_screen/view/splash_screen.dart';
import '../../global/utils/navigation.dart';

/// All route name constants in one place
/// Usage: AppRouteKeys.login, AppRouteKeys.home, etc.
class AppRouteKeys {
  AppRouteKeys._();

  // ==================== Auth ====================
  static const String splash       = '/';
  static const String onBoarding   = '/on-boarding';
  static const String login        = '/login';
  static const String registration = '/registration';
  static const String forgotPass   = '/forgot-password';
  static const String resetPass    = '/reset-password';
  static const String otp          = '/otp';

  // ==================== Main ====================
  static const String home         = '/home';
  static const String notification = '/notification';
  static const String settings     = '/settings';

  // ==================== Profile ====================
  static const String profile      = '/profile';
  static const String editProfile  = '/edit-profile';

// Add more routes here...
}

class AppRouteGenerator {
  AppRouteGenerator._();
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {

    // ==@/~/@==> Auth <==@/~/@==
      case AppRouteKeys.splash: return _route(const SplashScreen(), settings);
      case AppRouteKeys.onBoarding: return _route(const OnBoardingScreen(), settings);
      case AppRouteKeys.login: return _route(const LoginScreen(), settings);
      case AppRouteKeys.registration: return _route(const RegistrationScreen(), settings);

    // ==@/~/@==> Home <==@/~/@==
      default: return _route(const _NotFoundScreen(), settings);
    }
  }

  static MaterialPageRoute _route(Widget screen, RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => screen,
      settings: settings,
    );
  }
}

// ── 404 Screen ──────────────────────────────────
class _NotFoundScreen extends StatelessWidget {
  const _NotFoundScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              '404 - Page Not Found',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => navigateAndRemoveAllNamed(context, AppRouteKeys.home),
              child: const Text('Go to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
