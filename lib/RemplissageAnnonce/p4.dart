import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myfrontend/Users/Seller.dart';

class p4 extends StatefulWidget {
  final int userId;
  final String marque;
  final String modele;
  final String version;
  final String puissance;
  final String carburant;
  final String motorisation;
  final String dateFabrication;
  final String nombrePlaces;
  final String transmission;

  const p4({
    required this.marque,
    required this.modele,
    required this.version,
    required this.puissance,
    required this.carburant,
    required this.motorisation,
    required this.dateFabrication,
    required this.nombrePlaces,
    required this.transmission,
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  State<p4> createState() => _p4State();
}

class _p4State extends State<p4> {
  late TextEditingController _titreController;
  late TextEditingController _numeroCarteGriseController;
  late TextEditingController _prixController;

  @override
  void initState() {
    super.initState();
    _titreController = TextEditingController();
    _numeroCarteGriseController = TextEditingController();
    _prixController = TextEditingController();
  }

  @override
  void dispose() {
    _titreController.dispose();
    _numeroCarteGriseController.dispose();
    _prixController.dispose();
    super.dispose();
  }

  Future<void> _createAnnonce() async {
    String titre = _titreController.text;
    String numeroCarteGrise = _numeroCarteGriseController.text;
    String prix = _prixController.text;

    Map<String, dynamic> carData = {
      'marque': widget.marque,
      'modele': widget.modele,
      'version': widget.version,
      'puissance': widget.puissance,
      'carburant': widget.carburant,
      'motorisation': widget.motorisation,
      'transmission': widget.transmission,
      'date_fabrication': widget.dateFabrication,
      'nombre_places': widget.nombrePlaces,
      'numero_cr': numeroCarteGrise,
      'prix': prix,
    };
    
    if (widget.userId == null || widget.userId == 0) {
      print("User ID is not available or invalid");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: ID de l\'utilisateur non disponible')),
      );
      return;
    }

    final url = 'http://10.0.2.2:8000/annonces/create/';
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode({
        'titre': titre,
        'car': carData,
        'createur_id': widget.userId, 
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Annonce créée avec succès'),
        duration: Duration(seconds: 2),
      ));
   
    } else {
      print('Failed to create annonce: ${response.body}');
      
      try {
        Map<String, dynamic> errorBody = jsonDecode(response.body);
        String errorMessage = errorBody['non_field_errors'] ?? 'Erreur lors de la création de l\'annonce';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(errorMessage),
          duration: Duration(seconds: 2),
        ));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Erreur: ${response.body}'),
          duration: Duration(seconds: 2),
        ));
      }
    }
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
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Poster une annonce',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _numeroCarteGriseController,
              style: TextStyle(fontSize: 18, color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Numéro de la carte grise',
                labelStyle: TextStyle(color: Colors.yellow[700]),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.yellow[700]!),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _prixController,
              style: TextStyle(fontSize: 18, color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Prix',
                labelStyle: TextStyle(color: Colors.yellow[700]),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.yellow[700]!),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Back', style: TextStyle(fontSize: 18, color: Colors.white)),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.yellow[700],
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Colors.grey[900],
                          title: Text("Titre de l'annonce", style: TextStyle(color: Colors.white)),
                          content: TextField(
                            controller: _titreController,
                            style: TextStyle(fontSize: 18, color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Titre de l\'annonce',
                              labelStyle: TextStyle(color: Colors.yellow[700]),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.yellow[700]!),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          actions: [
                            _buildDialogButton('Annuler', () {
                              Navigator.of(context).pop();
                            }),
                            _buildDialogButton('Poster', () async {
                              _createAnnonce();
                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Seller(userId: widget.userId)));
                            }),
                          ],
                        );
                      },
                    );
                  },
                  child: Text('next', style: TextStyle(fontSize: 18, color: Colors.black)),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.yellow[700]!),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
