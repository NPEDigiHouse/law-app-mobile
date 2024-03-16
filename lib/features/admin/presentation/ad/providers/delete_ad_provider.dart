// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/features/admin/presentation/ad/providers/repositories_provider/ad_repository_provider.dart';

part 'delete_ad_provider.g.dart';

@riverpod
class DeleteAd extends _$DeleteAd {
  @override
  AsyncValue<bool?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> deleteAd({required int id}) async {
    state = const AsyncValue.loading();

    final result = await ref.watch(adRepositoryProvider).deleteAd(id: id);

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) => state = const AsyncValue.data(true),
    );
  }
}
