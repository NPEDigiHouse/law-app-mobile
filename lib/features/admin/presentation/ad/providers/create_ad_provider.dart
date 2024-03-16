// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/features/admin/presentation/ad/providers/repositories_provider/ad_repository_provider.dart';

part 'create_ad_provider.g.dart';

@riverpod
class CreateAd extends _$CreateAd {
  @override
  AsyncValue<bool?> build() {
    return const AsyncValue.data(null);
  }

  
  Future<void> createAd({
    required String title,
    required String content,
    required String imageName,
  }) async {
    state = const AsyncValue.loading();

    final result = await ref.watch(adRepositoryProvider).createAd(
          title: title,
          content: content,
          imageName: imageName,
        );
        
    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) => state = const AsyncValue.data(true),
    );
  }

}