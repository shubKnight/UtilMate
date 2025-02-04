import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({Key? key}) : super(key: key);

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  double totalPrice = 0;
  List<Map<String, dynamic>> orders = [];

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    User? user = _auth.currentUser;
    if (user == null) return;

    var snapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('orders')
        .get();

    List<Map<String, dynamic>> orderList = [];
    double total = 0;

    for (var doc in snapshot.docs) {
      var data = doc.data();
      orderList.add(data);
      total += double.tryParse(data['price'].toString()) ?? 0;
    }

    setState(() {
      orders = orderList;
      totalPrice = total + 50; 
    });
  }

  void _processCODPayment() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Your order is placed !! (COD)")),
    );

    _clearOrders();
  }

  void _processOnlinePayment() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const OnlinePaymentPage(),
      ),
    );
  }

  void _clearOrders() async {
    User? user = _auth.currentUser;
    if (user == null) return;

    var ordersRef = _firestore.collection('users').doc(user.uid).collection('orders');
    var snapshot = await ordersRef.get();
    for (var doc in snapshot.docs) {
      doc.reference.delete();
    }

    setState(() {
      orders.clear();
      totalPrice = 50; // as of now preset for delivery charges
    });
    print("calling chekc!!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Checkout")),
      body: orders.isEmpty
          ? const Center(child: Text("No items in checkout"))
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Order Summary",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        var order = orders[index];
                        return ListTile(
                          leading: Image.network(order['image'], width: 50, height: 50, fit: BoxFit.cover),
                          title: Text(order['name'], style: const TextStyle(fontSize: 18)),
                          subtitle: Text("Rs. ${order['price']}"),
                        );
                      },
                    ),
                  ),
                  
                  ListTile(
                    title: const Text("Delivery Charges"),
                    trailing: const Text("Rs. 50"),
                  ),
                  ListTile(
                    title: const Text("Total Amount", style: TextStyle(fontWeight: FontWeight.bold)),
                    trailing: Text("Rs. $totalPrice", style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: _processCODPayment,
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                        child: const Text("COD"),
                      ),
                      ElevatedButton(
                        onPressed: _processOnlinePayment,
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade50),
                        child: const Text("Online Payment",),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}

class OnlinePaymentPage extends StatelessWidget {
  const OnlinePaymentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Online Payment")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Payment Successful!")),
            );
            var a=_CheckoutPageState(); 
            a._clearOrders();
            Navigator.pop(context);
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
          child: const Text("As of now i'm learning to connect payment gateway, till then i'm skipping this part!!"),
        ),
      ),
    );
  }
}


