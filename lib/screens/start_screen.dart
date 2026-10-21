import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/quiz_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/user_provider.dart';
import '../theme/app_theme.dart';
import '../utils/responsive_util.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import 'quiz_screen.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen>
    with TickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();

  late AnimationController _floatController;
  late AnimationController _fadeController;
  late Animation<double> _floatAnim;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat(reverse: true);

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    _floatAnim = Tween<double>(begin: -10.0, end: 10.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _floatController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _startQuiz() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.white),
              SizedBox(width: 10),
              Text('Nama tidak boleh kosong!',
                  style: TextStyle(fontFamily: 'Poppins')),
            ],
          ),
          backgroundColor: AppTheme.wrongColor,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          margin: const EdgeInsets.all(16),
        ),
      );
      return;
    }

    Provider.of<UserProvider>(context, listen: false)
        .setUserName(_nameController.text.trim());
    Provider.of<QuizProvider>(context, listen: false).resetQuiz();

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, animation, __) => const QuizScreen(),
        transitionsBuilder: (_, animation, __, child) => FadeTransition(
          opacity: animation,
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final isLargeScreen =
        ResponsiveUtil.isTablet(context) || ResponsiveUtil.isDesktop(context);
    final formWidth =
        isLargeScreen ? 480.0 : ResponsiveUtil.width(context, 0.9);

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
          child: Stack(
            children: [
              // Decorative circles
              _buildDecorCircle(top: -60, right: -60, size: 200,
                  color: AppTheme.primaryColor.withValues(alpha: 0.12)),
              _buildDecorCircle(bottom: -80, left: -60, size: 220,
                  color: AppTheme.accentColor.withValues(alpha: 0.1)),
              _buildDecorCircle(top: 160, left: -40, size: 120,
                  color: AppTheme.goldColor.withValues(alpha: 0.08)),

              // Theme toggle
              Positioned(
                top: 8,
                right: 16,
                child: _ThemeToggle(
                    isDark: isDark, themeProvider: themeProvider),
              ),

              Center(
                child: SingleChildScrollView(
                  child: SizedBox(
                    width: formWidth,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: FadeTransition(
                        opacity: _fadeAnim,
                        child: SlideTransition(
                          position: _slideAnim,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Floating Logo
                              AnimatedBuilder(
                                animation: _floatAnim,
                                builder: (context, child) => Transform.translate(
                                  offset: Offset(0, _floatAnim.value),
                                  child: child,
                                ),
                                child: _buildLogo(isDark),
                              ),
                              const SizedBox(height: 32),

                              // Title
                              ShaderMask(
                                shaderCallback: (bounds) =>
                                    AppTheme.primaryGradient.createShader(bounds),
                                child: const Text(
                                  'Anime Knowledge',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontFamily: 'Poppins',
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Seberapa Paham Kamu Dengan Anime?!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isDark
                                      ? AppTheme.subtitleLight
                                      : AppTheme.subtitleDark,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Stats Row
                              _buildStatsRow(isDark),

                              const SizedBox(height: 36),

                              // Name input card
                              _buildInputCard(isDark),

                              const SizedBox(height: 24),

                              CustomButton(
                                text: 'MULAI KUIS',
                                onPressed: _startQuiz,
                                icon: Icons.play_arrow_rounded,
                              ),

                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDecorCircle({
    double? top, double? bottom, double? left, double? right,
    required double size, required Color color,
  }) {
    return Positioned(
      top: top, bottom: bottom, left: left, right: right,
      child: Container(
        width: size, height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
    );
  }

  Widget _buildLogo(bool isDark) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppTheme.primaryGradient,
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withValues(alpha: 0.5),
            blurRadius: 30,
            spreadRadius: 4,
          ),
        ],
      ),
      child: const Icon(Icons.auto_awesome_rounded,
          size: 60, color: Colors.white),
    );
  }

  Widget _buildStatsRow(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _StatChip(
            icon: Icons.quiz_rounded,
            label: '5 Soal',
            isDark: isDark),
        const SizedBox(width: 12),
        _StatChip(
            icon: Icons.star_rounded,
            label: 'Skor 100',
            isDark: isDark),
        const SizedBox(width: 12),
        _StatChip(
            icon: Icons.local_fire_department_rounded,
            label: 'Anime',
            isDark: isDark),
      ],
    );
  }

  Widget _buildInputCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark
            ? AppTheme.darkSurface.withValues(alpha: 0.8)
            : Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppTheme.primaryColor.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withValues(alpha: 0.12),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Masukkan Nama Kamu',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isDark ? AppTheme.subtitleLight : AppTheme.subtitleDark,
              fontFamily: 'Poppins',
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 10),
          CustomTextField(
            controller: _nameController,
            hintText: 'Nama Peserta...',
            icon: Icons.person_rounded,
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDark;

  const _StatChip(
      {required this.icon, required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: isDark
            ? AppTheme.darkCard
            : AppTheme.primaryColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: AppTheme.primaryColor.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: AppTheme.primaryColor),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryColor,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }
}

class _ThemeToggle extends StatelessWidget {
  final bool isDark;
  final dynamic themeProvider;

  const _ThemeToggle({required this.isDark, required this.themeProvider});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => themeProvider.toggleTheme(!isDark),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDark
              ? AppTheme.darkCard
              : Colors.white.withValues(alpha: 0.9),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
              color: AppTheme.primaryColor.withValues(alpha: 0.3)),
        ),
        child: Icon(
          isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
          color: AppTheme.primaryColor,
          size: 24,
        ),
      ),
    );
  }
}
