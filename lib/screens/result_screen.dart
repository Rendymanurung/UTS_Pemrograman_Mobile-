import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/quiz_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/user_provider.dart';
import '../theme/app_theme.dart';
import '../utils/responsive_util.dart';
import '../widgets/custom_button.dart';
import '../widgets/gothic_l_badge.dart';
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

  late Animation<double> _mainFade;
  late Animation<Offset> _mainSlide;
  late Animation<double> _scoreScale;

  @override
  void initState() {
    super.initState();

    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();

    _scoreController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    Future.delayed(const Duration(milliseconds: 300),
        () => _scoreController.forward());

    _mainFade =
        CurvedAnimation(parent: _mainController, curve: Curves.easeOut);
    _mainSlide = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _mainController, curve: Curves.easeOut));

    _scoreScale = CurvedAnimation(
      parent: _scoreController,
      curve: Curves.elasticOut,
    );
  }

  @override
  void dispose() {
    _mainController.dispose();
    _scoreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final quizProvider =
        Provider.of<QuizProvider>(context, listen: false);
    final userProvider =
        Provider.of<UserProvider>(context, listen: false);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final isLargeScreen =
        ResponsiveUtil.isTablet(context) || ResponsiveUtil.isDesktop(context);
    final containerWidth =
        isLargeScreen ? 500.0 : ResponsiveUtil.width(context, 0.9);

    final score = quizProvider.score;
    final total = quizProvider.questions.length * 20;
    final percentage = (score / total * 100).round();

    final _ResultConfig config = _getConfig(score);

    return Scaffold(
      backgroundColor: isDark ? AppTheme.nearBlack : AppTheme.lightBg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: SizedBox(
              width: containerWidth,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: FadeTransition(
                  opacity: _mainFade,
                  child: SlideTransition(
                    position: _mainSlide,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),

                        // === GOTHIC "L" LOGO BADGE WITH CUSTOM FRAME ===
                        GothicLBadge(
                          size: 110,
                          isDark: isDark,
                        ),

                        const SizedBox(height: 24),

                        // === FEEDBACK TEXT ===
                        Text(
                          config.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? AppTheme.textBase
                                : AppTheme.textDark,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Terima kasih telah berpartisipasi, ${userProvider.userName}!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark
                                ? AppTheme.textSilver
                                : AppTheme.subtitleDark,
                            fontFamily: 'Poppins',
                          ),
                        ),

                        const SizedBox(height: 28),

                        // === SCORE CARD ===
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppTheme.darkSurface
                                : AppTheme.lightSurface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isDark
                                  ? AppTheme.borderGray
                                  : AppTheme.lightBorder,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    .withValues(alpha: isDark ? 0.4 : 0.05),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Text(
                                'SKOR AKHIR KAMU',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: isDark
                                      ? AppTheme.textSilver
                                      : AppTheme.subtitleDark,
                                  fontFamily: 'Poppins',
                                  letterSpacing: 1.4,
                                ),
                              ),
                              const SizedBox(height: 10),
                              ScaleTransition(
                                scale: _scoreScale,
                                child: Text(
                                  '$score',
                                  style: const TextStyle(
                                    fontSize: 64,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.spotifyGreen,
                                    fontFamily: 'Poppins',
                                    height: 1,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'dari $total poin',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark
                                      ? AppTheme.textSilver
                                      : AppTheme.subtitleDark,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              const SizedBox(height: 18),

                              // Progress bar
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: TweenAnimationBuilder<double>(
                                  tween: Tween<double>(
                                      begin: 0, end: score / total),
                                  duration: const Duration(milliseconds: 700),
                                  curve: Curves.easeInOut,
                                  builder: (context, val, _) =>
                                      LinearProgressIndicator(
                                    value: val,
                                    minHeight: 6,
                                    backgroundColor: isDark
                                        ? AppTheme.darkCard
                                        : AppTheme.lightBorder,
                                    valueColor: const AlwaysStoppedAnimation<Color>(
                                      AppTheme.spotifyGreen,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '$percentage% AKURASI',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.spotifyGreen,
                                  fontFamily: 'Poppins',
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // === STATS ROW ===
                        _buildStatRow(
                          quizProvider.score ~/ 20,
                          quizProvider.questions.length,
                          isDark,
                        ),

                        const SizedBox(height: 28),

                        // Spotify Green Pill Button
                        CustomButton(
                          text: 'Main Lagi',
                          onPressed: () {
                            quizProvider.resetQuiz();
                            Navigator.pushReplacement(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (_, a, __) => const StartScreen(),
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
                          },
                          icon: Icons.refresh_rounded,
                        ),

                        const SizedBox(height: 24),
                      ],
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
            value: '$correct',
            label: 'BENAR',
            color: AppTheme.spotifyGreen,
            isDark: isDark,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _StatBox(
            value: '$wrong',
            label: 'SALAH',
            color: AppTheme.negativeRed,
            isDark: isDark,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _StatBox(
            value: '$total',
            label: 'TOTAL',
            color: isDark ? AppTheme.textBase : AppTheme.textDark,
            isDark: isDark,
          ),
        ),
      ],
    );
  }

  _ResultConfig _getConfig(int score) {
    if (score >= 80) {
      return _ResultConfig(
        title: 'Hasil Sempurna! 🎉',
      );
    } else if (score >= 60) {
      return _ResultConfig(
        title: 'Kerja Bagus! 🌟',
      );
    } else if (score >= 40) {
      return _ResultConfig(
        title: 'Lumayan Nih! 💪',
      );
    } else {
      return _ResultConfig(
        title: 'Ayo Coba Lagi! 🔥',
      );
    }
  }
}

class _ResultConfig {
  final String title;

  _ResultConfig({
    required this.title,
  });
}

class _StatBox extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  final bool isDark;

  const _StatBox({
    required this.value,
    required this.label,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
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
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: color,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: isDark ? AppTheme.textSilver : AppTheme.subtitleDark,
              fontFamily: 'Poppins',
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}
