// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/features/admin/data/models/dashboard_models/dashboard_data_model.dart';
import 'package:law_app/features/auth/presentation/providers/repositories_provider/auth_repository_provider.dart';

part 'dashboard_data_provider.g.dart';

@riverpod
class DashboardData extends _$DashboardData {
  @override
  Future<DashboardDataModel?> build() async {
    DashboardDataModel? data;

    state = const AsyncValue.loading();

    final result = await ref.watch(authRepositoryProvider).getDashboardData();

    result.fold(
      (l) => state = AsyncValue.error(l, StackTrace.current),
      (r) {
        data = r;
        state = AsyncValue.data(r);
      },
    );

    return data;
  }
}
