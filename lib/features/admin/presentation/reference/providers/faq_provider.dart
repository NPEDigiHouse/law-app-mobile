// Package imports:
import 'package:law_app/features/admin/presentation/reference/providers/repositories_provider/reference_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/features/admin/data/models/faq_models/faq_model.dart';

part 'faq_provider.g.dart';

@riverpod
class Faq extends _$Faq {
  @override
  Future<List<FaqModel>?> build() async {
    List<FaqModel>? faqs;

    state = const AsyncValue.loading();

    final result = await ref.watch(referenceRepositoryProvider).getFaq();

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) {
        faqs = r;
        state = AsyncValue.data(r);
      },
    );

    return faqs;
  }

  Future<void> createFaq(
      {required String question, required String answer}) async {
    state = const AsyncValue.loading();

    final result = await ref
        .watch(referenceRepositoryProvider)
        .createFaq(question: question, answer: answer);

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) => ref.invalidateSelf(),
    );
  }

  Future<void> editFaq({required FaqModel faq}) async {
    state = const AsyncValue.loading();

    final result =
        await ref.watch(referenceRepositoryProvider).editFaq(faq: faq);

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) => ref.invalidateSelf(),
    );
  }

  Future<void> deleteFaq({required int id}) async {
    state = const AsyncValue.loading();

    final result =
        await ref.watch(referenceRepositoryProvider).deleteFaq(id: id);

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) => ref.invalidateSelf(),
    );
  }
}
