import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:utilmate/fav.dart';
import 'package:utilmate/orders.dart';
import '../home.dart';
import './profilebar.dart';
import './orders.dart';
import './cart.dart';


class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const CartScreen(),
    const OrdersScreen(),
    const SavedScreen(),
    const ProfileScreen(),
  ];

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: _pages[_selectedIndex], 
    bottomNavigationBar: CurvedNavigationBar(
      backgroundColor: Theme.of(context).colorScheme.surface,
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
        Icon(Icons.home, size: 30, color: Colors.black), 
        Icon(Icons.shopping_basket, size: 30, color: Colors.black),
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
      appBar: AppBar(title: Container( child: Text('Home'),decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(10) ), padding: EdgeInsets.all(10), )),
      body: HomeSection(),
    );
  }
}



class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Container( child: Text('Orders'),decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(10) ), padding: EdgeInsets.all(10), )),

      body:null,
    );
  }
}

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Container( child: Text('Your Cart'),decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(10) ), padding: EdgeInsets.all(10), )),

      body: OrdersPage(),
    );
  }
}

class SavedScreen extends StatelessWidget {
  const SavedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Container( child: Text('Favourites ♡'),decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(10) ), padding: EdgeInsets.all(10), )),

      body: FavoritesPage(),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Container( child: Text('User'),decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(10) ), padding: EdgeInsets.all(10), )),

      body: ProfilePage(),
    );
  }
}

// class Homebar extends StatelessWidget{
  
// }