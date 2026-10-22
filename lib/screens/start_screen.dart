import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/quiz_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/user_provider.dart';
import '../theme/app_theme.dart';
import '../utils/responsive_util.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/gothic_l_badge.dart';
import 'quiz_screen.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();

    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _startQuiz() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text('Nama tidak boleh kosong!',
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 13)),
            ],
          ),
          backgroundColor: AppTheme.negativeRed,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
        transitionDuration: const Duration(milliseconds: 400),
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
      backgroundColor: isDark ? AppTheme.nearBlack : AppTheme.lightBg,
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? AppTheme.spotifyBgGradient
              : AppTheme.lightBgGradient,
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Theme Toggle Button (Light / Dark Mode Switcher)
              Positioned(
                top: 12,
                right: 16,
                child: _ThemeToggle(
                  isDark: isDark,
                  themeProvider: themeProvider,
                ),
              ),

              Center(
                child: SingleChildScrollView(
                  child: SizedBox(
                    width: formWidth,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: FadeTransition(
                        opacity: _fadeAnim,
                        child: SlideTransition(
                          position: _slideAnim,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 30),

                              // Gothic "L" Logo Badge with Customized Frame
                              GothicLBadge(
                                size: 100,
                                isDark: isDark,
                              ),
                              const SizedBox(height: 28),

                              // Title
                              Text(
                                'Anime Knowledge',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w700,
                                  color: isDark
                                      ? AppTheme.textBase
                                      : AppTheme.textDark,
                                  fontFamily: 'Poppins',
                                  letterSpacing: 0.2,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Seberapa Paham Kamu Dengan Anime?!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isDark
                                      ? AppTheme.textSilver
                                      : AppTheme.subtitleDark,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Stats Row
                              _buildStatsRow(isDark),

                              const SizedBox(height: 32),

                              // Input Card
                              _buildInputCard(isDark),

                              const SizedBox(height: 24),

                              // Spotify Green Pill Button
                              CustomButton(
                                text: 'Mulai Kuis Sekarang',
                                onPressed: _startQuiz,
                                icon: Icons.play_arrow_rounded,
                              ),

                              const SizedBox(height: 32),
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

  Widget _buildStatsRow(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _StatChip(label: '5 SOAL', isDark: isDark),
        const SizedBox(width: 8),
        _StatChip(label: '100 POIN', isDark: isDark),
        const SizedBox(width: 8),
        _StatChip(label: 'ANIME', isDark: isDark),
      ],
    );
  }

  Widget _buildInputCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkSurface : AppTheme.lightSurface,
        borderRadius: BorderRadius.circular(8), // Spotify Card Radius (8px)
        border: Border.all(
          color: isDark ? AppTheme.borderGray : AppTheme.lightBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'MASUKKAN NAMA KAMU',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: isDark ? AppTheme.textSilver : AppTheme.subtitleDark,
              fontFamily: 'Poppins',
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          CustomTextField(
            controller: _nameController,
            hintText: 'Nama Peserta...',
            icon: Icons.person_outline_rounded,
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final bool isDark;

  const _StatChip({required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.midDark : AppTheme.lightInputBg,
        borderRadius: BorderRadius.circular(500), // Pill Shape
        border: Border.all(
          color: isDark ? AppTheme.borderGray : AppTheme.lightBorder,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: isDark ? AppTheme.textSilver : AppTheme.textDark,
          fontFamily: 'Poppins',
          letterSpacing: 1.0,
        ),
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
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDark ? AppTheme.darkSurface : AppTheme.lightSurface,
          border: Border.all(
            color: isDark ? AppTheme.borderGray : AppTheme.lightBorder,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(
          isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
          color: isDark ? AppTheme.textBase : AppTheme.textDark,
          size: 20,
        ),
      ),
    );
  }
}
