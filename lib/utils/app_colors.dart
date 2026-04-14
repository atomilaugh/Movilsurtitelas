import 'package:flutter/material.dart';

abstract class AppColorsTheme {
  Color get background;
  Color get surface;
  Color get surfaceElevated;
  Color get primary;
  Color get secondary;
  Color get text;
  Color get textSecondary;
  Color get textTertiary;
  Color get border;
  Color get accent;
  Color get accentLight;
  Color get success;
  Color get successBg;
  Color get error;
  Color get errorBg;
  Color get warning;
  Color get warningBg;
  Color get info;
  Color get infoBg;
}

class AppColorsLight implements AppColorsTheme {
  static const Color _background = Color(0xFFFAFAFA);
  static const Color _surface = Color(0xFFFFFFFF);
  static const Color _surfaceElevated = Color(0xFFF5F5F5);
  static const Color _primary = Color(0xFF000000);
  static const Color _secondary = Color(0xFF8B8173);
  static const Color _text = Color(0xFF1A1A1A);
  static const Color _textSecondary = Color(0xFF6B6B6B);
  static const Color _textTertiary = Color(0xFF999999);
  static const Color _border = Color(0xFFE5E5E5);
  static const Color _accent = Color(0xFF8B8173);
  static const Color _accentLight = Color(0xFFE8E3D8);
  static const Color _success = Color(0xFF2E7D32);
  static const Color _successBg = Color(0xFFE8F5E9);
  static const Color _error = Color(0xFFD32F2F);
  static const Color _errorBg = Color(0xFFFFE5E5);
  static const Color _warning = Color(0xFFE65100);
  static const Color _warningBg = Color(0xFFFFF3E0);
  static const Color _info = Color(0xFF1565C0);
  static const Color _infoBg = Color(0xFFE3F2FD);

  @override
  Color get background => _background;
  @override
  Color get surface => _surface;
  @override
  Color get surfaceElevated => _surfaceElevated;
  @override
  Color get primary => _primary;
  @override
  Color get secondary => _secondary;
  @override
  Color get text => _text;
  @override
  Color get textSecondary => _textSecondary;
  @override
  Color get textTertiary => _textTertiary;
  @override
  Color get border => _border;
  @override
  Color get accent => _accent;
  @override
  Color get accentLight => _accentLight;
  @override
  Color get success => _success;
  @override
  Color get successBg => _successBg;
  @override
  Color get error => _error;
  @override
  Color get errorBg => _errorBg;
  @override
  Color get warning => _warning;
  @override
  Color get warningBg => _warningBg;
  @override
  Color get info => _info;
  @override
  Color get infoBg => _infoBg;
}

class AppColorsDark implements AppColorsTheme {
  static const Color _background = Color(0xFF0A0A0A);
  static const Color _surface = Color(0xFF1A1816);
  static const Color _surfaceElevated = Color(0xFF2A2420);
  static const Color _primary = Color(0xFFD4CFC4);
  static const Color _secondary = Color(0xFFB5ADA1);
  static const Color _text = Color(0xFFF5F5F5);
  static const Color _textSecondary = Color(0xFFD4CFC4);
  static const Color _textTertiary = Color(0xFFB5ADA1);
  static const Color _border = Color(0xFF3D3530);
  static const Color _accent = Color(0xFFC4B5A0);
  static const Color _accentLight = Color(0xFF2A2420);
  static const Color _success = Color(0xFF4CAF50);
  static const Color _successBg = Color(0xFF1F3A1F);
  static const Color _error = Color(0xFFFF6B6B);
  static const Color _errorBg = Color(0xFF3D1F1F);
  static const Color _warning = Color(0xFFFFB74D);
  static const Color _warningBg = Color(0xFF3D2F1F);
  static const Color _info = Color(0xFF64B5F6);
  static const Color _infoBg = Color(0xFF1F2F3D);

  @override
  Color get background => _background;
  @override
  Color get surface => _surface;
  @override
  Color get surfaceElevated => _surfaceElevated;
  @override
  Color get primary => _primary;
  @override
  Color get secondary => _secondary;
  @override
  Color get text => _text;
  @override
  Color get textSecondary => _textSecondary;
  @override
  Color get textTertiary => _textTertiary;
  @override
  Color get border => _border;
  @override
  Color get accent => _accent;
  @override
  Color get accentLight => _accentLight;
  @override
  Color get success => _success;
  @override
  Color get successBg => _successBg;
  @override
  Color get error => _error;
  @override
  Color get errorBg => _errorBg;
  @override
  Color get warning => _warning;
  @override
  Color get warningBg => _warningBg;
  @override
  Color get info => _info;
  @override
  Color get infoBg => _infoBg;
}

class AppColors {
  static AppColorsTheme get light => AppColorsLight();
  static AppColorsTheme get dark => AppColorsDark();
}