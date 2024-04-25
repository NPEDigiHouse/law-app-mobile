// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/features/admin/data/models/reference_models/faq_model.dart';
import 'package:law_app/features/admin/presentation/reference/providers/repositories_provider/reference_repository_provider.dart';

part 'faq_provider.g.dart';

@riverpod
class Faq extends _$Faq {
  @override
  Future<List<FAQModel>?> build() async {
    List<FAQModel>? faqs;

    state = const AsyncValue.loading();

    final result = await ref.watch(referenceRepositoryProvider).getFAQs();

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) {
        faqs = r;
        state = AsyncValue.data(r);
      },
    );

    return faqs;
  }

  Future<void> createFAQ({
    required String question,
    required String answer,
  }) async {
    state = const AsyncValue.loading();

    final result = await ref.watch(referenceRepositoryProvider).createFAQ(
          question: question,
          answer: answer,
        );

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) => ref.invalidateSelf(),
    );
  }

  Future<void> editFAQ({required FAQModel faq}) async {
    state = const AsyncValue.loading();

    final result = await ref.watch(referenceRepositoryProvider).editFAQ(faq: faq);

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) => ref.invalidateSelf(),
    );
  }

  Future<void> deleteFAQ({required int id}) async {
    state = const AsyncValue.loading();

    final result = await ref.watch(referenceRepositoryProvider).deleteFAQ(id: id);

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) => ref.invalidateSelf(),
    );
  }
}
