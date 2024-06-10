import 'package:flutter/material.dart';
import 'package:my_project/DataBase/shared_preferance/home_page.dart';
import 'package:my_project/DataBase/shared_preferance/register_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  Future<bool> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? storedLogin =  prefs.getBool('isLogin');
    if(storedLogin == null){
      await prefs.setBool('isLogin', false);
      storedLogin = false;
    }
    return storedLogin;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<bool>(
        future: _checkLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            if (snapshot.data == true) {
              return HomePage();
            } else {
              return LoginPage();
            }
          }
        },
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          // Login form
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(32.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Username field
                    Image.asset(
                      'assets/image4.png',
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Username',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    // Password field
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    // Login button
                    ElevatedButton(
                      onPressed: () async {
                        // Handle login action
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        String? storedUsername = prefs.getString('username');
                        String? storedPassword = prefs.getString('password');
                        //bool? storedLogin = prefs.getBool('isLogin',isLogin);
                        if (usernameController.text == storedUsername && passwordController.text == storedPassword) {
                          // Successful login
                          await prefs.setBool('isLogin', true);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Login successful!'),
                          ));
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
                          );
                        } else {
                          // Failed login
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Invalid username or password!'),
                          ));
                        }
                      },
                      child: Text('Login'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange[200],
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        textStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 30.0),
                    // Already Register text
                    Text(
                      "Dont'have a account?",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        // decoration: TextDecoration.underline,
                      ),
                    ),
                    SizedBox(height: 5.0),
                    // Already Register text
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RegisterPage()),
                        );
                      },
                      child: Text(
                        "Register",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
