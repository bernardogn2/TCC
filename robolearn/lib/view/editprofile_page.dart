import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  
  String selectedAvatar = 'assets/imgs/avatar1.png';
  bool isLoading = false;
  bool isLoadingData = true;

  final List<String> avatarOptions = [
    'assets/imgs/avatar1.png',
    'assets/imgs/avatar2.png',
    'assets/imgs/avatar3.png',
  ];

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
            nameController.text = doc.get('name') ?? '';
            emailController.text = doc.get('email') ?? '';
            selectedAvatar = doc.get('avatar') ?? 'assets/imgs/avatar1.png';
            isLoadingData = false;
          });
        }
      }
    } catch (e) {
      print('Erro ao carregar dados: $e');
      setState(() {
        isLoadingData = false;
      });
    }
  }

  void _updateProfile() async {
    if (nameController.text.trim().isEmpty) {
      _showErrorDialog('Nome de usuário é obrigatório');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Atualizar dados no Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'name': nameController.text.trim(),
          'avatar': selectedAvatar,
        });

        // Atualizar senha se fornecida
        if (newPasswordController.text.isNotEmpty) {
          if (newPasswordController.text.length < 6) {
            _showErrorDialog('A nova senha deve ter pelo menos 6 caracteres');
            setState(() {
              isLoading = false;
            });
            return;
          }
          await user.updatePassword(newPasswordController.text);
        }

        setState(() {
          isLoading = false;
        });

        _showSuccessDialog();
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      
      String errorMessage = 'Erro ao atualizar perfil';
      if (e.toString().contains('requires-recent-login')) {
        errorMessage = 'Para alterar a senha, faça login novamente';
      }
      
      _showErrorDialog(errorMessage);
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Erro'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Ok'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sucesso'),
        content: const Text('Perfil atualizado com sucesso!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Volta para a tela anterior
            },
            child: const Text('Ok'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C7A8C),
      body: SafeArea(
        child: isLoadingData
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
                          'Editar Perfil',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Conteúdo da edição
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
                      child: SingleChildScrollView(
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
                            
                            const SizedBox(height: 30),
                            
                            // Título Avatares
                            const Text(
                              'Avatares',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            
                            const SizedBox(height: 20),
                            
                            // Grid de avatares
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: avatarOptions.asMap().entries.map((entry) {
                                int index = entry.key;
                                String avatar = entry.value;
                                bool isSelected = selectedAvatar == avatar;
                                
                                return Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedAvatar = avatar;
                                        });
                                      },
                                      child: Container(
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          color: Colors.lightBlueAccent,
                                          borderRadius: BorderRadius.circular(15),
                                          border: isSelected
                                              ? Border.all(color: Colors.blue, width: 3)
                                              : Border.all(color: Colors.grey.shade300, width: 1),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(15),
                                          child: Image.asset(
                                            avatar,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              print('Erro ao carregar imagem: $avatar - $error');
                                              return Container(
                                                color: Colors.grey.shade300,
                                                child: Icon(
                                                  Icons.person,
                                                  size: 40,
                                                  color: Colors.grey.shade600,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    // Checkbox
                                    Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(3),
                                        color: isSelected ? Colors.blue : Colors.white,
                                      ),
                                      child: isSelected
                                          ? const Icon(
                                              Icons.check,
                                              size: 16,
                                              color: Colors.white,
                                            )
                                          : null,
                                    ),
                                    const SizedBox(height: 5),
                                    // Label do avatar
                                    Text(
                                      'Avatar ${index + 1}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                            
                            const SizedBox(height: 40),
                            
                            // Campos de texto
                            TextField(
                              controller: nameController,
                              decoration: InputDecoration(
                                labelText: 'Nome de usuário',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                filled: true,
                                fillColor: Colors.grey.shade100,
                              ),
                            ),
                            
                            const SizedBox(height: 20),
                            
                            TextField(
                              controller: emailController,
                              enabled: false, // E-mail não pode ser alterado
                              decoration: InputDecoration(
                                labelText: 'e-mail',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                filled: true,
                                fillColor: Colors.grey.shade300,
                              ),
                            ),
                            
                            const SizedBox(height: 20),
                            
                            TextField(
                              controller: passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: 'Senha atual (opcional)',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                filled: true,
                                fillColor: Colors.grey.shade100,
                              ),
                            ),
                            
                            const SizedBox(height: 20),
                            
                            TextField(
                              controller: newPasswordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: 'Nova Senha (opcional)',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                filled: true,
                                fillColor: Colors.grey.shade100,
                              ),
                            ),
                            
                            const SizedBox(height: 40),
                            
                            // Botão Confirmar Alterações
                            Container(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: isLoading ? null : _updateProfile,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  padding: const EdgeInsets.symmetric(vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                child: isLoading
                                    ? const CircularProgressIndicator(color: Colors.white)
                                    : const Text(
                                        'Confirmar Alterações',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                            
                            const SizedBox(height: 20),
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

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    newPasswordController.dispose();
    super.dispose();
  }
}