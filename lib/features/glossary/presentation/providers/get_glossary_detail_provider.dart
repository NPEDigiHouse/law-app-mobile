// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/core/errors/failures.dart';
import 'package:law_app/features/admin/data/models/glossary_model.dart';
import 'package:law_app/features/glossary/presentation/providers/repositories_provider/glossary_repository_provider.dart';

part 'get_glossary_detail_provider.g.dart';

@riverpod
class GetGlossaryDetail extends _$GetGlossaryDetail {
  @override
  Future<GlossaryModel?> build({required int id}) async {
    GlossaryModel? glossary;

    try {
      state = const AsyncValue.loading();

      final result =
          await ref.watch(glossaryRepositoryProvider).getGlossaryDetail(id: id);

      result.fold(
        (l) => state = AsyncValue.error(l.message, StackTrace.current),
        (r) {
          glossary = r;
          state = AsyncValue.data(r);
        },
      );
    } catch (e) {
      state = AsyncValue.error((e as Failure).message, StackTrace.current);
    }

    return glossary;
  }
}
