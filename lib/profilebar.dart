import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = "";
  String email = "";
  int age = 0;
  String country = "";

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    DocumentSnapshot userData = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    
    if (userData.exists) {
      print("User data: ${userData.data()}"); // Debugging line
      setState(() {
        name = userData.get('name') ?? "No Name";
        email = userData.get('email') ?? "No Email";
        age = userData.get('age') ?? 0;
        country = userData.get('country') ?? "Unknown";
      });
    } else {
      print("No user data found!");
    }
  } else {
    print("No user logged in!");
  }
}

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_outlined, color: Colors.black),
            onPressed: _logout,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.teal.shade300,
                child: Icon(Icons.person_rounded, color: Colors.white, size: 50),
              ),
            ),
            const SizedBox(height: 20),
            _buildProfileDetail("Name", name),
            _buildProfileDetail("Email", email),
            _buildProfileDetail("Age", age.toString()),
            _buildProfileDetail("Country", country),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueGrey),
          ),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.all(12),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

