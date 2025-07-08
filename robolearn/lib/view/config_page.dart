import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ConfigPage extends StatefulWidget {
  const ConfigPage({super.key});

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  bool isDarkMode = false;

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair da Conta'),
        content: const Text('Tem certeza que deseja sair da sua conta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _signOut();
            },
            child: const Text(
              'Sair',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao sair: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C7A8C),
      body: SafeArea(
        child: Column(
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
                    'Configurações',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            
            // Conteúdo das configurações
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
                      
                      // Botão Voltar
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Voltar',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 40),
                      
                      _buildConfigOption(
                        'Modo Escuro',
                        null,
                        trailing: Switch(
                          value: isDarkMode,
                          onChanged: (value) {
                            setState(() {
                              isDarkMode = value;
                            });
                          },
                          activeColor: const Color(0xFF2C7A8C),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      _buildConfigOption(
                        'Editar Perfil',
                        () {
                          Navigator.pushNamed(context, '/edit_profile');
                        },
                      ),
                      
                      const SizedBox(height: 20),
                      
                      _buildConfigOption(
                        'Notificações',
                        () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Funcionalidade em desenvolvimento'),
                            ),
                          );
                        },
                      ),
                      
                      const SizedBox(height: 40),
                      
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _showLogoutDialog,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Sair',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      
                      const Spacer(),
                      
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
                            _buildBottomNavItem(Icons.person, 'Perfil', false, () {
                              Navigator.pushNamed(context, '/profile');
                            }),
                            _buildBottomNavItem(Icons.settings, 'Config', true, () {}),
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

  Widget _buildConfigOption(String title, VoidCallback? onTap, {Widget? trailing}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: trailing ?? const Icon(Icons.chevron_right),
        onTap: onTap,
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