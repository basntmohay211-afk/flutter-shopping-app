// ============================================================
// Part 1 - super.key
//
// Q: What does super.key do? Where does the key go?
// A: `super.key` is a shortcut for `Key? key` + `: super(key: key)`.
//    It takes the optional `key` argument from the constructor and passes it
//    up to the parent class (StatefulWidget -> Widget). The key ends up
//    stored in the Widget itself, and Flutter uses it when it compares the
//    old widget with the new widget in the element tree to decide whether
//    an existing Element/State can be reused or must be replaced.
//
// Q: Difference between the Key? key (super.key) and GlobalKey<FormState> (_keyForm)?
// A: - `Key? key` identifies the WIDGET inside the widget tree. It is passed
//      to the parent class constructor and only helps Flutter match
//      widgets/states when the tree is rebuilt or reordered (like in lists).
//    - `GlobalKey<FormState> _keyForm` is a key that I create and keep inside
//      my State. It is unique across the whole app, and it lets me reach the
//      FormState from outside the Form widget, for example
//      `_keyForm.currentState!.validate()`.
//    So one is for Flutter (identity), the other is for me (access to the
//    Form's state).
//
// ------------------------------------------------------------
// Part 2 - const
//
// Q: Why does const make Flutter faster?
// A: A `const` widget is created once at compile time and the same object is
//    reused everywhere. When a parent rebuilds, Flutter sees the child is the
//    exact same (identical) instance, so it skips rebuilding that whole
//    subtree. Fewer widget objects are created and fewer builds happen, so
//    less work on every rebuild and less garbage to collect.
//    (const can't be used when the value is only known at runtime, e.g.
//    Text(username) or a TextFormField that uses a controller.)
//
// ------------------------------------------------------------
// Part 3 - private State
//
// Q: What does the _ do in Dart, and why should State classes be private?
// A: In Dart a name that starts with `_` is private to its library (the
//    file). Nothing outside this file can see or use it. (Dart has no
//    `private` keyword.) State classes should be private because only the
//    widget class in the same file ever needs to create them (through
//    createState()). Making them private stops other files from creating
//    or touching the State and its fields/methods, which keeps the
//    internal logic encapsulated and prevents bugs.
// ============================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'test.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  final _keyForm = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _inputCheck() {
    if (_keyForm.currentState!.validate()) {
      final username = _usernameController.text;
      final password = _passwordController.text;
      if (username == Database.username && password == Database.password) {
        Database.isLoggedIn = true;
        context.go("/home");
      } else {
        _usernameController.clear();
        _passwordController.clear();
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Wrong info")));
      }
    }
  }

  @override
  void initState() {
    print(" start Login");
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    print(" finish Login");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _keyForm,
          child: Column(
            children: [
              TextFormField(
                controller: _usernameController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "please enter valid username ";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                validator: (value) {
                  if (((value?.length) ?? 0) < 6) {
                    return "please enter valid password";
                  }
                  return null;
                },
                obscureText: true,
              ),
              ElevatedButton(
                onPressed: _inputCheck,
                child: const Text("go to home "),
              ),
              TextButton(
                onPressed: () {
                  // push: Signup is placed ON TOP of Login in the stack,
                  // so context.pop() in Signup can return to Login.
                  context.push("/signup");
                },
                child: const Text("Don't have an account? Sign up"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}