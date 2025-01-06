import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nn/authservice.dart';

class GoogleSignInScreen extends StatefulWidget {
  @override
  _GoogleSignInScreenState createState() => _GoogleSignInScreenState();
}

class _GoogleSignInScreenState extends State<GoogleSignInScreen> {
  final GoogleSignInService _googleSignInService = GoogleSignInService();

  // Sign-in function
  Future<void> _signIn() async {
    try {
      User? user = await _googleSignInService.signInWithGoogle();
      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sign-In Successful')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sign-In Failed')));
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  // Sign out function
  Future<void> _signOut() async {
    await _googleSignInService.signOut();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Signed out successfully')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Google Sign-In')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _signIn,
              child: Text('Sign in with Google'),
            ),
            ElevatedButton(
              onPressed: _signOut,
              child: Text('Sign out'),
            ),
          ],
        ),
      ),
    );
  }
}
