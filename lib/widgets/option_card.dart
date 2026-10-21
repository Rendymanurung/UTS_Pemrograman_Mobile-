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
      lowerBound: 0.96,
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
        return AppTheme.correctColor;
      case OptionState.wrong:
        return AppTheme.wrongColor;
      case OptionState.normal:
        return isDark
            ? AppTheme.primaryColor.withValues(alpha: 0.35)
            : AppTheme.primaryColor.withValues(alpha: 0.25);
    }
  }

  Color _getCardColor(bool isDark) {
    switch (widget.state) {
      case OptionState.correct:
        return AppTheme.correctColor.withValues(alpha: 0.15);
      case OptionState.wrong:
        return AppTheme.wrongColor.withValues(alpha: 0.12);
      case OptionState.normal:
        return isDark ? AppTheme.darkCard : Colors.white;
    }
  }

  Color _getLabelBg() {
    switch (widget.state) {
      case OptionState.correct:
        return AppTheme.correctColor;
      case OptionState.wrong:
        return AppTheme.wrongColor;
      case OptionState.normal:
        return AppTheme.primaryColor;
    }
  }

  IconData? _getTrailingIcon() {
    switch (widget.state) {
      case OptionState.correct:
        return Icons.check_circle_rounded;
      case OptionState.wrong:
        return Icons.cancel_rounded;
      case OptionState.normal:
        return null;
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
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(vertical: 7),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: _getCardColor(isDark),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: _getBorderColor(isDark),
              width: widget.state == OptionState.normal ? 1.5 : 2,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.state == OptionState.correct
                    ? AppTheme.correctColor.withValues(alpha: 0.2)
                    : widget.state == OptionState.wrong
                        ? AppTheme.wrongColor.withValues(alpha: 0.15)
                        : Colors.black.withValues(alpha: 0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Label A/B/C/D
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  gradient: widget.state == OptionState.normal
                      ? AppTheme.primaryGradient
                      : null,
                  color: widget.state == OptionState.normal
                      ? null
                      : _getLabelBg(),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: widget.state == OptionState.normal
                      ? Text(
                          widget.optionLabel,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            fontFamily: 'Poppins',
                          ),
                        )
                      : Icon(
                          _getTrailingIcon(),
                          color: Colors.white,
                          size: 20,
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
                    color: isDark ? AppTheme.textLight : AppTheme.textDark,
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
