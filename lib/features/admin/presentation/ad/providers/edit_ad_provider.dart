// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/features/admin/presentation/ad/providers/repositories_provider/ad_repository_provider.dart';
import 'package:law_app/features/admin/data/models/ad_models/ad_model.dart';

part 'edit_ad_provider.g.dart';

@riverpod
class EditAd extends _$EditAd {
  @override
  AsyncValue<bool?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> editAd({required AdModel ad}) async {
    state = const AsyncValue.loading();

    final result = await ref.watch(adRepositoryProvider).editAd(ad: ad);

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) => state = const AsyncValue.data(true),
    );
  }
}