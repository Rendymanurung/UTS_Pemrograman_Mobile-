import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/quiz_provider.dart';
import '../providers/user_provider.dart';
import '../theme/app_theme.dart';
import '../utils/responsive_util.dart';
import '../widgets/custom_button.dart';
import 'start_screen.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _scoreController;
  late AnimationController _pulseController;

  late Animation<double> _mainFade;
  late Animation<Offset> _mainSlide;
  late Animation<double> _scoreScale;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();

    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();

    _scoreController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    Future.delayed(const Duration(milliseconds: 500),
        () => _scoreController.forward());

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _mainFade =
        CurvedAnimation(parent: _mainController, curve: Curves.easeOut);
    _mainSlide = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _mainController, curve: Curves.easeOut));

    _scoreScale = CurvedAnimation(
      parent: _scoreController,
      curve: Curves.elasticOut,
    );

    _pulseAnim = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _mainController.dispose();
    _scoreController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final quizProvider =
        Provider.of<QuizProvider>(context, listen: false);
    final userProvider =
        Provider.of<UserProvider>(context, listen: false);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isLargeScreen =
        ResponsiveUtil.isTablet(context) || ResponsiveUtil.isDesktop(context);
    final containerWidth =
        isLargeScreen ? 500.0 : ResponsiveUtil.width(context, 0.9);

    final score = quizProvider.score;
    final total = quizProvider.questions.length * 20;
    final percentage = (score / total * 100).round();

    final _ResultConfig config = _getConfig(score);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? AppTheme.darkBgGradient
              : const LinearGradient(
                  colors: [
                    Color(0xFFEDE9FE),
                    Color(0xFFFDF4FF),
                    Color(0xFFEDE9FE),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: SizedBox(
                width: containerWidth,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: FadeTransition(
                    opacity: _mainFade,
                    child: SlideTransition(
                      position: _mainSlide,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 20),

                          // === TROPHY / EMOJI ===
                          AnimatedBuilder(
                            animation: _pulseAnim,
                            builder: (context, child) => Transform.scale(
                              scale: _pulseAnim.value,
                              child: child,
                            ),
                            child: Container(
                              width: 130,
                              height: 130,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: config.gradientColors,
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        config.gradientColors[0].withValues(alpha: 0.5),
                                    blurRadius: 35,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  config.emoji,
                                  style: const TextStyle(fontSize: 60),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // === FEEDBACK TEXT ===
                          Text(
                            config.title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? AppTheme.textLight
                                  : AppTheme.textDark,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Terima kasih telah bermain, ${userProvider.userName}!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: isDark
                                  ? AppTheme.subtitleLight
                                  : AppTheme.subtitleDark,
                              fontFamily: 'Poppins',
                            ),
                          ),

                          const SizedBox(height: 32),

                          // === SCORE CARD ===
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(28),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppTheme.darkCard
                                  : Colors.white.withValues(alpha: 0.95),
                              borderRadius: BorderRadius.circular(28),
                              border: Border.all(
                                  color: AppTheme.primaryColor
                                      .withValues(alpha: 0.2)),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.primaryColor
                                      .withValues(alpha: 0.1),
                                  blurRadius: 24,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'Skor Akhir Kamu',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: isDark
                                        ? AppTheme.subtitleLight
                                        : AppTheme.subtitleDark,
                                    fontFamily: 'Poppins',
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ScaleTransition(
                                  scale: _scoreScale,
                                  child: ShaderMask(
                                    shaderCallback: (bounds) =>
                                        LinearGradient(
                                      colors: config.gradientColors,
                                    ).createShader(bounds),
                                    child: Text(
                                      '$score',
                                      style: const TextStyle(
                                        fontSize: 72,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                        fontFamily: 'Poppins',
                                        height: 1,
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  'dari $total poin',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: isDark
                                        ? AppTheme.subtitleLight
                                        : AppTheme.subtitleDark,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // Progress bar
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: TweenAnimationBuilder<double>(
                                    tween: Tween<double>(
                                        begin: 0, end: score / total),
                                    duration: const Duration(milliseconds: 900),
                                    curve: Curves.easeInOut,
                                    builder: (context, val, _) =>
                                        LinearProgressIndicator(
                                      value: val,
                                      minHeight: 10,
                                      backgroundColor: isDark
                                          ? AppTheme.darkSurface
                                          : AppTheme.primaryColor
                                              .withValues(alpha: 0.1),
                                      valueColor:
                                          AlwaysStoppedAnimation<Color>(
                                              config.gradientColors[0]),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '$percentage% benar',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: config.gradientColors[0],
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // === STATS ROW ===
                          _buildStatRow(
                              quizProvider.score ~/ 20,
                              quizProvider.questions.length,
                              isDark),

                          const SizedBox(height: 30),

                          CustomButton(
                            text: 'MAIN LAGI',
                            onPressed: () {
                              quizProvider.resetQuiz();
                              Navigator.pushReplacement(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (_, a, __) =>
                                      const StartScreen(),
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
                            },
                            icon: Icons.replay_rounded,
                          ),

                          const SizedBox(height: 28),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(int correct, int total, bool isDark) {
    final wrong = total - correct;
    return Row(
      children: [
        Expanded(
          child: _StatBox(
            icon: Icons.check_circle_rounded,
            value: '$correct',
            label: 'Benar',
            color: AppTheme.correctColor,
            isDark: isDark,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatBox(
            icon: Icons.cancel_rounded,
            value: '$wrong',
            label: 'Salah',
            color: AppTheme.wrongColor,
            isDark: isDark,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatBox(
            icon: Icons.quiz_rounded,
            value: '$total',
            label: 'Total',
            color: AppTheme.primaryColor,
            isDark: isDark,
          ),
        ),
      ],
    );
  }

  _ResultConfig _getConfig(int score) {
    if (score >= 80) {
      return _ResultConfig(
        title: 'Luar Biasa! 🎉',
        emoji: '🏆',
        gradientColors: [AppTheme.goldColor, const Color(0xFFFCD34D)],
      );
    } else if (score >= 60) {
      return _ResultConfig(
        title: 'Kerja Bagus!',
        emoji: '🌟',
        gradientColors: [AppTheme.primaryColor, AppTheme.accentColor],
      );
    } else if (score >= 40) {
      return _ResultConfig(
        title: 'Lumayan Nih!',
        emoji: '💪',
        gradientColors: [const Color(0xFF06B6D4), const Color(0xFF3B82F6)],
      );
    } else {
      return _ResultConfig(
        title: 'Jangan Menyerah!',
        emoji: '🔥',
        gradientColors: [AppTheme.accentColor, const Color(0xFFF97316)],
      );
    }
  }
}

class _ResultConfig {
  final String title;
  final String emoji;
  final List<Color> gradientColors;

  _ResultConfig({
    required this.title,
    required this.emoji,
    required this.gradientColors,
  });
}

class _StatBox extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  final bool isDark;

  const _StatBox({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkCard : Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.25)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 26),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
              fontFamily: 'Poppins',
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? AppTheme.subtitleLight : AppTheme.subtitleDark,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }
}