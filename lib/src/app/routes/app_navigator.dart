import 'package:flutter/material.dart';
import '../../global/utils/navigation.dart';
import 'app_route.dart';

/// All navigation methods using existing navigation functions
/// Always use AppRouteKeys for route names
class AppNavigator {
  AppNavigator._();

  // ==================== Push ====================

  /// Push new screen
  /// Example: AppNavigator.push(context, AppRouteKeys.login)
  static void push(BuildContext context, String routeName) {
    navigateToNamed(context, routeName);
  }

  /// Push and replace current screen
  /// Example: AppNavigator.pushReplace(context, AppRouteKeys.home)
  static void pushReplace(BuildContext context, String routeName) {
    navigateAndReplaceNamed(context, routeName);
  }

  /// Push and remove ALL previous screens
  /// Example: AppNavigator.pushAndRemoveAll(context, AppRouteKeys.home)
  static void pushAndRemoveAll(BuildContext context, String routeName) {
    navigateAndRemoveAllNamed(context, routeName);
  }

  /// Push and remove until a specific route
  /// Example: AppNavigator.pushAndRemoveUntil(context, LoginScreen(), AppRouteKeys.home)
  static void pushAndRemoveUntil(
      BuildContext context,
      Widget screen,
      String untilRouteName,
      ) {
    navigateAndRemoveUntil(context, screen, untilRouteName);
  }

  // ==================== Pop ====================

  /// Go back to previous screen
  /// Example: AppNavigator.pop(context)
  static void pop(BuildContext context) {
    goBack(context);
  }

  /// Go back with result
  /// Example: AppNavigator.popWithResult(context, 'myResult')
  static void popWithResult<T>(BuildContext context, T result) {
    goBackWithResult(context, result);
  }

  /// Pop until a specific route
  /// Example: AppNavigator.popUntilNamed(context, AppRouteKeys.home)
  static void popUntilNamed(BuildContext context, String routeName) {
    popUntilRoute(context, routeName);
  }

  /// Pop to root (first screen)
  /// Example: AppNavigator.toRoot(context)
  static void toRoot(BuildContext context) {
    popToRoot(context);
  }

  // ==================== Check ====================

  /// Check if can go back
  static bool canPop(BuildContext context) {
    return canGoBack(context);
  }

  // ==================== Shortcuts ====================

  /// Go to Login and clear stack
  static void goToLogin(BuildContext context) {
    navigateAndRemoveAllNamed(context, AppRouteKeys.login);
  }

  /// Go to Home and clear stack
  static void goToHome(BuildContext context) {
    navigateAndRemoveAllNamed(context, AppRouteKeys.home);
  }

  /// Go to OnBoarding and clear stack
  static void goToOnBoarding(BuildContext context) {
    navigateAndRemoveAllNamed(context, AppRouteKeys.onBoarding);
  }
}