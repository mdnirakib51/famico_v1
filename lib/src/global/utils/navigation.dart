
import 'package:flutter/material.dart';

/// Navigate to a screen using Widget
void navigateTo(BuildContext context, Widget screen) {
  Navigator.of(context).push(
    MaterialPageRoute(builder: (context) => screen),
  );
}

/// Navigate to a named route
void navigateToNamed(BuildContext context, String routeName) {
  Navigator.of(context).pushNamed(routeName);
}

/// Navigate and replace current screen
void navigateAndReplace(BuildContext context, Widget screen) {
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (context) => screen),
  );
}

/// Navigate to named route and replace current screen
void navigateAndReplaceNamed(BuildContext context, String routeName) {
  Navigator.of(context).pushReplacementNamed(routeName);
}

/// Navigate and remove all previous screens (Clear stack)
void navigateAndRemoveAll(BuildContext context, Widget screen) {
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (context) => screen),
        (route) => false,
  );
}

/// Navigate to named route and remove all previous screens
void navigateAndRemoveAllNamed(BuildContext context, String routeName) {
  Navigator.of(context).pushNamedAndRemoveUntil(
    routeName,
        (route) => false,
  );
}

/// Navigate and remove until a specific route
void navigateAndRemoveUntil(
    BuildContext context,
    Widget screen,
    String untilRouteName,
    ) {
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (context) => screen),
    ModalRoute.withName(untilRouteName),
  );
}

/// Go back to previous screen
void goBack(BuildContext context) {
  if (Navigator.of(context).canPop()) {
    Navigator.of(context).pop();
  }
}

/// Go back with result
void goBackWithResult<T>(BuildContext context, T result) {
  if (Navigator.of(context).canPop()) {
    Navigator.of(context).pop(result);
  }
}

/// Check if can go back
bool canGoBack(BuildContext context) {
  return Navigator.of(context).canPop();
}

/// Pop until a specific route
void popUntilRoute(BuildContext context, String routeName) {
  Navigator.of(context).popUntil(ModalRoute.withName(routeName));
}

/// Pop until first route (go to root)
void popToRoot(BuildContext context) {
  Navigator.of(context).popUntil((route) => route.isFirst);
}
