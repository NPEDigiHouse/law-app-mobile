// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:law_app/core/enums/banner_type.dart';
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/helpers/function_helper.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/shared/pages/discussion_list_page.dart';
import 'package:law_app/features/shared/providers/discussion_providers/user_discussions_provider.dart';
import 'package:law_app/features/shared/providers/manual_providers/search_provider.dart';
import 'package:law_app/features/shared/widgets/custom_information.dart';
import 'package:law_app/features/shared/widgets/feature/discussion_card.dart';
import 'package:law_app/features/shared/widgets/form_field/search_field.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/loading_indicator.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

enum HistoryStatus { onDiscussion, solved }

final historyStatusProvider = StateProvider.autoDispose<HistoryStatus>(
  (ref) => HistoryStatus.onDiscussion,
);

class TeacherDiscussionHistoryPage extends ConsumerWidget {
  const TeacherDiscussionHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSearching = ref.watch(isSearchingProvider);
    final query = ref.watch(queryProvider);
    final status = ref.watch(historyStatusProvider);

    final discussions = ref.watch(
      UserDiscussionsProvider(
        query: query,
        status: status.name,
        type: 'specific',
      ),
    );

    ref.listen(
      UserDiscussionsProvider(
        query: query,
        status: status.name,
        type: 'specific',
      ),
      (_, state) {
        state.whenOrNull(
          error: (error, _) {
            if ('$error' == kNoInternetConnection) {
              context.showNetworkErrorModalBottomSheet(
                onPressedPrimaryButton: () {
                  navigatorKey.currentState!.pop();
                  ref.invalidate(userDiscussionsProvider);
                },
              );
            } else {
              context.showBanner(message: '$error', type: BannerType.error);
            }
          },
        );
      },
    );

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        return FunctionHelper.handleSearchingOnPop(
          ref,
          didPop,
          isSearching,
          provider: UserDiscussionsProvider(
            query: query,
            status: status.name,
            type: 'specific',
          ),
        );
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(isSearching ? 124 : 180),
          child: buildHeaderContainer(ref, isSearching, query, status),
        ),
        body: discussions.whenOrNull(
          loading: () => const LoadingIndicator(),
          data: (discussions) {
            if (discussions == null) return null;

            if (isSearching && query.trim().isNotEmpty) {
              if (discussions.isEmpty) {
                return const CustomInformation(
                  illustrationName: 'discussion-cuate.svg',
                  title: 'Pertanyaan tidak ditemukan',
                  subtitle: 'Pertanyaan dengan judul tersebut tidak ditemukan.',
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                itemBuilder: (context, index) {
                  return DiscussionCard(
                    discussion: discussions[index],
                    isDetail: true,
                    withProfile: true,
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 8);
                },
                itemCount: discussions.length,
              );
            }

            return DiscussionListPage(
              discussions: discussions,
              isDetail: true,
              withProfile: true,
            );
          },
        ),
      ),
    );
  }

  HeaderContainer buildHeaderContainer(
    WidgetRef ref,
    bool isSearching,
    String query,
    HistoryStatus status,
  ) {
    if (isSearching) {
      return HeaderContainer(
        child: Column(
          children: [
            Text(
              'Cari Riwayat Pertanyaan',
              style: textTheme.titleMedium!.copyWith(
                color: scaffoldBackgroundColor,
              ),
            ),
            const SizedBox(height: 10),
            SearchField(
              text: query,
              hintText: 'Cari judul pertanyaan',
              autoFocus: true,
              onChanged: (query) => searchDiscussion(ref, query),
              onFocusChange: (isFocus) {
                if (!isFocus && query.trim().isEmpty) {
                  ref.read(isSearchingProvider.notifier).state = false;
                }
              },
            ),
          ],
        ),
      );
    }

    return HeaderContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: secondaryColor,
                ),
                child: IconButton(
                  onPressed: () => navigatorKey.currentState!.pop(),
                  icon: SvgAsset(
                    assetPath: AssetPath.getIcon('caret-line-left.svg'),
                    color: primaryColor,
                    width: 24,
                  ),
                  tooltip: 'Kembali',
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    'Riwayat Pertanyaan',
                    style: textTheme.titleLarge!.copyWith(
                      color: scaffoldBackgroundColor,
                    ),
                  ),
                ),
              ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: secondaryColor,
                ),
                child: IconButton(
                  onPressed: () {
                    ref.read(isSearchingProvider.notifier).state = true;
                  },
                  icon: SvgAsset(
                    assetPath: AssetPath.getIcon('search-line.svg'),
                    color: primaryColor,
                    width: 24,
                  ),
                  tooltip: 'Cari',
                ),
              )
            ],
          ),
          const SizedBox(height: 16),
          SegmentedButton<HistoryStatus>(
            segments: const [
              ButtonSegment(
                value: HistoryStatus.onDiscussion,
                label: Text('Dalam Diskusi'),
              ),
              ButtonSegment(
                value: HistoryStatus.solved,
                label: Text('Telah Selesai'),
              ),
            ],
            selected: {status},
            showSelectedIcon: false,
            onSelectionChanged: (newSelection) {
              ref.read(historyStatusProvider.notifier).state = newSelection.first;
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void searchDiscussion(WidgetRef ref, String query) {
    if (query.trim().isNotEmpty) {
      ref.read(UserDiscussionsProvider(query: query, type: 'specific'));
    } else {
      ref.invalidate(userDiscussionsProvider);
    }

    ref.read(queryProvider.notifier).state = query;
  }
}
