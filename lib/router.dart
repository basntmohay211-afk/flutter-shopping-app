import 'package:go_router/go_router.dart';
import 'login_page.dart';
import 'home_page.dart';
import 'products_page.dart';
import 'signup_page.dart';
import 'test.dart';

// ============================================================
// Part 5.1 - Why is /signup a top-level route and NOT under /home?
// The redirect below blocks every path that starts with "/home" while the
// user is not logged in. Signup is used by someone who is NOT logged in yet.
// If it were "/home/signup", the redirect would send the user to /login
// and he could never reach the Signup page. So it must be outside /home.
//
// ------------------------------------------------------------
// Part 5.3 - Experiment: go vs push
//
// Test 1: push("/signup") then pop()
//   Works. Signup is placed on top of Login; pop() removes it and Login is
//   shown again, with the same State (the text typed in it is still there).
//
// Test 2: go("/signup") then pop()
//   Error. go() replaced the stack, so Signup is the only page. pop() has no
//   page to go back to and go_router throws an error in the console
//   ("You have popped the last page off of the stack, there are no pages
//   left to show").
//
// Test 3: go("/signup") then go("/login")
//   Works, but Login is built from scratch: "start Login" is printed again
//   and the fields are empty, because the old Login was destroyed when go()
//   replaced the stack and Signup is disposed when going back.
//
// Test 4: push("/signup") then the phone/AppBar back arrow
//   Works exactly like pop(). The AppBar shows the back arrow automatically
//   because there is a page below Signup in the stack, and it returns to
//   Login.
//
// Is Login disposed?
//   - With push: NO. Login stays alive under Signup ("finish Login" is not
//     printed when Signup opens).
//   - With go: YES. Login is removed from the stack, so dispose() runs and
//     "finish Login" is printed.
//
// ------------------------------------------------------------
// go vs push (in my own words, using "stack"):
// The navigation stack is the pile of pages. push() puts a new page on top
// of the stack and keeps the old pages under it, so pop() can take the top
// page off and go back to the one below. go() throws the current stack away
// and builds a new stack for the target location, so there is nothing below
// to go back to, and the old pages are disposed.
// ============================================================

final router = GoRouter(
  initialLocation: "/login",
  redirect: (context, state) {
    var path = state.matchedLocation;
    if (path.startsWith("/home") && !Database.isLoggedIn) {
      return "/login";
    }
    return null;
  },
  routes: [
    GoRoute(path: "/login", builder: (context, state) => const LoginPage()),
    GoRoute(path: "/signup", builder: (context, state) => const SignupPage()),
    GoRoute(
      path: "/home",
      builder: (context, state) => const HomePage(),
      routes: [
        GoRoute(
          path: 'products',
          builder: (context, state) => const ProductsPage(),
        ),
      ],
    ),
  ],
);