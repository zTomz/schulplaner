import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:schulplaner/config/routes/router.gr.dart';

class AuthGuard extends AutoRouteGuard {
  // FIXME: Not sure why, but when I insert a print call it prints about 40 times when loging in

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    // Check if the user is authenticated
    if (FirebaseAuth.instance.currentUser != null) {
      // if user is authenticated we continue
      resolver.next(true);
    } else {
      // we redirect the user to the intro route
      resolver.next(false);
      resolver.redirect(
        const AuthenticationRoute(),
      );
    }
  }
}

// Only used for the account creation pages
class SignedInCheckGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (FirebaseAuth.instance.currentUser != null) {
      resolver.next(false);
      resolver.redirect(
        const AppNavigationRoute(),
      );
      return;
    } else {
      resolver.next(true);
    }
  }
}
