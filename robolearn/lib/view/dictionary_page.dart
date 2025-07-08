import 'package:flutter/material.dart';
import 'package:robolearn/view/componentdetail_page.dart';

class DictionaryPage extends StatefulWidget {
  const DictionaryPage({super.key});

  @override
  State<DictionaryPage> createState() => _DictionaryPageState();
}

class _DictionaryPageState extends State<DictionaryPage> {
  int _currentIndex = 0;

  final List<Map<String, dynamic>> components = [
    {
      'name': 'Led',
      'imagePath': 'assets/imgs/Led.png',
      'color': Colors.red,
      'description': 'Diodo emissor de luz usado para indicação visual',
      'hasContent': true,
    },
    {
      'name': 'Capacitor',
      'imagePath': 'assets/imgs/Capacitor.png',
      'color': Colors.blue,
      'description': 'Componente que armazena energia elétrica',
      'hasContent': true,
    },
    {
      'name': 'Resistor',
      'imagePath': 'assets/imgs/Resistor.png',
      'color': Colors.brown,
      'description': 'Componente que limita a corrente elétrica',
      'hasContent': true,
    },
    {
      'name': 'Indutor',
      'imagePath': 'assets/imgs/Indutor.png',
      'color': Colors.purple,
      'description': 'Componente que armazena energia em campo magnético',
      'hasContent': true,
    },
    {
      'name': 'Potenciômetro',
      'imagePath': 'assets/imgs/Potenciometro.png',
      'color': Colors.green,
      'description': 'Resistor variável controlado manualmente',
      'hasContent': true,
    },
    {
      'name': 'Cristal',
      'imagePath': 'assets/imgs/Cristal.png',
      'color': Colors.grey,
      'description': 'Componente usado para gerar frequências precisas',
      'hasContent': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C7A8C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C7A8C),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Dicionário de Componentes',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Cabeçalho com ícone e título
              Container(
                padding: const EdgeInsets.all(20),
                child: const Column(
                  children: [
                    Icon(
                      Icons.menu_book,
                      size: 60,
                      color: Colors.white,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Componentes Eletrônicos',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Grid de componentes
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: 16, // 4x4 grid
                  itemBuilder: (context, index) {
                    if (index < components.length) {
                      final component = components[index];
                      return _buildComponentCard(
                        component['name'],
                        component['imagePath'],
                        component['color'],
                        component['hasContent'],
                        component['description'],
                      );
                    } else {
                      return _buildEmptyCard();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/home');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/exercise');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/profile');
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/config');
              break;
          }
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF2C7A8C),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.quiz),
            label: 'Atividades',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Config',
          ),
        ],
      ),
    );
  }

  Widget _buildComponentCard(String name, String imagePath, Color color, bool hasContent, String description) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: hasContent ? () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ComponentDetailPage(
                name: name,
                description: description,
                imagePath: imagePath,
                color: color,
              ),
            ),
          );
        } : null,
        borderRadius: BorderRadius.circular(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 30,
              height: 30,
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.help_outline,
                    color: color,
                    size: 30,
                  );
                },
              ),
            ),
            const SizedBox(height: 5),
            Text(
              name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Center(
        child: Text(
          'xxxx',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}