import 'package:flutter_riverpod/flutter_riverpod.dart';

class UniversalLoadingNotifier extends StateNotifier<bool> {
  UniversalLoadingNotifier() : super(false);

  void setLoading(bool value) => state = value;
  void toggle() => state = !state;
}

final universalLoadingProvider =
    StateNotifierProvider<UniversalLoadingNotifier, bool>(
      (ref) => UniversalLoadingNotifier(),
    );
