import 'package:flutter/material.dart';

class ClassPage extends StatefulWidget {
  final String moduleType;
  
  const ClassPage({super.key, required this.moduleType});

  @override
  State<ClassPage> createState() => _ClassPageState();
}

class _ClassPageState extends State<ClassPage> {
  int _currentIndex = 0;
  bool _isVideoPlaying = false;

  Map<String, Map<String, dynamic>> moduleData = {
    'fundamentos': {
      'title': 'Fundamentos da Eletrônica',
      'moduleTitle': 'Módulo 1: Fundamentos da Eletrônica',
      'duration': '15 minutos',
      'description': 'Aprenda os conceitos básicos da eletrônica, incluindo corrente, tensão, resistência e as leis fundamentais.',
      'icon': Icons.electrical_services,
      'color': Colors.orange,
    },
    'circuitos': {
      'title': 'Circuitos Eletrônicos',
      'moduleTitle': 'Módulo 2: Circuitos Eletrônicos',
      'duration': '20 minutos',
      'description': 'Entenda como funcionam os circuitos em série e paralelo, análise de malhas e como calcular correntes e tensões.',
      'icon': Icons.cable,
      'color': Colors.red,
    },
    'arduino': {
      'title': 'Simulação com Arduino',
      'moduleTitle': 'Módulo 3: Simulação com Arduino',
      'duration': '25 minutos',
      'description': 'Aprenda a programar o Arduino e simular projetos eletrônicos.',
      'icon': Icons.computer,
      'color': Colors.green,
    },
  };

  @override
  Widget build(BuildContext context) {
    final currentModule = moduleData[widget.moduleType]!;
    
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
          'Aula',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Cabeçalho
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(
                      currentModule['icon'],
                      size: 60,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      currentModule['title'],
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Player de vídeo
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _isVideoPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                              size: 80,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 20),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 40),
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    currentModule['icon'],
                                    size: 40,
                                    color: currentModule['color'],
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    _getVideoContent(),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Controles do vídeo
                      Positioned(
                        bottom: 20,
                        left: 20,
                        right: 20,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    _isVideoPlaying = !_isVideoPlaying;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    _isVideoPlaying ? Icons.pause : Icons.play_arrow,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15),
                              const Expanded(
                                child: LinearProgressIndicator(
                                  value: 0.3,
                                  backgroundColor: Colors.grey,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                                ),
                              ),
                              const SizedBox(width: 15),
                              InkWell(
                                onTap: () {
                                  _showCompletionDialog();
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: const Text(
                                    'Concluir',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 20),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentModule['moduleTitle'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Duração: ${currentModule['duration']}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      currentModule['description'],
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
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

  String _getVideoContent() {
    switch (widget.moduleType) {
      case 'fundamentos':
        return 'Nesta aula você aprenderá sobre:\n• Corrente elétrica (I)\n• Tensão elétrica (V)\n• Resistência elétrica (R)\n• Potência elétrica (P = V × I)';
      case 'circuitos':
        return 'Nesta aula você aprenderá sobre:\n• Circuitos em série\n• Circuitos em paralelo\n• Análise de malhas\n• Divisores de tensão';
      case 'arduino':
        return 'Nesta aula você aprenderá sobre:\n• Programação básica Arduino\n• Entradas digitais e analógicas\n• Controle de LEDs e motores\n• Leitura de sensores\n• Projetos práticos';
      default:
        return 'Conteúdo da aula em desenvolvimento...';
    }
  }

  void _showCompletionDialog() {
    final currentModule = moduleData[widget.moduleType]!;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                currentModule['icon'],
                color: currentModule['color'],
              ),
              const SizedBox(width: 10),
              const Text('Parabéns!'),
            ],
          ),
          content: Text('Você concluiu a aula "${currentModule['title']}" com sucesso!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}