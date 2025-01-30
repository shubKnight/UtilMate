import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'homepage.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String errorMessage = '';

  Future<void> login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() => errorMessage = 'Please fill all fields');
      return;
    }

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email, password: password);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('email', email); // Save login state

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Homepage()));
    } catch (e) {
      setState(() => errorMessage = 'Invalid credentials. Try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('UtilMate', textAlign: TextAlign.center, style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder())),
            const SizedBox(height: 15),
            TextField(controller: passwordController, decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()), obscureText: true),
            const SizedBox(height: 10),
            if (errorMessage.isNotEmpty) Text(errorMessage, style: const TextStyle(color: Colors.red), textAlign: TextAlign.center),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: login, child: const Text('Login')),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text('Don\'t have an account?'),
              TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SignupPage())), child: const Text('Sign Up'))
            ]),
          ],
        ),
      ),
    );
  }
}