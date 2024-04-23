import 'package:flutter/material.dart';
import 'p4.dart';

class p3 extends StatefulWidget {
  final int userId; 
  final String marque;
  final String modele;
  final String version;
  final String puissance;
  final String carburant;
  final String motorisation;

  const p3({
    required this.marque,
    required this.modele,
    required this.version,
    required this.puissance,
    required this.carburant,
    required this.motorisation,
    Key? key, required this.userId,
  }) : super(key: key);

  @override
  State<p3> createState() => _p3State();
}

class _p3State extends State<p3> {
  late DateTime _selectedDate = DateTime.now();
  late TextEditingController _nombrePlacesController;
  String? _selectedTransmission;

  @override
  void initState() {
    super.initState();
    _nombrePlacesController = TextEditingController(text: '2');
  }

  @override
  void dispose() {
    _nombrePlacesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton(
                onPressed: () => _selectDate(context),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today, color: Colors.yellow[700]),
                    SizedBox(width: 16),
                    Text(
                      'Date de fabrication: ${_selectedDate.toString().substring(0, 10)}',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ],
                ),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.yellow[700]!),
                  ),
                ),
              ),
              SizedBox(height: 20),
              DropdownButton<int>(
                value: int.tryParse(_nombrePlacesController.text) ?? 2,
                onChanged: (int? newValue) {
                  setState(() {
                    _nombrePlacesController.text = newValue.toString();
                  });
                },
                items: [2, 3, 4, 5].map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(
                      '$value places',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {}, // Utilisez onTap pour éviter le changement de couleur lors de la sélection
                  );
                }).toList(),
                hint: Text('Nombre de places', style: TextStyle(color: Colors.grey[600])),
                dropdownColor: Colors.black,
              ),
              SizedBox(height: 20),
              DropdownButton<String>(
                value: _selectedTransmission,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedTransmission = newValue;
                  });
                },
                items: ['Automatique', 'Manuelle'].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {}, // Utilisez onTap pour éviter le changement de couleur lors de la sélection
                  );
                }).toList(),
                hint: Text('Transmission', style: TextStyle(color: Colors.grey[600])),
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
                          builder: (context) => p4(
                            marque: widget.marque,
                            modele: widget.modele,
                            version: widget.version,
                            puissance: widget.puissance,
                            carburant: widget.carburant,
                            motorisation: widget.motorisation,
                            dateFabrication: _selectedDate.toString().substring(0, 10),
                            nombrePlaces: _nombrePlacesController.text,
                            transmission: _selectedTransmission ?? '', userId: widget.userId,
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
