import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'products.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _toggleFavorite(String productId, bool isFavorite) async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentReference favRef = _firestore.collection('users').doc(user.uid).collection('favorites').doc(productId);
      if (isFavorite) {
        await favRef.delete();
      } else {
        await favRef.set({'productId': productId});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;
    if (user == null) {
      return const Center(child: Text("Please log in to view favorites"));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Items you've liked in past")),
      body: StreamBuilder(
        stream: _firestore.collection('users').doc(user.uid).collection('favorites').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          var favDocs = snapshot.data!.docs;
          if (favDocs.isEmpty) {
            return const Center(child: Text("No favorite products yet"));
          }
          return ListView.builder(
            itemCount: favDocs.length,
            itemBuilder: (context, index) {
              var productId = favDocs[index]['productId'];
              return FutureBuilder(
                future: _firestore.collection('products').doc(productId).get(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> productSnapshot) {
                  if (!productSnapshot.hasData) {
                    return const SizedBox.shrink();
                  }
                  var product = productSnapshot.data!;
                  return Card(
                    margin: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Image.network(product['image'], height: 150, width: double.infinity, fit: BoxFit.cover),
                            Positioned(
                              top: 10,
                              right: 10,
                              child: IconButton(
                                icon: const Icon(Icons.favorite, color: Colors.red),
                                onPressed: () => _toggleFavorite(product.id, true),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(product['name'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              Text("Rating: ${product['rating']} ⭐"),
                              Text("Price: Rs. ${product['price']}"),
                              ElevatedButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ProductPage(productId: product.id)),
                                ),
                                child: const Text("Details"),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
