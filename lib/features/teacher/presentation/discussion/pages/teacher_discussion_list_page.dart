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
import 'package:law_app/core/utils/credential_saver.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/shared/providers/discussion_providers/discussions_provider.dart';
import 'package:law_app/features/shared/providers/search_provider.dart';
import 'package:law_app/features/shared/widgets/custom_information.dart';
import 'package:law_app/features/shared/widgets/feature/discussion_card.dart';
import 'package:law_app/features/shared/widgets/form_field/search_field.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/loading_indicator.dart';

class TeacherDiscussionListPage extends ConsumerWidget {
  const TeacherDiscussionListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSearching = ref.watch(isSearchingProvider);
    final query = ref.watch(queryProvider);

    final discussions = ref.watch(
      DiscussionsProvider(
        query: query,
        status: 'open',
        type: 'specific',
      ),
    );

    ref.listen(
      DiscussionsProvider(
        query: query,
        status: 'open',
        type: 'specific',
      ),
      (_, state) {
        state.when(
          error: (error, _) {
            if ('$error' == kNoInternetConnection) {
              context.showNetworkErrorModalBottomSheet(
                onPressedPrimaryButton: () {
                  navigatorKey.currentState!.pop();
                  ref.invalidate(discussionsProvider);
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
          provider: DiscussionsProvider(
            status: 'open',
            type: 'specific',
          ),
        );
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(isSearching ? 124 : 96),
          child: buildHeaderContainer(ref, isSearching, query),
        ),
        body: discussions.whenOrNull(
          loading: () => const LoadingIndicator(),
          data: (data) {
            if (data.discussions == null) return null;

            final discussions = data.discussions!.where((e) {
              return CredentialSaver.user!.expertises!.contains(e.category);
            }).toList();

            if (isSearching && query.isNotEmpty && discussions.isEmpty) {
              return const CustomInformation(
                illustrationName: 'discussion-cuate.svg',
                title: 'Pertanyaan tidak ditemukan',
                subtitle: 'Judul pertanyaan tersebut tidak ditemukan.',
              );
            }

            if (discussions.isEmpty) {
              return const CustomInformation(
                illustrationName: 'house-searching-cuate.svg',
                title: 'Belum ada data',
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.symmetric(
                vertical: 24,
                horizontal: 20,
              ),
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
          },
        ),
      ),
    );
  }

  HeaderContainer buildHeaderContainer(
    WidgetRef ref,
    bool isSearching,
    String query,
  ) {
    if (isSearching) {
      return HeaderContainer(
        child: Column(
          children: [
            Text(
              'Cari Pertanyaan',
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

    return HeaderContainer(
      title: 'Perlu Dijawab',
      withBackButton: true,
      withTrailingButton: true,
      trailingButtonIconName: 'search-line.svg',
      trailingButtonTooltip: 'Cari',
      onPressedTrailingButton: () {
        ref.read(isSearchingProvider.notifier).state = true;
      },
    );
  }

  void searchDiscussion(WidgetRef ref, String query) {
    ref.read(queryProvider.notifier).state = query;

    if (query.isNotEmpty) {
      EasyDebounce.debounce(
        'search-debouncer',
        const Duration(milliseconds: 800),
        () {
          ref.read(DiscussionsProvider(
            query: query,
            status: 'open',
            type: 'specific',
          ));
        },
      );
    } else {
      ref.invalidate(discussionsProvider);
    }
  }
}
