import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'test.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() {
    return _SignupPageState();
  }
}

class _SignupPageState extends State<SignupPage> {
  final _keyForm = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  void _signUp() {
    if (_keyForm.currentState!.validate()) {
      // Fake database: just changing variables.
      Database.username = _usernameController.text.trim();
      Database.password = _passwordController.text;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Account created, please login")),
      );
      context.pop();
    }
    // If invalid, the validators show their error under each field.
  }

  @override
  void initState() {
    print(" start Signup");
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    print(" finish Signup");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _keyForm,
          child: Column(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: "Username"),
                validator: (value) {
                  if (value == null || value.trim().length < 3) {
                    return "Username must be at least 3 characters";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: "Email"),
                validator: (value) {
                  final email = value?.trim() ?? "";
                  if (email.isEmpty ||
                      !email.contains("@") ||
                      !email.contains(".")) {
                    return "Please enter a valid email";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Password"),
                validator: (value) {
                  if ((value?.length ?? 0) < 6) {
                    return "Password must be at least 6 characters";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration:
                const InputDecoration(labelText: "Confirm Password"),
                validator: (value) {
                  if (value != _passwordController.text) {
                    return "Passwords do not match";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _signUp,
                child: const Text("Sign Up"),
              ),
              TextButton(
                onPressed: () {
                  context.pop();
                },
                child: const Text("Back to Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}