import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';
import 'package:notes/pages/forgot.dart';
import 'package:notes/pages/home.dart';
import 'package:notes/pages/signup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> signIn() async {
    setState(() {
      isLoading = true;
    });

    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      if (userCredential.user != null) {
        // Authentication successful, navigate to Home
        Get.off(() => Home());
      } else {
        // If user is null, display error message
        Get.snackbar("Login Failed", "User not found.");
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.message ?? "An error occurred.");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> signInWithGoogle() async {
    setState(() {
      isLoading = true;
    });

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User canceled the sign-in
        setState(() {
          isLoading = false;
        });
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      if (userCredential.user != null) {
        // Authentication successful, navigate to Home
        Get.off(() => Home());
      } else {
        Get.snackbar("Login Failed", "User not found.");
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.message ?? "An error occurred during sign-in.");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(
              title: Text("Login"),
            ),
            body: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(hintText: 'Enter email ID'),
                  ),
                  TextField(
                    controller: passwordController,
                    obscureText: true, // Hides password input
                    decoration: InputDecoration(hintText: 'Enter password'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                      onPressed: signIn, // Trigger email sign-in
                      child: Text('Login')),
                  SizedBox(height: 30),
                  ElevatedButton(
                      onPressed: () => Get.to(() => Signup()),
                      child: Text('Register Now')),
                  SizedBox(height: 30),
                  ElevatedButton(
                      onPressed: () => Get.to(() => Forgot()),
                      child: Text('Forgot Password?')),
                  SizedBox(height: 30),
                  ElevatedButton(
                      onPressed: signInWithGoogle, // Trigger Google sign-in
                      child: Text('Sign in with Google')),
                ],
              ),
            ),
          );
  }
}
