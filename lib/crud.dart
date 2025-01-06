

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserCRUDScreen extends StatefulWidget {
  @override
  _UserCRUDScreenState createState() => _UserCRUDScreenState();
}

class _UserCRUDScreenState extends State<UserCRUDScreen> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _usersCollection = FirebaseFirestore.instance.collection('users');

  // Create a local variable to hold the users data
  List<QueryDocumentSnapshot<Map<String, dynamic>>> _users = [];

  @override
  void initState() {
    super.initState();
    _loadUsers(); // Load users when the widget is initialized
  }

  // Function to fetch users from Firestore
  Future<void> _loadUsers() async {
    final snapshot = await _usersCollection.get();
    setState(() {
      _users = snapshot.docs; // Update the state with the fetched users
    });
  }

  // Create User function
  Future<void> _createUser() async {
    if (_nameController.text.isEmpty || _ageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter both name and age')));
      return;
    }

    try {
      await _usersCollection.add({
        'name': _nameController.text,
        'age': int.parse(_ageController.text),
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User created successfully')));
      _nameController.clear();
      _ageController.clear();
      await _loadUsers(); // Refresh the data after creation
    } catch (e) {
      print('Error creating user: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error creating user')));
    }
  }

  // Update User function
  Future<void> _updateUser(String id) async {
    if (_nameController.text.isEmpty || _ageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter both name and age')));
      return;
    }

    try {
      await _usersCollection.doc(id).update({
        'name': _nameController.text,
        'age': int.parse(_ageController.text),
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User updated successfully')));
      _nameController.clear();
      _ageController.clear();
      await _loadUsers(); // Refresh the data after update
    } catch (e) {
      print('Error updating user: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error updating user')));
    }
  }

  // Delete User function
  Future<void> _deleteUser(String id) async {
    try {
      await _usersCollection.doc(id).delete();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User deleted successfully')));
      await _loadUsers(); // Refresh the data after deletion
    } catch (e) {
      print('Error deleting user: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error deleting user')));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User CRUD Operations'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Name and Age input fields
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Age'),
            ),
            SizedBox(height: 20),

            // Create User Button
            ElevatedButton(
              onPressed: _createUser,
              child: Text('Create User'),
            ),
            SizedBox(height: 20),

            // User list and Update/Delete buttons
            Expanded(
              child: ListView.builder(
                itemCount: _users.length,
                itemBuilder: (context, index) {
                  var user = _users[index];
                  return ListTile(
                    title: Text(user['name']),
                    subtitle: Text('Age: ${user['age']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _nameController.text = user['name'];
                            _ageController.text = user['age'].toString();
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Update User'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      controller: _nameController,
                                      decoration: InputDecoration(labelText: 'Name'),
                                    ),
                                    TextField(
                                      controller: _ageController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(labelText: 'Age'),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      _updateUser(user.id);
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Update'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            _deleteUser(user.id);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}





