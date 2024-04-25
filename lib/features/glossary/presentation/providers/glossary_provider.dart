// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/features/admin/data/models/glossary_models/glossary_model.dart';
import 'package:law_app/features/glossary/presentation/providers/repositories_provider/glossary_repository_provider.dart';

part 'glossary_provider.g.dart';

@riverpod
class Glossary extends _$Glossary {
  @override
  Future<List<GlossaryModel>?> build() async {
    List<GlossaryModel>? glossaries;

    state = const AsyncValue.loading();

    final result = await ref.watch(glossaryRepositoryProvider).getGlossaries();

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) {
        glossaries = r;
        state = AsyncValue.data(r);
      },
    );

    return glossaries;
  }

  Future<void> searchGlossaries({String query = ''}) async {
    state = const AsyncValue.loading();

    final result = await ref.watch(glossaryRepositoryProvider).getGlossaries(query: query);

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) => state = AsyncValue.data(r),
    );
  }
}
