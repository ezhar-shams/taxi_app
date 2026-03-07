import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/storage_service.dart';

final languageProvider = StateNotifierProvider<LanguageNotifier, String>((ref) {
  return LanguageNotifier();
});

class LanguageNotifier extends StateNotifier<String> {
  LanguageNotifier() : super(storageService.getLanguage());

  void setLanguage(String lang) {
    state = lang;
    storageService.setLanguage(lang);
  }

  bool get isDari   => state == 'fa';
  bool get isPashto => state == 'ps';
}

// Convenience provider for text direction
final isRtlProvider = Provider<bool>((ref) => true); // always RTL
