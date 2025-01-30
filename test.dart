import 'package:flutter/material.dart';
import 'package:utilmate/main.dart';

void main(){
  runApp(MyApp());
}
 
class MyApp extends StatelessWidget {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

}




// class Signup extends StatefulWidget {
//   const Signup({Key? key}) : super(key: key);

//   @override
//   State<Signup> createState() => _SignupState();
// }

// class _SignupState extends State<Signup> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   Future<void> _signup() async {
//     try {
//       await FirebaseAuth.instance.createUserWithEmailAndPassword(
//         email: _emailController.text,
//         password: _passwordController.text,
//       );
//       ScaffoldMessenger.of(context)
//           .showSnackBar(const SnackBar(content: Text("Signup Successful")));
//       Navigator.pop(context); // Go back to login page
//     } catch (e) {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text("Error: $e")));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Signup")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _emailController,
//               decoration: const InputDecoration(labelText: "Email"),
//             ),
//             TextField(
//               controller: _passwordController,
//               decoration: const InputDecoration(labelText: "Password"),
//               obscureText: true,
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(onPressed: _signup, child: const Text("Sign Up")),
//           ],
//         ),
//       ),
//     );
//   }
// }
