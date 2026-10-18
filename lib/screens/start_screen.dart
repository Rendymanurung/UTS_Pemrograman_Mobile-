import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/quiz_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/user_provider.dart';
import '../utils/responsive_util.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import 'quiz_screen.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  final TextEditingController _nameController = TextEditingController();

  void _startQuiz() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nama tidak boleh kosong!'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    Provider.of<UserProvider>(context, listen: false)
        .setUserName(_nameController.text.trim());

    Provider.of<QuizProvider>(context, listen: false).resetQuiz();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const QuizScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    // Mengecek apakah perangkat adalah tablet/desktop untuk membatasi lebar form
    bool isLargeScreen =
        ResponsiveUtil.isTablet(context) || ResponsiveUtil.isDesktop(context);
    double formWidth = isLargeScreen ? 500 : ResponsiveUtil.width(context, 0.9);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () {
              themeProvider.toggleTheme(!themeProvider.isDarkMode);
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            width: formWidth,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.quiz_rounded,
                    size: 120,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Aplikasi Kuis',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Uji pengetahuan anime kamu sekarang!',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 50),
                  CustomTextField(
                    controller: _nameController,
                    hintText: 'Masukkan Nama Anda',
                    icon: Icons.person,
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    text: 'MULAI KUIS',
                    onPressed: _startQuiz,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
