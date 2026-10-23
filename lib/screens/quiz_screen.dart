import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/quiz_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/user_provider.dart';
import '../theme/app_theme.dart';
import '../utils/responsive_util.dart';
import '../widgets/option_card.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _cardController;
  late Animation<double> _cardFade;
  late Animation<Offset> _cardSlide;
  int _lastIndex = -1;

  @override
  void initState() {
    super.initState();
    _cardController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _cardFade = CurvedAnimation(parent: _cardController, curve: Curves.easeOut);
    _cardSlide = Tween<Offset>(
      begin: const Offset(0.05, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _cardController, curve: Curves.easeOut));
    _cardController.forward();

    // Start Timer on Screen Init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final quizProvider = Provider.of<QuizProvider>(context, listen: false);
      if (!quizProvider.hasAnswered && !quizProvider.isQuizFinished) {
        quizProvider.startTimer();
      }
    });
  }

  @override
  void dispose() {
    _cardController.dispose();
    super.dispose();
  }

  void _animateCard() {
    _cardController.reset();
    _cardController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final quizProvider = Provider.of<QuizProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    if (quizProvider.currentIndex != _lastIndex) {
      _lastIndex = quizProvider.currentIndex;
      WidgetsBinding.instance.addPostFrameCallback((_) => _animateCard());
    }

    final isDark = themeProvider.isDarkMode;
    final q = quizProvider.currentQuestion;
    final total = quizProvider.questions.length;
    final current = quizProvider.currentIndex;
    final progress = (current + 1) / total;
    final isLargeScreen =
        ResponsiveUtil.isTablet(context) || ResponsiveUtil.isDesktop(context);
    final containerWidth =
        isLargeScreen ? 600.0 : ResponsiveUtil.width(context, 1.0);

    const labels = ['A', 'B', 'C', 'D'];

    return Scaffold(
      backgroundColor: isDark ? AppTheme.nearBlack : AppTheme.lightBg,
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: containerWidth,
            child: Column(
              children: [
                // === TOP BAR ===
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Row(
                    children: [
                      // User Info
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppTheme.spotifyGreen,
                              ),
                              child: Center(
                                child: Text(
                                  userProvider.userName.isNotEmpty
                                      ? userProvider.userName[0].toUpperCase()
                                      : '?',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userProvider.userName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    color: isDark
                                        ? AppTheme.textBase
                                        : AppTheme.textDark,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                Text(
                                  'SOAL ${current + 1} DARI $total',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isDark
                                        ? AppTheme.textSilver
                                        : AppTheme.subtitleDark,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Countdown Timer Badge
                      _TimerChip(
                        seconds: quizProvider.remainingSeconds,
                        isDark: isDark,
                      ),
                      const SizedBox(width: 8),

                      // Score Chip
                      _ScoreChip(score: quizProvider.score, isDark: isDark),
                      const SizedBox(width: 8),

                      // Theme Toggle Button
                      GestureDetector(
                        onTap: () =>
                            themeProvider.toggleTheme(!themeProvider.isDarkMode),
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDark
                                ? AppTheme.darkSurface
                                : AppTheme.lightSurface,
                            border: Border.all(
                              color: isDark
                                  ? AppTheme.borderGray
                                  : AppTheme.lightBorder,
                            ),
                          ),
                          child: Icon(
                            isDark
                                ? Icons.light_mode_outlined
                                : Icons.dark_mode_outlined,
                            color: isDark ? AppTheme.textBase : AppTheme.textDark,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // === PROGRESS BAR ===
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0, end: progress),
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                      builder: (context, value, _) => LinearProgressIndicator(
                        value: value,
                        backgroundColor: isDark
                            ? AppTheme.darkCard
                            : AppTheme.lightBorder,
                        minHeight: 6,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppTheme.spotifyGreen,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // === SCROLLABLE CONTENT ===
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: FadeTransition(
                      opacity: _cardFade,
                      child: SlideTransition(
                        position: _cardSlide,
                        child: Column(
                          children: [
                            // Timeout Warning Banner
                            if (quizProvider.isTimeUp) ...[
                              Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 10),
                                decoration: BoxDecoration(
                                  color: AppTheme.negativeRed.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: AppTheme.negativeRed),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.timer_off_outlined,
                                        color: AppTheme.negativeRed, size: 20),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'Waktu habis! Silakan lanjut ke soal berikutnya.',
                                        style: TextStyle(
                                          color: isDark
                                              ? AppTheme.textBase
                                              : AppTheme.textDark,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],

                            // === QUESTION IMAGE ===
                            if (q.imagePath != null)
                              _QuestionImage(
                                imagePath: q.imagePath!,
                                isDark: isDark,
                              ),

                            const SizedBox(height: 12),

                            // === QUESTION TEXT CARD ===
                            _QuestionCard(
                              text: q.questionText,
                              number: current + 1,
                              isDark: isDark,
                            ),

                            const SizedBox(height: 14),

                            // === OPTIONS ===
                            ...List.generate(q.options.length, (i) {
                              OptionState state = OptionState.normal;
                              if (quizProvider.hasAnswered) {
                                if (i == q.correctAnswerIndex) {
                                  state = OptionState.correct;
                                } else if (i ==
                                        quizProvider.selectedAnswerIndex &&
                                    i != q.correctAnswerIndex) {
                                  state = OptionState.wrong;
                                }
                              }
                              return OptionCard(
                                optionText: q.options[i],
                                optionLabel: labels[i],
                                state: state,
                                onTap: () {
                                  quizProvider.answerQuestion(i);
                                },
                              );
                            }),

                            const SizedBox(height: 16),

                            // === NEXT BUTTON ===
                            if (quizProvider.hasAnswered)
                              _NextButton(
                                isLast: current == total - 1,
                                onNext: () {
                                  quizProvider.nextQuestion();
                                  if (quizProvider.isQuizFinished) {
                                    Navigator.pushReplacement(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (_, a, __) =>
                                            const ResultScreen(),
                                        transitionsBuilder:
                                            (_, animation, __, child) =>
                                                FadeTransition(
                                          opacity: animation,
                                          child: child,
                                        ),
                                        transitionDuration:
                                            const Duration(milliseconds: 400),
                                      ),
                                    );
                                  }
                                },
                              ),

                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Sub-widgets ──────────────────────────────────────────────────────────────

class _TimerChip extends StatelessWidget {
  final int seconds;
  final bool isDark;
  const _TimerChip({required this.seconds, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final bool isWarning = seconds <= 5;
    final Color color =
        isWarning ? AppTheme.negativeRed : AppTheme.spotifyGreen;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isWarning
            ? AppTheme.negativeRed.withValues(alpha: 0.15)
            : (isDark ? AppTheme.darkSurface : AppTheme.lightSurface),
        borderRadius: BorderRadius.circular(500),
        border: Border.all(
          color: isWarning
              ? AppTheme.negativeRed
              : (isDark ? AppTheme.borderGray : AppTheme.lightBorder),
          width: isWarning ? 1.5 : 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.timer_outlined,
            color: color,
            size: 15,
          ),
          const SizedBox(width: 4),
          Text(
            '${seconds}s',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 12,
              fontFamily: 'Poppins',
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _ScoreChip extends StatelessWidget {
  final int score;
  final bool isDark;
  const _ScoreChip({required this.score, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkSurface : AppTheme.lightSurface,
        borderRadius: BorderRadius.circular(500), // Pill Shape
        border: Border.all(
          color: isDark ? AppTheme.borderGray : AppTheme.lightBorder,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, color: AppTheme.spotifyGreen, size: 15),
          const SizedBox(width: 4),
          Text(
            '$score PTS',
            style: TextStyle(
              color: isDark ? AppTheme.textBase : AppTheme.textDark,
              fontWeight: FontWeight.w700,
              fontSize: 12,
              fontFamily: 'Poppins',
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuestionImage extends StatelessWidget {
  final String imagePath;
  final bool isDark;
  const _QuestionImage({required this.imagePath, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 185,
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkSurface : AppTheme.lightSurface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? AppTheme.borderGray : AppTheme.lightBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              imagePath,
              fit: BoxFit.cover,
              alignment: Alignment.center,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: isDark ? AppTheme.darkSurface : AppTheme.lightInputBg,
                  child: Icon(
                    Icons.broken_image_outlined,
                    color: isDark ? AppTheme.textSilver : AppTheme.subtitleDark,
                    size: 40,
                  ),
                );
              },
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 50,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.6),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.75),
                  borderRadius: BorderRadius.circular(500),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.image_rounded, color: AppTheme.spotifyGreen, size: 12),
                    SizedBox(width: 4),
                    Text(
                      'PETUNJUK GAMBAR',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Poppins',
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuestionCard extends StatelessWidget {
  final String text;
  final int number;
  final bool isDark;
  const _QuestionCard({
    required this.text,
    required this.number,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkSurface : AppTheme.lightSurface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? AppTheme.borderGray : AppTheme.lightBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: isDark ? AppTheme.midDark : AppTheme.lightBg,
              borderRadius: BorderRadius.circular(500),
              border: Border.all(
                color: isDark ? AppTheme.borderGray : AppTheme.lightBorder,
              ),
            ),
            child: Text(
              'PERTANYAAN 0$number',
              style: TextStyle(
                color: isDark ? AppTheme.textSilver : AppTheme.subtitleDark,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                fontFamily: 'Poppins',
                letterSpacing: 1.0,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? AppTheme.textBase : AppTheme.textDark,
              fontFamily: 'Poppins',
              height: 1.4,
            ),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }
}

class _NextButton extends StatelessWidget {
  final bool isLast;
  final VoidCallback onNext;
  const _NextButton({
    required this.isLast,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onNext,
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: AppTheme.spotifyGreen,
          borderRadius: BorderRadius.circular(500),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              (isLast ? 'Lihat Hasil Akhir' : 'Lanjut Soal Berikutnya').toUpperCase(),
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 14,
                letterSpacing: 1.5,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              isLast ? Icons.emoji_events_rounded : Icons.arrow_forward_rounded,
              color: Colors.black,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
