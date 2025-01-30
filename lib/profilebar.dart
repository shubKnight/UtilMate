import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../login_page.dart';

class ProfileBar extends StatefulWidget {
  const ProfileBar({Key? key}) : super(key: key);

  @override
  _ProfileBarState createState() => _ProfileBarState();
}

class _ProfileBarState extends State<ProfileBar> {
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
        setState(() {
          name = userData['name'];
          email = userData['email'];
          age = userData['age'];
          country = userData['country'];
        });
      }
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
    return PopupMenuButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),padding: EdgeInsets.all(20),
      offset: const Offset(40,80),
      itemBuilder: (context) => [
        PopupMenuItem(padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  const SizedBox(width: 70),
                  Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Divider(),
              Text("Email: $email"),
              Text("Age: $age"),
              Text("Country: $country"),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text("Logout", style: TextStyle(color: Colors.red,)),
                onTap: _logout,
              ),
            ],
          ),
        ),
      ],
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.blue.shade100,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.person, color: Colors.black),
            const SizedBox(width: 8),
            Text(name.isNotEmpty ? name : "Profile", style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(width: 5),
            Icon(Icons.arrow_drop_down, color: Colors.black),
          ],
        ),
      ),
    );
  }
}
