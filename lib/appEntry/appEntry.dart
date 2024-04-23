import 'package:flutter/material.dart';
import 'package:myfrontend/authentification/signup.dart';

class AppEntry extends StatefulWidget {
  @override
  _AppEntryState createState() => _AppEntryState();
}

class _AppEntryState extends State<AppEntry> {
  String? selectedOption;

  void _showModalBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          height: 200,
          child: ListView(
            children: [
              _buildOption('Client', Icons.person, 'client'),
              _buildOption('Seller', Icons.shopping_cart, 'seller'),
              _buildOption('Expert', Icons.engineering, 'expert'),
            ],
          ),
        );
      },
    ).then((value) {
      if (value != null) {
        setState(() {
          selectedOption = value;
        });
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SignUpPage(selectedOption: selectedOption!),
          ),
        );
      }
    });
  }

  ListTile _buildOption(String title, IconData icon, String value) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.amber,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: () {
        Navigator.pop(context, value);
      },
      tileColor: Colors.transparent,
      hoverColor: Colors.yellow[700],
      focusColor: Colors.yellow[700],
      selectedTileColor: Colors.yellow[700],
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/im2.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: isPortrait ? screenSize.height * 0.1 : screenSize.height * 0.05,
              bottom: screenSize.height * 0.03,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Car",
                      style: TextStyle(
                        color: Colors.yellow[700],
                        fontSize: isPortrait ? screenSize.width * 0.07 : screenSize.width * 0.05,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Trade",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isPortrait ? screenSize.width * 0.07 : screenSize.width * 0.05,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Text(
                  "Developped by Saeb",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isPortrait ? screenSize.width * 0.025 : screenSize.width * 0.015,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: screenSize.height * 0.04,
            left: 0,
            right: 0,
            child: Column(
              children: [
                SizedBox(height: screenSize.height * 0.01),
                ElevatedButton(
                  onPressed: _showModalBottomSheet,
                  child: Text(
                    "Let's Go!",
                    style: TextStyle(fontSize: screenSize.width * 0.04),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.grey[900], 
                    backgroundColor: Colors.amber,
                    padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.2, vertical: screenSize.height * 0.015),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(screenSize.width * 0.1),
                    ),
                  ),
                ),
                if (selectedOption != null)
                  Text(
                    'Selected option: $selectedOption',
                    style: TextStyle(color: Colors.white),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
