import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../login_page.dart'; 
import '../homepage.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // login chekcup
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userEmail = prefs.getString('email');

  runApp(MyApp(startingPage: userEmail == null ? LoginPage() : Homepage()));
}

class MyApp extends StatelessWidget {
  final Widget startingPage;
  const MyApp({Key? key, required this.startingPage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UtilMate',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: startingPage, // login if not signed in else homepage
    );
  }
}

