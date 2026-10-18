import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/quiz_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/user_provider.dart';
import '../utils/responsive_util.dart';
import '../widgets/custom_button.dart';
import 'quiz_screen.dart';
import 'start_screen.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final quizProvider = Provider.of<QuizProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    bool isLargeScreen =
        ResponsiveUtil.isTablet(context) || ResponsiveUtil.isDesktop(context);
    double containerWidth =
        isLargeScreen ? 500 : ResponsiveUtil.width(context, 0.9);

    int score = quizProvider.score;
    String feedbackMessage;
    IconData feedbackIcon;
    Color feedbackColor;

    if (score >= 80) {
      feedbackMessage = 'Luar Biasa!';
      feedbackIcon = Icons.stars_rounded;
      feedbackColor = Colors.amber;
    } else if (score >= 60) {
      feedbackMessage = 'Bagus Sekali!';
      feedbackIcon = Icons.thumb_up_rounded;
      feedbackColor = Colors.green;
    } else {
      feedbackMessage = 'Jangan Menyerah, Coba Lagi!';
      feedbackIcon = Icons.sentiment_dissatisfied_rounded;
      feedbackColor = Colors.orangeAccent;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil Kuis'),
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
            width: containerWidth,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    feedbackIcon,
                    size: 100,
                    color: feedbackColor,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    feedbackMessage,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Kerja bagus, ${userProvider.userName}!',
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 30),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          const Text(
                            'Skor Akhir Kamu',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '$score / 100',
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  CustomButton(
                    text: 'ULANGI KUIS',
                    onPressed: () {
                      quizProvider.resetQuiz();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const QuizScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 15),
                  OutlinedButton(
                    onPressed: () {
                      quizProvider.resetQuiz();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const StartScreen(),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text('KEMBALI KE Halaman Awal'),
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
