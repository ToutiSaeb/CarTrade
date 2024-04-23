import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myfrontend/RemplissageAnnonce/p1.dart';
import 'package:myfrontend/Users/Seller.dart';
import 'package:myfrontend/appEntry/appEntry.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Annonce {
  final int id;
  final String titre;
  final Car car;
  final int createur;

  Annonce({required this.id, required this.titre, required this.car, required this.createur});

  factory Annonce.fromJson(Map<String, dynamic> json) {
    return Annonce(
      id: json['id'],
      titre: json['titre'],
      car: Car.fromJson(json['car']),
      createur: json['createur'],
    );
  }
}

class Car {
  final String marque;
  final String modele;
  final String prix;
  final String version;
  final String puissance;
  final String carburant;
  final String motorisation;
  final String dateFabrication;
  final String nombrePlaces;
  final String transmission;
  final String numeroCr;

  Car({
    required this.marque,
    required this.modele,
    required this.prix,
    required this.version,
    required this.puissance,
    required this.carburant,
    required this.motorisation,
    required this.dateFabrication,
    required this.nombrePlaces,
    required this.transmission,
    required this.numeroCr,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      marque: json['marque'] ?? '',
      modele: json['modele'] ?? '',
      prix: json['prix'] ?? '',
      version: json['version'] ?? '',
      puissance: json['puissance'] ?? '',
      carburant: json['carburant'] ?? '',
      motorisation: json['motorisation'] ?? '',
      dateFabrication: json['date_fabrication'] ?? '',
      nombrePlaces: json['nombre_places'] != null ? json['nombre_places'].toString() : '',
      transmission: json['transmission'] ?? '',
      numeroCr: json['numero_cr']!= null ? json['numero_cr'].toString() : '' ,
    );
  }
}

class Seller extends StatefulWidget {
  final int userId;

  const Seller({Key? key, required this.userId}) : super(key: key);

  @override
  _SellerState createState() => _SellerState();
}

class _SellerState extends State<Seller> {
  List<Annonce> annonces = [];

  @override
  void initState() {
    super.initState();
    _fetchAnnonces();
    print(widget.userId);
  }

  Future<void> _fetchAnnonces() async {
    var response = await http.get(
      Uri.parse('http://10.0.2.2:8000/annonces/affiche/'),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);

      setState(() {
        annonces = data
            .map((item) => Annonce.fromJson(item))
            .where((annonce) => annonce.createur == widget.userId)
            .toList();
      });
    } else {
      print('Failed to fetch annonces: ${response.statusCode}');
    }
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout', style: TextStyle(color: Colors.black)),
          content: Text('Êtes-vous sûr de vouloir vous déconnecter ?', style: TextStyle(color: Colors.black)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel', style: TextStyle(color: Colors.yellow[700])),
            ),
            TextButton(
              onPressed: () {
                _logout(context);
              },
              child: Text('Logout', style: TextStyle(color: Colors.yellow[700])),
            ),
          ],
        );
      },
    );
  }

  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
  
    prefs.remove('auth_token');
    prefs.remove('user_role');
    prefs.remove('user_id');

    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => AppEntry()));
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => P1(userId: widget.userId)),
              );
            },
            icon: Icon(Icons.add, color: Colors.white, size: 30),
          ),
           IconButton(
            onPressed: () {
              _fetchAnnonces();
            },
            icon: Icon(Icons.refresh, color: Colors.white, size: 30),
          ),
          IconButton(
            onPressed: () {
              _showLogoutDialog(context);
            },
            icon: Icon(Icons.logout, color: Colors.white, size: 30),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: annonces.length,
        itemBuilder: (context, index) {
          var annonce = annonces[index];
          var car = annonce.car;

          return Card(
            elevation: 5,
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              title: Text(annonce.titre, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow('Marque', car.marque),
                  _buildDetailRow('Modele', car.modele),
                  _buildDetailRow('Prix', car.prix),
                  _buildDetailRow('Version', car.version),
                  _buildDetailRow('Puissance', car.puissance),
                  _buildDetailRow('Carburant', car.carburant),
                  _buildDetailRow('Motorisation', car.motorisation),
                  _buildDetailRow('Date de fabrication', car.dateFabrication),
                  _buildDetailRow('Nombre de places', car.nombrePlaces),
                  _buildDetailRow('Transmission', car.transmission),
                  _buildDetailRow('Numero CR', car.numeroCr),
                  _buildDetailRow('ID Annonce', annonce.id.toString()),
                  _buildDetailRow('Createur ID', annonce.createur.toString()),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 18, color: Colors.yellow[700])),
          Text(value, style: TextStyle(fontSize: 18, color: Colors.white)),
        ],
      ),
    );
  }
}
