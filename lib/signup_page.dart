import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:utilmate/homepage.dart';
import 'login_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController countryController = TextEditingController();

  String errorMessage = '';

  Future<void> signup() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String name = nameController.text.trim();
    String age = ageController.text.trim();
    String country = countryController.text.trim();

    if ([email, password, name, age, country].any((e) => e.isEmpty)) {
      setState(() => errorMessage = 'All fields are required');
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);


      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'name': name,
        'age': int.tryParse(age) ?? 0,
        'country': country,
        'email': email,
      });

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Homepage()));
    } catch (e) {
      setState(() => errorMessage = 'Maybe Signup failed/succeeded. Maybe give Login a try!!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Signup'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('UtilMate', textAlign: TextAlign.center, style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder())),
              const SizedBox(height: 15),
              TextField(controller: passwordController, decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()), obscureText: true),
              const SizedBox(height: 15),
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder())),
              const SizedBox(height: 15),
              TextField(controller: ageController, decoration: const InputDecoration(labelText: 'Age', border: OutlineInputBorder())),
              const SizedBox(height: 15),
              TextField(controller: countryController, decoration: const InputDecoration(labelText: 'Country', border: OutlineInputBorder())),
              const SizedBox(height: 10),
              if (errorMessage.isNotEmpty) Text(errorMessage, style: const TextStyle(color: Colors.red), textAlign: TextAlign.center),
              const SizedBox(height: 10),
              ElevatedButton(onPressed: signup, child: const Text('Sign Up')),
            ],
          ),
        ),
      ),
    );
  }
}