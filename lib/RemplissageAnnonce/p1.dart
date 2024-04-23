import 'package:flutter/material.dart';
import 'p2.dart';

class P1 extends StatefulWidget {
  final int userId;  // Ajout du paramètre userId

  const P1({Key? key, required this.userId}) : super(key: key);

  @override
  State<P1> createState() => _P1State();
}

class _P1State extends State<P1> {
  late TextEditingController _modeleController;
  late TextEditingController _versionController;
  late TextEditingController _marqueController;

  @override
  void initState() {
    super.initState();
    _modeleController = TextEditingController();
    _versionController = TextEditingController();
    _marqueController = TextEditingController();
  }

  @override
  void dispose() {
    _modeleController.dispose();
    _versionController.dispose();
    _marqueController.dispose();
    super.dispose();
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _marqueController,
                style: TextStyle(fontSize: 18, color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Marque',
                  labelStyle: TextStyle(color: Colors.yellow[700]),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.yellow[700]!),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _modeleController,
                style: TextStyle(fontSize: 18, color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Modèle',
                  labelStyle: TextStyle(color: Colors.yellow[700]),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.yellow[700]!),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _versionController,
                style: TextStyle(fontSize: 18, color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Version',
                  labelStyle: TextStyle(color: Colors.yellow[700]),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.yellow[700]!),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => p2(
                        marque: _marqueController.text,
                        modele: _modeleController.text,
                        version: _versionController.text,
                         userId: widget.userId,
                      ),
                    ),
                  );
                },
                child: Text('Next', style: TextStyle(fontSize: 18, color: Colors.black)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow[700],
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
