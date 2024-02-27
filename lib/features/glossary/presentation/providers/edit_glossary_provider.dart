// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/core/errors/failures.dart';
import 'package:law_app/features/glossary/data/models/glossary_model.dart';
import 'package:law_app/features/glossary/presentation/providers/repositories_provider/glossary_repository_provider.dart';

part 'edit_glossary_provider.g.dart';

@riverpod
class EditGlossary extends _$EditGlossary {
  @override
  AsyncValue<bool?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> editGlossary({required GlossaryModel glossary}) async {
    try {
      state = const AsyncValue.loading();

      final result = await ref
          .watch(glossaryRepositoryProvider)
          .editGlossary(glossary: glossary);

      result.fold(
        (l) => state = AsyncValue.error(l.message, StackTrace.current),
        (r) => state = const AsyncValue.data(true),
      );
    } catch (e) {
      state = AsyncValue.error((e as Failure).message, StackTrace.current);
    }
  }
}
