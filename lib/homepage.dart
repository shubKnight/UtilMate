import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    
    const OrdersScreen(),
    const SavedScreen(),
    const ProfileScreen(),
  ];

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: _pages[_selectedIndex], 
    bottomNavigationBar: CurvedNavigationBar(
      backgroundColor: Colors.white,
      color: Colors.blue.shade50, 
      buttonBackgroundColor: Colors.blue.shade100,
      height: 60,
      animationDuration: const Duration(milliseconds: 300),
      index: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      items: [
        Icon(Icons.home, size: 30, color: Colors.black), // Softer contrast
        Icon(Icons.shopping_bag, size: 30, color: Colors.black),
        Icon(Icons.favorite, size: 30, color: Colors.black),
        Icon(Icons.person, size: 30, color: Colors.black),
      ],
    ),
  );
}
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Container( child: Text('Home'), color: Colors.blue.shade50 ,padding: EdgeInsets.all(7), )),
      
    );
  }
}



class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Orders')),
      body: const Center(child: Text('Orders Screen', style: TextStyle(fontSize: 22))),
    );
  }
}

class SavedScreen extends StatelessWidget {
  const SavedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saved')),
      body: const Center(child: Text('Saved Items', style: TextStyle(fontSize: 22))),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: const Center(child: Text('Profile Screen', style: TextStyle(fontSize: 22))),
    );
  }
}

// class Homebar extends StatelessWidget{
  
// }