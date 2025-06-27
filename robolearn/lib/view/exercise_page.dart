import 'package:flutter/material.dart';

class ExercisePage extends StatefulWidget {
  @override
  _ExercisePageState createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Topo com logotipo
          Container(
            width: double.infinity,
            color: Color(0xFF3186A0),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            height: screenSize.height * 0.1,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/imgs/RoboLearnLogo.png',
                  width: 80,
                ),
              ],
            ),
          ),

          SizedBox(height: screenSize.height * 0.03),

          // Título
          Text(
            'Qual é o Capacitor?',
            style: TextStyle(
              fontFamily: 'Itim',
              fontSize: 24,
              fontWeight: FontWeight.normal,
            ),
          ),

          SizedBox(height: screenSize.height * 0.03),

          // Grade de opções
          Wrap(
            spacing: 30,
            runSpacing: 30,
            alignment: WrapAlignment.center,
            children: [
              _buildOption('assets/imgs/Capacitor.png', '1'),
              _buildOption('assets/imgs/Led.png', '2'),
              _buildOption('assets/imgs/Resistor.png', '3'),
              _buildOption('assets/imgs/Indutor.png', '4'),
            ],
          ),

          Spacer(),

          // Botão Confirmar
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF77FF00),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.black),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            ),
            child: Text(
              'Confirmar',
              style: TextStyle(
                fontFamily: 'Itim',
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),

          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildOption(String imagePath, String number) {
    return Stack(
      alignment: Alignment.topLeft,
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            color: Color(0xFF00C7FF),
            border: Border.all(color: Colors.black),
          ),
          child: Center(
            child: ClipOval(
              child: Image.asset(
                imagePath,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Container(
          width: 20,
          height: 20,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black),
          ),
          child: Text(
            number,
            style: TextStyle(fontSize: 12, fontFamily: 'Itim'),
          ),
        ),
      ],
    );
  }
}