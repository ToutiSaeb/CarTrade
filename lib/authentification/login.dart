import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myfrontend/Users/Client.dart';
import 'package:myfrontend/Users/Expert.dart';
import 'package:myfrontend/Users/Seller.dart';
import 'package:myfrontend/authentification/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  final String selectionRole;

  Login({required this.selectionRole});

  @override
  State<Login> createState() => _LoginState();
}


class _LoginState extends State<Login> {
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  Future<String?> fetchUserRole() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final authToken = prefs.getString('auth_token');
  
  if(authToken == null) {
    print('Auth token not found');
    return null; // Pas de token d'authentification trouvé
  }

  final response = await http.get(
    Uri.parse('http://10.0.2.2:8000/authentification/afficherole/'),
    headers: {'Authorization': 'Token $authToken'},
  );

  if (response.statusCode == 200) {
    final dynamic userData = json.decode(response.body);

    // Extrait le rôle de l'utilisateur depuis les données reçues
    final userRole = userData['role'];

    return userRole != null ? userRole : null; // Retourne le rôle si trouvé, sinon null
  } else {
    throw Exception('Failed to load user role');
  }
}



  Future<void> _login(BuildContext context) async {
  final username = _usernameController.text.trim();
  final password = _passwordController.text.trim();

  final url = 'http://10.0.2.2:8000/authentification/login/';
  final response = await http.post(
    Uri.parse(url),
    body: jsonEncode({'username': username, 'password': password}),
    headers: {'Content-Type': 'application/json'},
  );

  if (response.statusCode == 200) {
    final responseData = json.decode(response.body);
    final token = responseData['token'];
    final userId = responseData['user_id']; // Ajoutez cette ligne pour récupérer l'ID
print(userId);
    if (token != null && userId != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('auth_token', token);
      prefs.setInt('user_id', userId); // Stockez l'ID de l'utilisateur dans SharedPreferences

      String? userRole = await fetchUserRole();
      print(userRole);
      if (userRole == 'client') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Client(),
          ),
        );
      } else if (userRole == 'expert') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Expert(),
          ),
        );
      } else if (userRole == 'seller') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Seller(userId: userId), 
          ),
        );
      } else {
        print('Unknown user role');
      }
    } else {
      print('Token or User ID is null');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to authenticate. Please try again.')),
      );
    }
  } else {
    print('Failed to login: ${response.statusCode}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to authenticate. Please try again.')),
    );
  }

  _usernameController.clear();
  _passwordController.clear();
}


  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color.fromARGB(55, 65, 65, 65),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
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
              colors: [Colors.white, Colors.black],
            ),
            borderRadius: BorderRadius.circular(screenSize.width * 0.05),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Login',
                  style: TextStyle(fontSize: screenSize.width * 0.1, fontWeight: FontWeight.bold, color: Colors.black),
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
                   _login(context);
                  },
                  child: Text('Login'),
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
                  '____________',
                  style: TextStyle(fontSize: screenSize.width * 0.04, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: screenSize.height * 0.01),
                Text(
                  'Don\'t have an account?',
                  style: TextStyle(fontSize: screenSize.width * 0.04, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>SignUpPage(selectedOption: widget.selectionRole)));
                  },
                  child: Text(
                    'Sign Up',
                    style: TextStyle(fontSize: screenSize.width * 0.04, color: Colors.yellow[700], fontWeight: FontWeight.bold),
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
