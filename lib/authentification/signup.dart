import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfrontend/Users/Client.dart';
import 'package:myfrontend/Users/Expert.dart';
import 'package:myfrontend/Users/Seller.dart';
import 'package:myfrontend/authentification/login.dart';
import 'package:http/http.dart' as http;

class SignUpPage extends StatefulWidget {
  final String selectedOption;

  SignUpPage({required this.selectedOption});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String selectionRole = '';

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectionRole = widget.selectedOption;
    print(selectionRole);
  }

   Future<void> _signup(BuildContext context) async {
  final response = await http.post(
    Uri.parse('http://10.0.2.2:8000/authentification/signup/'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'username': _usernameController.text.trim(),
      'email': _emailController.text.trim(),
      'password': _passwordController.text.trim(),
      'role': selectionRole,
    }),
  );
  if(response.statusCode == 201){
    final responseData = json.decode(response.body);
    final userId = responseData['user_id'];
    
    if (userId != null){
      switch(selectionRole){
        case 'client':{
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Client()));
          break;
        }
        case 'expert':{
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Expert()));
          break;
        }
        case 'seller':{
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Seller(userId: userId)));
          break;
        }
      }
    } else {
      print('user_id is null in response');
    }
  }
  else{
    print('failed to signup ${response.statusCode}');
    print(response.body);  // This will print the response body for further debugging
  }
}


  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      backgroundColor: Color.fromARGB(55, 65, 65, 65),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: const Color.fromARGB(255, 221, 210, 210)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(screenSize.width * 0.05),
          margin: EdgeInsets.symmetric(horizontal: screenSize.width * 0.1),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [ Colors.white, Colors.black],
            ),
            borderRadius: BorderRadius.circular(screenSize.width * 0.05),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Sign Up',
                  style: TextStyle(fontSize: isPortrait ? screenSize.width * 0.1 : screenSize.width * 0.07, fontWeight: FontWeight.bold, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: screenSize.height * 0.03),
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    prefixIcon: Icon(Icons.person, color: Colors.white),
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(screenSize.width * 0.05),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: screenSize.height * 0.02),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email, color: Colors.white),
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(screenSize.width * 0.05),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: screenSize.height * 0.02),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock, color: Colors.white),
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(screenSize.width * 0.05),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: screenSize.height * 0.03),
                ElevatedButton(
                  onPressed: () {
                   _signup(context);
                  },
                  child: Text('Sign Up'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, 
                    backgroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.2, vertical: screenSize.height * 0.02),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(screenSize.width * 0.05),
                    ),
                  ),
                ),
                SizedBox(height: screenSize.height * 0.02),
                Text(
                  'or sign up with',
                  style: TextStyle(fontSize: isPortrait ? screenSize.width * 0.04 : screenSize.width * 0.025, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: screenSize.height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          print('Sign up with Google');
                        },
                        icon: Icon(Icons.g_translate),
                        label: Text('Google'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.yellow[700], 
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(screenSize.width * 0.05),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: screenSize.width * 0.03),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          print('Sign up with Facebook');
                        },
                        icon: Icon(Icons.facebook),
                        label: Text('Facebook'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black, 
                          backgroundColor: Colors.yellow[700],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(screenSize.width * 0.05),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenSize.height * 0.02),
                Text(
                  '____________',
                  style: TextStyle(fontSize: isPortrait ? screenSize.width * 0.04 : screenSize.width * 0.025, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: screenSize.height * 0.01),
                Text(
                  'I already have an account',
                  style: TextStyle(fontSize: isPortrait ? screenSize.width * 0.04 : screenSize.width * 0.025, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Login(selectionRole: selectionRole)));
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(fontSize: isPortrait ? screenSize.width * 0.04 : screenSize.width * 0.025, color: Colors.yellow[700], fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: screenSize.height * 0.04),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
