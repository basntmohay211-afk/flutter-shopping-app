import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'test.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    print(" start Home");
    super.initState();
  }

  @override
  void dispose() {
    print(" finish Home");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const Text("welcome to Home Page"),
            // Part 5.4 - the hidden bug:
            // Login reaches Home with context.go("/home"), which REPLACES the
            // stack, so Home is the only page in it. The old button called
            // context.pop(), which tried to remove the last page and left
            // nothing to show, so go_router throws an error
            // ("You have popped the last page off of the stack").
            // Fix: make it a Logout button. It resets the login flag and uses
            // go() to move to Login, because there is no page below Home to
            // pop back to.
            ElevatedButton(
              onPressed: () {
                Database.isLoggedIn = false;
                context.go("/login");
              },
              child: const Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}