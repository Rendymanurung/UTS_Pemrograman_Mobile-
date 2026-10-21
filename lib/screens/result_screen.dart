import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/quiz_provider.dart';
import '../providers/user_provider.dart';
import '../utils/responsive_util.dart';
import '../widgets/custom_button.dart';
import 'start_screen.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final quizProvider = Provider.of<QuizProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);


    final isLargeScreen = ResponsiveUtil.isTablet(context) || ResponsiveUtil.isDesktop(context);
    final containerWidth = isLargeScreen ? 500.0 : ResponsiveUtil.width(context, 0.9);


    String feedbackMessage;
    if (quizProvider.score >= 80) {
      feedbackMessage = 'Luar Biasa!';
    } else if (quizProvider.score >= 60) {
      feedbackMessage = 'Kerja Bagus!';
    } else {
      feedbackMessage = 'Jangan Menyerah, Coba Lagi!';
    }

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            width: containerWidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.emoji_events_rounded,
                  size: 150,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 30),
                Text(
                  feedbackMessage,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Terima kasih telah bermain, ${userProvider.userName}.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 40),
                Text(
                  'Skor Akhir Kamu',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '${quizProvider.score}',
                  style: TextStyle(
                    fontSize: 60,
                    fontWeight: FontWeight.w900,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 50),
                CustomButton(
                  text: 'ULANGI KUIS',
                  onPressed: () {

                    quizProvider.resetQuiz();

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const StartScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}