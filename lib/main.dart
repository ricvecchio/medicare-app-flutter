import 'package:flutter/material.dart';
import 'screens/classification_medicine.dart';
import 'screens/list_medicine.dart';
import 'screens/add_medicine.dart';

void main() {
  runApp(MediCareApp());
}

class MediCareApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/home',
      routes: {
        '/home': (context) => Home(),
        '/classification-medicine': (context) => ClassificationMedicine(),
        '/list-medicine': (context) => ListMedicine(),
        '/add-medicine': (context) => AddMedicine(),
      },
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'images/logo-medicare.jpeg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: screenSize.height * 0.05,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/classification-medicine');
                },
                child: Text(
                  'Comece aqui!',
                  style: TextStyle(
                    fontSize: screenSize.width * 0.03,
                    color: Colors.black,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenSize.width * 0.06,
                    vertical: screenSize.height * 0.010,
                  ),
                  backgroundColor: Colors.transparent,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
