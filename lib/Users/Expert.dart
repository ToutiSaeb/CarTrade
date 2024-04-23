import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myfrontend/appEntry/appEntry.dart';

class Expert extends StatefulWidget {
  const Expert({Key? key});

  @override
  State<Expert> createState() => _ExpertState();
}

class _ExpertState extends State<Expert> {
  late Future<String> _userRoleFuture;
  late Future<List<Map<String, dynamic>>> _expertListFuture;
  List<Map<String, dynamic>> expertlist = [];

  @override
  void initState() {
    super.initState();
    _userRoleFuture = _getUserRole();
    _expertListFuture = _fetchexpert();
  }

  Future<String> _getUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_role') ?? '';
  }

  Future<List<Map<String, dynamic>>> _fetchexpert() async {
    final url = 'http://10.0.2.2:8000/authentification/afficheexpert';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load expert');
    }
  }

  Widget _buildLogoutButton(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.logout),
      onPressed: () => _logout(context),
    );
  }

  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('auth_token');
    prefs.remove('user_role');
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => AppEntry()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expert Page'),
        actions: [
          _buildLogoutButton(context),
          FutureBuilder<String>(
            future: _userRoleFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else {
                if (snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(snapshot.data!),
                  );
                } else {
                  return SizedBox.shrink();
                }
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _expertListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.hasData) {
              expertlist = snapshot.data!;
              return ListView.builder(
                itemCount: expertlist.length,
                itemBuilder: (context, index) => Container(
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  padding: EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        " ${expertlist[index]['username'] ?? 'N/A'}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        "${expertlist[index]['email'] ?? 'N/A'}",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Center(child: Text('Failed to load experts'));
            }
          }
        },
      ),
    );
  }
}
