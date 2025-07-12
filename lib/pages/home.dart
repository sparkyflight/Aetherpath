import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<String?> getAuthToken() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    return await user.getIdToken();
  }
  return null; // User is not logged in
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String selectedValue = 'Friends';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  String? _token;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
    _fetchToken();
  }

  void _fetchToken() async {
    if (_user != null) {
      String? token = await getAuthToken();
      setState(() {
        _token = token;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SegmentedButton<String>(
          segments: const <ButtonSegment<String>>[
            ButtonSegment(value: 'Friends', label: Text('Friends')),
            ButtonSegment(value: 'Following', label: Text('Following')),
            ButtonSegment(value: 'All Posts', label: Text('All Posts')),
          ],
          selected: {selectedValue},
          onSelectionChanged: (newSelection) {
            setState(() {
              selectedValue = newSelection.first;
            });
          },
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            if (_user != null)
              Column(
                children: [
                  Text('Name: ${_user!.displayName ?? "No Name"}'),
                  Text('Email: ${_user!.email ?? "No Email"}'),
                  Text('UID: ${_user!.uid}'),
                  _token == null
                      ? const CircularProgressIndicator()
                      : Text('Token: $_token'),
                  Text('Selected Category: $selectedValue'),
                ],
              )
            else
              const Text('No user logged in'),
          ],
        ),
      ),
    );
  }
}