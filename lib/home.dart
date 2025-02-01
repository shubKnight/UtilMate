import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'products.dart';

class HomeSection extends StatefulWidget {
  const HomeSection({Key? key}) : super(key: key);

  @override
  _HomeSectionState createState() => _HomeSectionState();
}

class _HomeSectionState extends State<HomeSection> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _specsController = TextEditingController();
  final TextEditingController _itemsController = TextEditingController();
  Map<String, bool> _favorites = {};
  @override
  void initState() {
    super.initState();
    _loadFavorites(); // Load favorites when the widget initializes
  }
  Future<void> _loadFavorites() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .get();

    setState(() {
      _favorites = {for (var doc in snapshot.docs) doc.id: true}; // doc.id is the productId
    });
  }
}



//   void checkIfFavorite(String productId) async {
//   User? user = FirebaseAuth.instance.currentUser;
//   if (user != null) {
//     DocumentSnapshot favSnapshot = await FirebaseFirestore.instance
//         .collection('users')
//         .doc(user.uid)
//         .collection('favorites')
//         .doc(productId)
//         .get();

//     setState(() {
//       isFavorite = favSnapshot.exists;
//     });
//   }
// }

  void _addProduct() {
    if (_nameController.text.isNotEmpty &&
        _imageController.text.isNotEmpty &&
        _priceController.text.isNotEmpty &&
        _specsController.text.isNotEmpty &&
        _itemsController.text.isNotEmpty) {
      _firestore.collection('products').add({
        'name': _nameController.text,
        'image': _imageController.text,
        'price': _priceController.text,
        'specs': _specsController.text,
        'items': int.parse(_itemsController.text),
        'rating': 4.5,
      });
      Navigator.pop(context);
    }
  }

  void _showAddProductDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Product"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: "Name")),
              TextField(
                  controller: _imageController,
                  decoration: InputDecoration(labelText: "Image URL")),
              TextField(
                  controller: _priceController,
                  decoration: InputDecoration(labelText: "Price (Rs.)")),
              TextField(
                  controller: _specsController,
                  decoration: InputDecoration(labelText: "Specs"),
                  maxLines: 3),
              TextField(
                  controller: _itemsController,
                  decoration: InputDecoration(labelText: "No. of items"),
                  keyboardType: TextInputType.number),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          ElevatedButton(onPressed: _addProduct, child: const Text("Add")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products available"),
        actions: [
          IconButton(
              icon: const Icon(Icons.add), onPressed: _showAddProductDialog),
        ],
      ),
      body: StreamBuilder(
        stream: _firestore.collection('products').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          var products = snapshot.data!.docs;
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              var product = products[index];
              bool isFavorite = _favorites[product.id] ?? false;
              // checkIfFavorite(product.id);

              return Card(
                margin: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Image.network(product['image'],
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: IconButton(
                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFavorite ? Colors.red : Colors.black,
                            ),
                            onPressed: () async {
                              User? user = FirebaseAuth.instance.currentUser;
                              if (user != null) {
                                DocumentReference favRef = FirebaseFirestore
                                    .instance
                                    .collection('users')
                                    .doc(user.uid)
                                    .collection('favorites')
                                    .doc(product.id);

                                if (isFavorite) {
                                  await favRef.delete(); // Remove from favorites
                                  setState(() {
                                  _favorites[product.id] = false;
                                });
                                } else {
                                  await favRef.set({'productId': product.id
                                }); // Add to favorites
                                  setState(() {
                                  _favorites[product.id] = true;
                                });
                                }

                                setState(() {
                                  isFavorite = !isFavorite;
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(product['name'],
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          Text("Rating: ${product['rating']} ⭐"),
                          Text("Price: Rs. ${product['price']}"),
                          ElevatedButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ProductPage(productId: product.id)),
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
      ),

    );
  }
}


