import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icon,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final FocusNode _focus = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focus.addListener(() {
      setState(() => _isFocused = _focus.hasFocus);
    });
  }

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.midDark : AppTheme.lightSurface,
        borderRadius: BorderRadius.circular(500), // Spotify Pill Input Shape
        border: Border.all(
          color: _isFocused
              ? AppTheme.spotifyGreen
              : (isDark ? AppTheme.borderGray : AppTheme.lightBorder),
          width: _isFocused ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: widget.controller,
        focusNode: _focus,
        style: TextStyle(
          color: isDark ? AppTheme.textBase : AppTheme.textDark,
          fontFamily: 'Poppins',
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: isDark ? AppTheme.textSilver : AppTheme.subtitleDark,
            fontFamily: 'Poppins',
            fontSize: 14,
          ),
          prefixIcon: Icon(
            widget.icon,
            color: _isFocused
                ? AppTheme.spotifyGreen
                : (isDark ? AppTheme.textSilver : AppTheme.subtitleDark),
            size: 20,
          ),
          filled: false,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        ),
      ),
    );
  }
}
