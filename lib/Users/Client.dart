import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myfrontend/Users/Expert.dart';
import 'package:myfrontend/appEntry/appEntry.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Client extends StatefulWidget {
  const Client({Key? key});

  @override
  _ClientState createState() => _ClientState();
}

class _ClientState extends State<Client> {
  List<Map<String, dynamic>> usersList = [];
  List<dynamic> annonces = [];
  List<dynamic> filteredAnnonces = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
    _fetchAnnonces();
  }

  Future<void> _fetchUsers() async {
    final url = 'http://10.0.2.2:8000/authentification/afficheuserdetails';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> usersData = json.decode(response.body);
      setState(() {
        usersList = usersData.map((user) {
          return {
            'id': user['id'],
            'username': user['username'],
            'email': user['email'],
          };
        }).toList();
      });
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<void> _fetchAnnonces() async {
    var response = await http.get(
      Uri.parse('http://10.0.2.2:8000/annonces/affiche/'),
    );

    if (response.statusCode == 200) {
      setState(() {
        annonces = jsonDecode(response.body);
        filteredAnnonces = annonces;
      });
    } else {
      print('Failed to fetch annonces: ${response.statusCode}');
    }
  }

  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('auth_token');
    prefs.remove('user_role');
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => AppEntry()));
  }

  void _searchAnnonces(String query) {
    setState(() {
      filteredAnnonces = annonces.where((annonce) => 
        annonce['titre'].toLowerCase().contains(query.toLowerCase())).toList();
    });
  }
   ElevatedButton _buildDialogButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      child: Text(text),
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.yellow[700]!),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0.0,
        title: Text(
          'Annonces',
          style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: AnnonceSearchDelegate(filteredAnnonces, _searchAnnonces));
            },
            icon: Icon(Icons.search, color: Colors.white),
          ),
          IconButton(
            onPressed: () {
              _fetchAnnonces();
            },
            icon: Icon(Icons.refresh, color: Colors.white),
          ),
          IconButton(
            onPressed: () {
              _logout(context);
            },
            icon: Icon(Icons.logout, color: Colors.white),
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.grey[900],
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.black,
                ),
                child: Text(
                  'Menu',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
              ListTile(
                title: Text('Accueil', style: TextStyle(color: Colors.white)),
                leading: Icon(Icons.home, color: Colors.white),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              // Add more drawer items here
            ],
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: filteredAnnonces.length,
        itemBuilder: (context, index) {
          final annonce = filteredAnnonces[index];
          final car = annonce['car'];
          final createur = annonce['createur'];
          final userDetails = usersList.firstWhere((user) => user['id'].toString() == createur.toString(), orElse: () => {'username': '', 'email': ''});

          return InkWell(
            onTap: () {
               showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Colors.grey[900],
                          title: Text("chose an expert", style: TextStyle(color: Colors.white)),
                       
                          actions: [
                            _buildDialogButton('Cancel', () {
                              Navigator.of(context).pop();
                            }),
                            _buildDialogButton('Ok', () async {
                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Expert()));
                            }),
                          ],
                        );
                      },
                    );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  title: Text(annonce['titre'], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow('Marque', car['marque']),
                      _buildDetailRow('Modele', car['modele']),
                      _buildDetailRow('Prix', car['prix']),
                      _buildDetailRow('Version', car['version']),
                      _buildDetailRow('Puissance', car['puissance']),
                      _buildDetailRow('Carburant', car['carburant']),
                      _buildDetailRow('Motorisation', car['motorisation']),
                      _buildDetailRow('Date de fabrication', car['date_fabrication']),
                      _buildDetailRow('Nombre de places', car['nombre_places'].toString()),
                      _buildDetailRow('Transmission', car['transmission']),
                      _buildDetailRow('Numero CR', car['numero_cr'].toString()),
                      Text('Createur: ${userDetails['username']}, Email: ${userDetails['email']}', style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 16, color: Colors.grey[700])),
          Text(value ?? '', style: TextStyle(fontSize: 16, color: Colors.black)),
        ],
      ),
    );
  }
}

class AnnonceSearchDelegate extends SearchDelegate<String> {
  final List<dynamic> annonces;
  final Function(String) searchAnnonces;

  AnnonceSearchDelegate(this.annonces, this.searchAnnonces);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear, color: Colors.black),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, '');
      },
      icon: Icon(Icons.arrow_back, color: Colors.black),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Implement if needed
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView.builder(
      itemCount: annonces.length,
      itemBuilder: (context, index) {
        final annonce = annonces[index];
        return ListTile(
          title: Text(annonce['titre'], style: TextStyle(color: Colors.black)),
          onTap: () {
            searchAnnonces(annonce['titre']);
            close(context, annonce['titre']);
          },
        );
      },
    );
  }
}
