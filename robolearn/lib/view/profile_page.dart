import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userName = '';
  String userEmail = '';
  int userXp = 0;
  int completedLessons = 0;
  int userLevel = 1;
  String selectedAvatar = 'assets/imgs/avatar0.png';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        
        if (doc.exists) {
          setState(() {
            userName = doc.get('name') ?? 'Usuário';
            userEmail = doc.get('email') ?? '';
            userXp = doc.get('xp') ?? 0;
            completedLessons = doc.get('completedLessons') ?? 0;
            userLevel = doc.get('level') ?? 1;
            selectedAvatar = doc.get('avatar') ?? 'assets/imgs/avatar0.png';
            isLoading = false;
          });
        }
      }
    } catch (e) {
      print('Erro ao carregar dados: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Calcula o nível baseado no XP
  int _calculateLevel(int xp) {
    return (xp / 100).floor() + 1;
  }

  // Calcula XP necessário para próximo nível
  int _getXpForNextLevel(int currentXp) {
    int currentLevel = _calculateLevel(currentXp);
    return currentLevel * 100;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C7A8C),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.white))
            : Column(
                children: [
                  // Header com logo do robô
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
                          'Perfil',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Conteúdo do perfil
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            
                            // Avatar do usuário
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: Colors.lightBlueAccent,
                                shape: BoxShape.circle,
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  selectedAvatar,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.person,
                                      size: 60,
                                      color: Colors.white,
                                    );
                                  },
                                ),
                              ),
                            ),
                            
                            const SizedBox(height: 20),
                            
                            // Nome e nível
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      userName,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      'Nível ${_calculateLevel(userXp)}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.emoji_events,
                                      color: Colors.amber,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      '$userXp XP',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.amber,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 30),
                            
                            // Estatísticas
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: Colors.lightBlueAccent,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          '$completedLessons',
                                          style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        const Text(
                                          'Dias seguidos',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: Colors.lightBlueAccent,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          '${_getXpForNextLevel(userXp)}',
                                          style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        const Text(
                                          'AMIGOS',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            
                            const Spacer(),
                            
                            // Bottom Navigation
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  _buildBottomNavItem(Icons.home, 'Home', false, () {
                                    Navigator.pushReplacementNamed(context, '/home');
                                  }),
                                  _buildBottomNavItem(Icons.quiz, 'Atividades', false, () {
                                    Navigator.pushNamed(context, '/exercise');
                                  }),
                                  _buildBottomNavItem(Icons.person, 'Perfil', true, () {}),
                                  _buildBottomNavItem(Icons.settings, 'Config', false, () {
                                    Navigator.pushNamed(context, '/config');
                                  }),
                                ],
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

  Widget _buildBottomNavItem(IconData icon, String label, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? const Color(0xFF2C7A8C) : Colors.grey,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? const Color(0xFF2C7A8C) : Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}