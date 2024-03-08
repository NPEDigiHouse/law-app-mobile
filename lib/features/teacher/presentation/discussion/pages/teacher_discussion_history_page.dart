// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:law_app/core/enums/banner_type.dart';
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/helpers/function_helper.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/shared/pages/discussion_list_page.dart';
import 'package:law_app/features/shared/providers/discussion_providers/user_discussions_provider.dart';
import 'package:law_app/features/shared/providers/search_provider.dart';
import 'package:law_app/features/shared/widgets/custom_information.dart';
import 'package:law_app/features/shared/widgets/feature/discussion_card.dart';
import 'package:law_app/features/shared/widgets/form_field/search_field.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/loading_indicator.dart';

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
        state.when(
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
          loading: () {},
          data: (_) {},
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

            if (isSearching && query.isNotEmpty) {
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

  Widget buildHeaderContainer(
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
                if (!isFocus && query.isEmpty) {
                  ref.read(isSearchingProvider.notifier).state = false;
                }
              },
            ),
          ],
        ),
      );
    }

    return SizedBox(
      height: 180,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          HeaderContainer(
            height: 180,
            title: 'Riwayat Pertanyaan',
            withBackButton: true,
            withTrailingButton: true,
            trailingButtonIconName: 'search-line.svg',
            trailingButtonTooltip: 'Cari',
            onPressedTrailingButton: () {
              ref.read(isSearchingProvider.notifier).state = true;
            },
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: SegmentedButton<HistoryStatus>(
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
                ref.read(historyStatusProvider.notifier).state =
                    newSelection.first;
              },
            ),
          ),
        ],
      ),
    );
  }

  void searchDiscussion(WidgetRef ref, String query) {
    ref.read(queryProvider.notifier).state = query;

    if (query.isNotEmpty) {
      EasyDebounce.debounce(
        'search-debouncer',
        const Duration(milliseconds: 800),
        () => ref.read(UserDiscussionsProvider(query: query, type: 'specific')),
      );
    } else {
      ref.invalidate(userDiscussionsProvider);
    }
  }
}
