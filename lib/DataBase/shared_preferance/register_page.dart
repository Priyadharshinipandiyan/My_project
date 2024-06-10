import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_project/DataBase/shared_preferance/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _register(BuildContext context) async {
    if (_formKey.currentState!.validate()) {

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', usernameController.text);
      await prefs.setString('email', emailController.text);
      await prefs.setString('phone', phoneController.text);
      await prefs.setString('password', passwordController.text);
      await prefs.setBool('isLogin', true);

      Navigator.pop(context);
    }
  }

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your username';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }
    else if(value.length != 10){
      return 'Please enter valid phone number';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    else if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    else if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Password must contain at least one special character';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/image3.jpg',
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(32.0),
              child: Form(
                key: _formKey,
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
                    TextFormField(
                      controller: usernameController,
                      validator: _validateUsername,
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
                    // Email field
                    TextFormField(
                      validator: _validateEmail,
                      controller: emailController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Mail ID',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    // Phone number field
                    TextFormField(
                      controller: phoneController,
                      maxLength: 10,
                      keyboardType: TextInputType.number,
                      validator: _validatePhone,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Phone Number',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    // Password field
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      validator: _validatePassword,
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
                    // Register button
                    ElevatedButton(
                      onPressed: () => _register(context),
                      child: Text('Register'),
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
                      "Already have an account?",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(height: 5.0),
                    // Login button
                    TextButton(
                      onPressed: () {
                        // Navigate to login page
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Login",
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