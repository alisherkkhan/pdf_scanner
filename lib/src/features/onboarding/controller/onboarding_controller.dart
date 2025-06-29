import 'package:pdf_scanner/src/core/helper/type_defs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fpdart/fpdart.dart';

part 'onboarding_controller.g.dart';

@Riverpod(keepAlive: true)
class OnboardingController extends _$OnboardingController {
  static const _key = 'hasSeenOnboarding';

  @override
  Future<bool> build() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key) ?? false;
  }

  FutureVoid completeOnboarding() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final result = await prefs.setBool(_key, true);

      if (result) {
        return right(unit);
      } else {
        return left(Failure(message: 'Failed to save onboarding flag'));
      }
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  FutureVoid resetOnboarding() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final result = await prefs.remove(_key);

      if (result) {
        state = const AsyncData(false);
        return right(unit);
      } else {
        return left(Failure(message: 'Failed to reset onboarding flag'));
      }
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }
}
