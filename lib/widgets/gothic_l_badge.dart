import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class GothicLBadge extends StatelessWidget {
  final double size;
  final bool isDark;

  const GothicLBadge({
    super.key,
    this.size = 100,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(size * 0.12),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDark ? AppTheme.darkSurface : AppTheme.lightSurface,
        border: Border.all(
          color: isDark ? AppTheme.spotifyGreen : AppTheme.textDark,
          width: size * 0.035,
        ),
        boxShadow: [
          BoxShadow(
            color: (isDark ? AppTheme.spotifyGreen : Colors.black)
                .withValues(alpha: isDark ? 0.35 : 0.15),
            blurRadius: size * 0.25,
            spreadRadius: size * 0.02,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: (isDark ? AppTheme.borderGray : AppTheme.lightBorder),
            width: size * 0.015,
          ),
        ),
        padding: EdgeInsets.all(size * 0.1),
        child: Image.asset(
          isDark ? 'assets/images/l_logo_white.png' : 'assets/images/l_logo.png',
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Center(
              child: Text(
                'L',
                style: TextStyle(
                  fontSize: size * 0.45,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppTheme.textBase : AppTheme.textDark,
                  fontFamily: 'serif',
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
