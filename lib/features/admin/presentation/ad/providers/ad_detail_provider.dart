// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/features/admin/data/models/ad_models/ad_detail_model.dart';
import 'package:law_app/features/admin/presentation/ad/providers/repositories_provider/ad_repository_provider.dart';

part 'ad_detail_provider.g.dart';

@riverpod
class AdDetail extends _$AdDetail {
  @override
  Future<AdDetailModel?> build({required int id}) async {
    AdDetailModel? ad;

    state = const AsyncValue.loading();

    final result = await ref.watch(adRepositoryProvider).getAdDetail(id: id);

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) {
        ad = r;
        state = AsyncValue.data(r);
      },
    );

    return ad;
  }
}
