// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/features/admin/data/models/ad_models/ad_model.dart';
import 'package:law_app/features/admin/presentation/ad/providers/repositories_provider/ad_repository_provider.dart';

part 'ad_provider.g.dart';

@riverpod
class Ad extends _$Ad {
  @override
  Future<List<AdModel>?> build() async {
    List<AdModel>? ads;

    state = const AsyncValue.loading();

    final result = await ref.watch(adRepositoryProvider).getAds();

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) {
        ads = r;
        state = AsyncValue.data(r);
      },
    );

    return ads;
  }
}
