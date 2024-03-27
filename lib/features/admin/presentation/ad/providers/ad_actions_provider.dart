// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/features/admin/data/models/ad_models/ad_model.dart';
import 'package:law_app/features/admin/data/models/ad_models/ad_post_model.dart';
import 'package:law_app/features/admin/presentation/ad/providers/repositories_provider/ad_repository_provider.dart';

part 'ad_actions_provider.g.dart';

@riverpod
class AdActions extends _$AdActions {
  @override
  AsyncValue<String?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> createAd({required AdPostModel ad}) async {
    state = const AsyncValue.loading();

    final result = await ref.watch(adRepositoryProvider).createAd(ad: ad);

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) => state = const AsyncValue.data('Berhasil membuat iklan!'),
    );
  }

  Future<void> editAd({required AdModel ad}) async {
    state = const AsyncValue.loading();

    final result = await ref.watch(adRepositoryProvider).editAd(ad: ad);

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) => state = const AsyncValue.data('Berhasil mengedit iklan!'),
    );
  }

  Future<void> deleteAd({required int id}) async {
    state = const AsyncValue.loading();

    final result = await ref.watch(adRepositoryProvider).deleteAd(id: id);

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) => state = const AsyncValue.data('Berhasil menghapus iklan!'),
    );
  }
}
