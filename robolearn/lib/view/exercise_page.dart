import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  int? selectedOption;
  bool showResult = false;
  bool isCorrect = false;
  bool isLoading = false;
  int currentQuestionIndex = 0;

  // Lista de questões
  final List<Map<String, dynamic>> questions = [
    {
      'question': 'Qual é o Capacitor?',
      'options': [
        {'index': 0, 'image': 'assets/imgs/Indutor.png', 'isCorrect': false},
        {'index': 1, 'image': 'assets/imgs/Capacitor.png', 'isCorrect': true},
        {'index': 2, 'image': 'assets/imgs/Led.png', 'isCorrect': false},
        {'index': 3, 'image': 'assets/imgs/Resistor.png', 'isCorrect': false},
      ],
      'points': 10,
    },
    {
      'question': 'Qual é o Resistor?',
      'options': [
        {'index': 0, 'image': 'assets/imgs/Capacitor.png', 'isCorrect': false},
        {'index': 1, 'image': 'assets/imgs/Led.png', 'isCorrect': false},
        {'index': 2, 'image': 'assets/imgs/Resistor.png', 'isCorrect': true},
        {'index': 3, 'image': 'assets/imgs/Indutor.png', 'isCorrect': false},
      ],
      'points': 10,
    },
    {
      'question': 'Qual é o LED?',
      'options': [
        {'index': 0, 'image': 'assets/imgs/Resistor.png', 'isCorrect': false},
        {'index': 1, 'image': 'assets/imgs/Indutor.png', 'isCorrect': false},
        {'index': 2, 'image': 'assets/imgs/Capacitor.png', 'isCorrect': false},
        {'index': 3, 'image': 'assets/imgs/Led.png', 'isCorrect': true},
      ],
      'points': 10,
    },
  ];

  Map<String, dynamic> get currentQuestion => questions[currentQuestionIndex];

  void _selectOption(int index) {
    if (showResult) return;
    
    setState(() {
      selectedOption = index;
    });
  }

  void _checkAnswer() async {
    if (selectedOption == null) return;

    setState(() {
      isLoading = true;
    });

    // Simula um pequeno delay para o processamento
    await Future.delayed(const Duration(milliseconds: 500));

    final correctOption = currentQuestion['options']
        .firstWhere((option) => option['isCorrect'] == true);
    
    setState(() {
      isCorrect = selectedOption == correctOption['index'];
      showResult = true;
      isLoading = false;
    });

    // Atualizar pontuação do usuário se acertou
    if (isCorrect) {
      await _updateUserScore();
    }
  }

  Future<void> _updateUserScore() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentReference userDoc = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid);
        
        await FirebaseFirestore.instance.runTransaction((transaction) async {
          DocumentSnapshot snapshot = await transaction.get(userDoc);
          
          if (snapshot.exists) {
            int currentXp = snapshot.get('xp') ?? 0;
            int completedActivities = snapshot.get('completedActivities') ?? 0;
            
            transaction.update(userDoc, {
              'xp': currentXp + currentQuestion['points'],
              'completedActivities': completedActivities + 1,
            });
          }
        });
      }
    } catch (e) {
      print('Erro ao atualizar pontuação: $e');
    }
  }

  void _continueToNext() {
    // Verificar se há mais questões
    if (currentQuestionIndex < questions.length - 1) {
      // Ir para a próxima questão
      setState(() {
        currentQuestionIndex++;
        selectedOption = null;
        showResult = false;
        isCorrect = false;
      });
    } else {
      // Todas as questões foram respondidas, mostrar tela de conclusão
      _showCompletionDialog();
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Parabéns!',
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Você completou todas as atividades!\nVoltando para a tela inicial...',
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o dialog
                Navigator.of(context).pop(); // Volta para a tela inicial
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _tryAgain() {
    setState(() {
      selectedOption = null;
      showResult = false;
      isCorrect = false;
    });
  }

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
          'Atividades (${currentQuestionIndex + 1}/${questions.length})',
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
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
                    const SizedBox(height: 20),
                    Text(
                      currentQuestion['question'],
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    // Indicador de progresso
                    LinearProgressIndicator(
                      value: (currentQuestionIndex + 1) / questions.length,
                      backgroundColor: Colors.white.withOpacity(0.3),
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Grid de opções
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  children: List.generate(
                    currentQuestion['options'].length,
                    (index) => _buildOptionCard(index),
                  ),
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Área de resultado/botão
              _buildBottomSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard(int index) {
    final option = currentQuestion['options'][index];
    bool isSelected = selectedOption == index;
    bool isCorrectOption = option['isCorrect'];
    
    Color backgroundColor = Colors.lightBlueAccent;
    Color numberColor = Colors.white;
    
    if (showResult && isSelected) {
      if (isCorrect) {
        backgroundColor = Colors.green;
      } else {
        backgroundColor = Colors.red;
      }
    }
    
    return GestureDetector(
      onTap: () => _selectOption(index),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: isSelected && !showResult
              ? Border.all(color: Colors.white, width: 3)
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Número da opção
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: showResult && isSelected && isCorrect
                    ? Colors.green[700]
                    : showResult && isSelected && !isCorrect
                        ? Colors.red[700]
                        : Colors.blue[700],
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    color: numberColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 10),
            
            // Imagem da opção
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    option['image'],
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.image_not_supported,
                        size: 40,
                        color: Colors.grey,
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSection() {
    if (showResult) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isCorrect ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Text(
              isCorrect 
                  ? 'Parabéns, você acertou!'
                  : 'Quase lá, opção incorreta!',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: isCorrect ? _continueToNext : _tryAgain,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: isCorrect ? Colors.green : Colors.red,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: Text(
                isCorrect 
                    ? (currentQuestionIndex < questions.length - 1 
                        ? 'Continuar' 
                        : 'Finalizar')
                    : 'Tentar novamente',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    }
    
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: selectedOption != null && !isLoading ? _checkAnswer : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          disabledBackgroundColor: Colors.grey,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
                'Confirmar',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}