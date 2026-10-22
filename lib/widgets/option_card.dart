import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum OptionState { normal, correct, wrong }

class OptionCard extends StatefulWidget {
  final String optionText;
  final String optionLabel; // A, B, C, D
  final VoidCallback onTap;
  final OptionState state;

  const OptionCard({
    super.key,
    required this.optionText,
    required this.optionLabel,
    required this.onTap,
    this.state = OptionState.normal,
  });

  @override
  State<OptionCard> createState() => _OptionCardState();
}

class _OptionCardState extends State<OptionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.97,
      upperBound: 1.0,
    )..value = 1.0;
    _scaleAnim = _controller;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getBorderColor(bool isDark) {
    switch (widget.state) {
      case OptionState.correct:
        return AppTheme.spotifyGreen;
      case OptionState.wrong:
        return AppTheme.negativeRed;
      case OptionState.normal:
        return isDark ? AppTheme.borderGray : AppTheme.lightBorder;
    }
  }

  Color _getCardColor(bool isDark) {
    switch (widget.state) {
      case OptionState.correct:
        return AppTheme.spotifyGreen.withValues(alpha: 0.15);
      case OptionState.wrong:
        return AppTheme.negativeRed.withValues(alpha: 0.12);
      case OptionState.normal:
        return isDark ? AppTheme.darkSurface : AppTheme.lightSurface;
    }
  }

  Color _getLabelBg(bool isDark) {
    switch (widget.state) {
      case OptionState.correct:
        return AppTheme.spotifyGreen;
      case OptionState.wrong:
        return AppTheme.negativeRed;
      case OptionState.normal:
        return isDark ? AppTheme.midDark : AppTheme.lightBg;
    }
  }

  Color _getLabelText(bool isDark) {
    switch (widget.state) {
      case OptionState.correct:
        return Colors.black;
      case OptionState.wrong:
        return Colors.white;
      case OptionState.normal:
        return isDark ? AppTheme.textBase : AppTheme.textDark;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTapDown: (_) => _controller.reverse(),
      onTapUp: (_) => _controller.forward(),
      onTapCancel: () => _controller.forward(),
      onTap: widget.state == OptionState.normal ? widget.onTap : null,
      child: AnimatedBuilder(
        animation: _scaleAnim,
        builder: (context, child) =>
            Transform.scale(scale: _scaleAnim.value, child: child),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: _getCardColor(isDark),
            borderRadius: BorderRadius.circular(8), // Spotify 8px Radius
            border: Border.all(
              color: _getBorderColor(isDark),
              width: widget.state == OptionState.normal ? 1 : 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              // Circular Option Badge
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: _getLabelBg(isDark),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: widget.state == OptionState.normal
                        ? (isDark ? AppTheme.borderGray : AppTheme.lightBorder)
                        : Colors.transparent,
                  ),
                ),
                child: Center(
                  child: widget.state == OptionState.normal
                      ? Text(
                          widget.optionLabel,
                          style: TextStyle(
                            color: _getLabelText(isDark),
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            fontFamily: 'Poppins',
                          ),
                        )
                      : Icon(
                          widget.state == OptionState.correct
                              ? Icons.check_rounded
                              : Icons.close_rounded,
                          color: _getLabelText(isDark),
                          size: 18,
                        ),
                ),
              ),
              const SizedBox(width: 14),
              // Option text
              Expanded(
                child: Text(
                  widget.optionText,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppTheme.textBase : AppTheme.textDark,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
