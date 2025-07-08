import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:robolearn/view/class_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  String userName = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      
      if (doc.exists) {
        setState(() {
          userName = doc.get('name') ?? 'Usuário';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C7A8C),
      body: _currentIndex == 0 ? _buildHomeContent() : _buildOtherContent(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          
          // Nav-bar
          switch (index) {
            case 0:
              // Home
              break;
            case 1:
              Navigator.pushNamed(context, '/exercise');
              break;
            case 2:
              Navigator.pushNamed(context, '/profile');
              break;
            case 3:
              Navigator.pushNamed(context, '/config');
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

  Widget _buildHomeContent() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Image.asset(
                    'assets/imgs/RoboLearnLogo.png',
                    height: 60,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Mapa de Progresso',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            
            // Grid de módulos
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                children: [
                  _buildModuleCard(
                    icon: Icons.electrical_services,
                    title: 'Fundamentos\nda Eletrônica',
                    color: Colors.orange,
                    onTap: () => _navigateToClass('fundamentos'),
                  ),
                  _buildModuleCard(
                    icon: Icons.memory,
                    title: 'Componentes\nEletrônicos',
                    color: Colors.pink,
                    onTap: () => Navigator.pushNamed(context, '/dictionary'),
                  ),
                  _buildModuleCard(
                    icon: Icons.computer,
                    title: 'Simulação\ncom Arduino',
                    color: Colors.green,
                    onTap: () => _navigateToClass('arduino'),
                  ),
                  _buildModuleCard(
                    icon: Icons.cable,
                    title: 'Circuitos',
                    color: Colors.red,
                    onTap: () => _navigateToClass('circuitos'),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Botão de Desafio
            Container(
              width: double.infinity,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.purple,
                borderRadius: BorderRadius.circular(20),
              ),
              child: InkWell(
                onTap: () => Navigator.pushNamed(context, '/exercise'),
                borderRadius: BorderRadius.circular(20),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.help_outline,
                        color: Colors.white,
                        size: 32,
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Desafio',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToClass(String moduleType) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClassPage(moduleType: moduleType),
      ),
    );
  }

  Widget _buildModuleCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 40,
              ),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtherContent() {
    return const Center(
      child: Text(
        'Conteúdo de outras abas',
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }
}