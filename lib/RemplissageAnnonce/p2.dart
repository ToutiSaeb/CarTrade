import 'package:flutter/material.dart';
import 'p3.dart';

class p2 extends StatefulWidget {
  final int userId; 
  final String marque;
  final String modele;
  final String version;

  const p2({required this.marque, required this.modele, required this.version, Key? key, required this.userId}) : super(key: key);

  @override
  State<p2> createState() => _p2State();
}

class _p2State extends State<p2> {
  late TextEditingController _puissanceController;
  String? _selectedCarburant;
  late TextEditingController _motorisationController;

  @override
  void initState() {
    super.initState();
    _puissanceController = TextEditingController();
    _motorisationController = TextEditingController();
  }

  @override
  void dispose() {
    _puissanceController.dispose();
    _motorisationController.dispose();
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
                controller: _puissanceController,
                style: TextStyle(fontSize: 18, color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Puissance',
                  labelStyle: TextStyle(color: Colors.yellow[700]),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.yellow[700]!),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _motorisationController,
                style: TextStyle(fontSize: 18, color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Motorisation',
                  labelStyle: TextStyle(color: Colors.yellow[700]),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.yellow[700]!),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              DropdownButton<String>(
                value: _selectedCarburant,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCarburant = newValue;
                  });
                },
                items: ['Essence', 'Diesel', 'Electric'].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(color: Colors.white)),
                  );
                }).toList(),
                hint: Text('Carburant', style: TextStyle(color: Colors.grey[600])),
                dropdownColor: Colors.black,
              ),
              Spacer(),
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
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => p3(
                            marque: widget.marque,
                            modele: widget.modele,
                            version: widget.version,
                            puissance: _puissanceController.text,
                            carburant: _selectedCarburant ?? '',
                            motorisation: _motorisationController.text,
                             userId: widget.userId,
                          ),
                        ),
                      );
                    },
                    child: Text('Next', style: TextStyle(fontSize: 18, color: Colors.black)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow[700],
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
