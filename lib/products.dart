import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProductPage extends StatefulWidget {
  final String productId;
  const ProductPage({Key? key, required this.productId}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  double _rating = 0;
  final TextEditingController _reviewController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _deleteProduct() async {
    await _firestore.collection('products').doc(widget.productId).delete();
    Navigator.pop(context);
  }

  Future<void> _addReview() async {
    User? user = _auth.currentUser;
    if (user != null && _reviewController.text.isNotEmpty) {
      await _firestore.collection('products').doc(widget.productId).collection('reviews').add({
        'username': user.email,
        'review': _reviewController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _reviewController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Product Details")),
      body: FutureBuilder(
        future: _firestore.collection('products').doc(widget.productId).get(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          var product = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product['name'], style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Card(
                  child: Image.network(product['image'], height: 200, fit: BoxFit.cover),
                ),
                const SizedBox(height: 10),
                Text("Price: Rs. ${product['price']}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ElevatedButton(onPressed: () {}, child: const Text("Buy")),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Rating: ${product['rating']} ⭐"),
                    Text("Pieces left: ${product['items']}")
                  ],
                ),
                const SizedBox(height: 10),
                RatingBar.builder(
                  initialRating: _rating,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
                  onRatingUpdate: (rating) {
                    setState(() {
                      _rating = rating;
                    });
                  },
                ),
                const SizedBox(height: 10),
                Text("Specs: ${product['specs']}", style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _deleteProduct,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text("Delete", style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(height: 20),
                const Text("Chats & Reviews", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _reviewController,
                        decoration: const InputDecoration(hintText: "Write a review"),
                      ),
                    ),
                    IconButton(icon: const Icon(Icons.send), onPressed: _addReview),
                  ],
                ),
                StreamBuilder(
                  stream: _firestore.collection('products').doc(widget.productId).collection('reviews').orderBy('timestamp', descending: true).snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) return const SizedBox.shrink();
                    return Column(
                      children: snapshot.data!.docs.map((review) {
                        return ListTile(
                          title: Text(review['username'], style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(review['review']),
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
