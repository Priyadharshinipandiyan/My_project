import 'package:flutter/material.dart';
import 'package:my_project/DataBase/shared_preferance/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatelessWidget {
  Future<Map<String, String?>> _getUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    String? email = prefs.getString('email');
    String? phone = prefs.getString('phone');

    return {
      'username': username,
      'email': email,
      'phone': phone,
    };
  }

  Future<void> _logout(BuildContext context) async {
     SharedPreferences prefs = await SharedPreferences.getInstance();
     //await prefs.clear(); // Clear all stored data
     await prefs.setBool('isLogin', false);
    // Navigate to the LoginPage
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange[200],
        title: Text('Home Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            'assets/image3.jpg',
            fit: BoxFit.cover,
          ),
          // Semi-transparent overlay
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          // User details
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/image4.png',
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  // Fetch and display user details
                  FutureBuilder<Map<String, String?>>(
                    future: _getUserDetails(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }

                      if (snapshot.hasError) {
                        return Text(
                          'Error: ${snapshot.error}',
                          style: TextStyle(color: Colors.white),
                        );
                      }

                      var userDetails = snapshot.data!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Welcome to Flutter "
                                "\n${userDetails['username'] ?? ''}!!!",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          Text(
                            'Username: ${userDetails['username'] ?? ''}',
                            style: TextStyle(color: Colors.white, fontSize: 18.0),
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            'Email: ${userDetails['email'] ?? ''}',
                            style: TextStyle(color: Colors.white, fontSize: 18.0),
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            'Phone: ${userDetails['phone'] ?? ''}',
                            style: TextStyle(color: Colors.white, fontSize: 18.0),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
