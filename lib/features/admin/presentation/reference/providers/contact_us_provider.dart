// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/features/admin/data/models/reference_models/contact_us_model.dart';
import 'package:law_app/features/admin/presentation/reference/providers/repositories_provider/reference_repository_provider.dart';

part 'contact_us_provider.g.dart';

@riverpod
class ContactUs extends _$ContactUs {
  @override
  Future<ContactUsModel?> build() async {
    ContactUsModel? contact;

    state = const AsyncValue.loading();

    final result = await ref.watch(referenceRepositoryProvider).getContactUs();

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) {
        contact = r;
        state = AsyncValue.data(r);
      },
    );

    return contact;
  }

  Future<void> editContactUs({required ContactUsModel contact}) async {
    state = const AsyncValue.loading();

    final result = await ref
        .watch(referenceRepositoryProvider)
        .editContactUs(contact: contact);

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) => ref.invalidateSelf(),
    );
  }
}
