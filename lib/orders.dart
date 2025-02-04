// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'products.dart';

// class OrdersPage extends StatefulWidget {
//   const OrdersPage({Key? key}) : super(key: key);

//   @override
//   _OrdersPageState createState() => _OrdersPageState();
// }

// class _OrdersPageState extends State<OrdersPage> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   /// Checkout for later rn-clearing order only
//   void _checkout() async {
//     User? user = _auth.currentUser;
//     if (user == null) return;

//     await _firestore
//         .collection('users')
//         .doc(user.uid)
//         .collection('orders')
//         .get()
//         .then((snapshot) {
//       for (var doc in snapshot.docs) {
//         doc.reference.delete();
//       }
//     });
//   }

//   /// Remove order item
//   void _removeOrder(String orderId) async {
//     User? user = _auth.currentUser;
//     if (user == null) return;

//     await _firestore
//         .collection('users')
//         .doc(user.uid)
//         .collection('orders')
//         .doc(orderId)
//         .delete();
//   }

//   @override
//   Widget build(BuildContext context) {
//     User? user = _auth.currentUser;
//     if (user == null) {
//       return const Center(child: Text("Please log in to view your orders"));
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: StreamBuilder(
//           stream: _firestore.collection('users').doc(user.uid).collection('orders').snapshots(),
//           builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//             if (!snapshot.hasData) {
//               return const Text("Orders");
//             }
//             var orders = snapshot.data!.docs;

//             double totalPrice = orders.fold(0, (sum, order) {
//               return sum + (double.tryParse(order['price'].toString()) ?? 0);
//             });

//             return Text("Items  -            Total: Rs. $totalPrice");
//           },
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.shopping_cart_checkout),
//             onPressed: _checkout,
//           ),
//         ],
//       ),
//       body: StreamBuilder(
//         stream: _firestore.collection('users').doc(user.uid).collection('orders').snapshots(),
//         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (!snapshot.hasData) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           var orders = snapshot.data!.docs;
//           if (orders.isEmpty) {
//             return const Center(child: Text("No orders yet"));
//           }

//           return ListView.builder(
            
//             itemCount: orders.length,
//             itemBuilder: (context, index) {
//               var order = orders[index];

              
//               var orderData = order.data() as Map<String, dynamic>?;
//               print("Order Data: $orderData");


//               if (orderData == null) {
//                 return const SizedBox.shrink();
//               }

//               return Card(
//                 margin: const EdgeInsets.all(10),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(10),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Image.network(orderData['image'], width: 80, height: 80, fit: BoxFit.cover),
//                           const SizedBox(width: 10),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(orderData['name'] ?? "No Name",
//                                     style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                                 Text("Price: Rs. ${orderData['price'] ?? 'N/A'}", style: const TextStyle(fontSize: 16)),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 10),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           ElevatedButton(
//                             onPressed: () => Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) {
//                                   print(
//                                       "Navigating to ProductPage with ID: ${orderData['productId']}");
//                                   return ProductPage(
//                                       productId: orderData['productId']);
//                                 },
//                               ),
//                             ),
//                             child: const Text("Details"),
//                           ),
//                           Row(
//                             children: [
//                               const Text("Rating: ", style: TextStyle(fontSize: 16)),
//                               const Icon(Icons.star, color: Colors.amber, size: 18),
//                               Text(orderData.containsKey('rating') ? " ${orderData['rating']}" : " N/A"),
//                             ],
//                           ),
//                           IconButton(
//                             icon: const Icon(Icons.delete, color: Colors.red),
//                             onPressed: () => _removeOrder(order.id),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
