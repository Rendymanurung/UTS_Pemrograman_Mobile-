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
      duration: const Duration(milliseconds: 450),
    );
    _cardFade = CurvedAnimation(parent: _cardController, curve: Curves.easeOut);
    _cardSlide = Tween<Offset>(
      begin: const Offset(0.08, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _cardController, curve: Curves.easeOut));
    _cardController.forward();
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

    // Trigger animation when question changes
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

    // Option labels
    const labels = ['A', 'B', 'C', 'D'];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? AppTheme.darkBgGradient
              : const LinearGradient(
                  colors: [Color(0xFFEDE9FE), Color(0xFFFDF4FF), Color(0xFFEDE9FE)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
        ),
        child: SafeArea(
          child: Center(
            child: SizedBox(
              width: containerWidth,
              child: Column(
                children: [
                  // === APP BAR ===
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: Row(
                      children: [
                        // User info
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: AppTheme.primaryGradient,
                                ),
                                child: Center(
                                  child: Text(
                                    userProvider.userName.isNotEmpty
                                        ? userProvider.userName[0].toUpperCase()
                                        : '?',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
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
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: isDark
                                          ? AppTheme.textLight
                                          : AppTheme.textDark,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  Text(
                                    'Soal ${current + 1} dari $total',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isDark
                                          ? AppTheme.subtitleLight
                                          : AppTheme.subtitleDark,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Score chip
                        _ScoreChip(score: quizProvider.score),
                        const SizedBox(width: 8),
                        // Theme toggle
                        GestureDetector(
                          onTap: () =>
                              themeProvider.toggleTheme(!themeProvider.isDarkMode),
                          child: Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isDark
                                  ? AppTheme.darkCard
                                  : Colors.white.withValues(alpha: 0.9),
                              border: Border.all(
                                  color:
                                      AppTheme.primaryColor.withValues(alpha: 0.3)),
                            ),
                            child: Icon(
                              isDark
                                  ? Icons.light_mode_rounded
                                  : Icons.dark_mode_rounded,
                              color: AppTheme.primaryColor,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // === PROGRESS BAR ===
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: TweenAnimationBuilder<double>(
                            tween: Tween<double>(begin: 0, end: progress),
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                            builder: (context, value, _) =>
                                LinearProgressIndicator(
                              value: value,
                              backgroundColor: isDark
                                  ? AppTheme.darkCard
                                  : AppTheme.primaryColor.withValues(alpha: 0.12),
                              minHeight: 8,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                AppTheme.primaryColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(
                            total,
                            (i) => AnimatedContainer(
                              duration: const Duration(milliseconds: 400),
                              width: 28,
                              height: 6,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: i <= current
                                    ? AppTheme.primaryColor
                                    : isDark
                                        ? AppTheme.darkCard
                                        : AppTheme.primaryColor
                                            .withValues(alpha: 0.15),
                              ),
                            ),
                          ),
                        ),
                      ],
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
                              // === QUESTION IMAGE ===
                              if (q.imagePath != null)
                                _QuestionImage(imagePath: q.imagePath!, isDark: isDark),

                              const SizedBox(height: 14),

                              // === QUESTION TEXT CARD ===
                              _QuestionCard(
                                  text: q.questionText,
                                  number: current + 1,
                                  isDark: isDark),

                              const SizedBox(height: 16),

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
                                              const Duration(milliseconds: 500),
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
      ),
    );
  }
}

// ─── Sub-widgets ──────────────────────────────────────────────────────────────

class _ScoreChip extends StatelessWidget {
  final int score;
  const _ScoreChip({required this.score});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        gradient: AppTheme.goldGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.goldColor.withValues(alpha: 0.35),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, color: Colors.white, size: 16),
          const SizedBox(width: 5),
          Text(
            '$score',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
              fontFamily: 'Poppins',
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
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              imagePath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: isDark ? AppTheme.darkCard : Colors.grey[300],
                  child: const Center(
                    child: Icon(
                      Icons.broken_image_rounded,
                      color: Colors.grey,
                      size: 48,
                    ),
                  ),
                );
              },
            ),
            // Gradient overlay at bottom
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 60,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.55),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            // "Petunjuk" badge
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.image_rounded, color: Colors.white, size: 13),
                    SizedBox(width: 4),
                    Text(
                      'Petunjuk Visual',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
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
  const _QuestionCard(
      {required this.text, required this.number, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark
            ? AppTheme.darkCard
            : Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
            color: AppTheme.primaryColor.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withValues(alpha: 0.1),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question number badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Pertanyaan $number',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            text,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: isDark ? AppTheme.textLight : AppTheme.textDark,
              fontFamily: 'Poppins',
              height: 1.5,
            ),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }
}

class _NextButton extends StatefulWidget {
  final bool isLast;
  final VoidCallback onNext;
  const _NextButton({required this.isLast, required this.onNext});

  @override
  State<_NextButton> createState() => _NextButtonState();
}

class _NextButtonState extends State<_NextButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    )..forward();
    _anim = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _anim,
      child: GestureDetector(
        onTap: widget.onNext,
        child: Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            gradient: widget.isLast
                ? AppTheme.goldGradient
                : AppTheme.primaryGradient,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: (widget.isLast
                        ? AppTheme.goldColor
                        : AppTheme.primaryColor)
                    .withValues(alpha: 0.4),
                blurRadius: 18,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.isLast
                    ? Icons.emoji_events_rounded
                    : Icons.arrow_forward_rounded,
                color: Colors.white,
                size: 22,
              ),
              const SizedBox(width: 10),
              Text(
                widget.isLast ? 'LIHAT HASIL' : 'LANJUT',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  letterSpacing: 1.5,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
