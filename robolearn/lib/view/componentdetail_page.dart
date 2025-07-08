import 'package:flutter/material.dart';

class ComponentDetailPage extends StatefulWidget {
  final String name;
  final String description;
  final String imagePath;
  final Color color;

  const ComponentDetailPage({
    super.key,
    required this.name,
    required this.description,
    required this.imagePath,
    required this.color,
  });

  @override
  State<ComponentDetailPage> createState() => _ComponentDetailPageState();
}

class _ComponentDetailPageState extends State<ComponentDetailPage> {
  int _currentIndex = 0;

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
        title: Text(
          widget.name,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Componente visual
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Image.asset(
                    widget.imagePath,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.help_outline,
                        size: 80,
                        color: widget.color,
                      );
                    },
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Nome do componente
              Text(
                widget.name,
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Descrição
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF5BC0DE),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  widget.description,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              
              const Spacer(),
              
              // Botão de simulação (se aplicável)
              if (widget.name == 'Capacitor')
                Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: InkWell(
                    onTap: () {
                      // Navegar para simulação
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Funcionalidade de simulação em desenvolvimento'),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(15),
                    child: const Center(
                      child: Text(
                        'Simular Componente',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
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
}