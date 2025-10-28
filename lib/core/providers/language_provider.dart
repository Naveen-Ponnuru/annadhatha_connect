import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final localeProvider = StateNotifierProvider<LanguageNotifier, Locale>((ref) {
  return LanguageNotifier();
});

class LanguageNotifier extends StateNotifier<Locale> {
  static const String _languageKey = 'language_code';
  static const String _countryKey = 'country_code';

  LanguageNotifier() : super(const Locale('en', 'IN')) {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString(_languageKey) ?? 'en';
      final countryCode = prefs.getString(_countryKey) ?? 'IN';
      state = Locale(languageCode, countryCode);
    } catch (e) {
      // If loading fails, use default language
      state = const Locale('en', 'IN');
    }
  }

  Future<void> setLanguage(Locale locale) async {
    try {
      state = locale;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, locale.languageCode);
      await prefs.setString(_countryKey, locale.countryCode ?? 'IN');
    } catch (e) {
      // If saving fails, still update the state
      state = locale;
    }
  }

  void setEnglish() {
    setLanguage(const Locale('en', 'IN'));
  }

  void setHindi() {
    setLanguage(const Locale('hi', 'IN'));
  }

  void setTamil() {
    setLanguage(const Locale('ta', 'IN'));
  }

  String get currentLanguageName {
    switch (state.languageCode) {
      case 'hi':
        return 'हिन्दी';
      case 'ta':
        return 'தமிழ்';
      case 'en':
      default:
        return 'English';
    }
  }

  String get currentLanguageCode => state.languageCode;
}
