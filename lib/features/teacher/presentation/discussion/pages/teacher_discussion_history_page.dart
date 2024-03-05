// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:law_app/core/enums/banner_type.dart';
import 'package:law_app/core/enums/question_status.dart';
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/extensions/string_extension.dart';
import 'package:law_app/core/helpers/function_helper.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/shared/pages/discussion_list_page.dart';
import 'package:law_app/features/shared/providers/discussion_filter_provider.dart';
import 'package:law_app/features/shared/providers/discussion_providers/user_discussions_provider.dart';
import 'package:law_app/features/shared/providers/search_provider.dart';
import 'package:law_app/features/shared/widgets/custom_information.dart';
import 'package:law_app/features/shared/widgets/feature/discussion_card.dart';
import 'package:law_app/features/shared/widgets/form_field/search_field.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/loading_indicator.dart';

class TeacherDiscussionHistoryPage extends ConsumerStatefulWidget {
  const TeacherDiscussionHistoryPage({super.key});

  @override
  ConsumerState<TeacherDiscussionHistoryPage> createState() =>
      _TeacherQuestionHistoryPageState();
}

class _TeacherQuestionHistoryPageState
    extends ConsumerState<TeacherDiscussionHistoryPage> {
  late final ValueNotifier<QuestionStatus> selectedStatus;
  late final PageController pageController;

  @override
  void initState() {
    super.initState();

    selectedStatus = ValueNotifier(QuestionStatus.discuss);
    pageController = PageController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(discussionStatusProvider.notifier).state =
          discussionStatus[selectedStatus.value.name.toCapitalize()]!;
    });
  }

  @override
  void dispose() {
    super.dispose();

    selectedStatus.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSearching = ref.watch(isSearchingProvider);
    final query = ref.watch(queryProvider);
    final status = ref.watch(discussionStatusProvider);

    final discussions = ref.watch(
      UserDiscussionsProvider(
        query: query,
        status: status,
        type: 'specific',
      ),
    );

    ref.listen(
      UserDiscussionsProvider(
        query: query,
        status: status,
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
            status: status,
            type: 'specific',
          ),
        );
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(isSearching ? 124 : 180),
          child: buildHeaderContainer(isSearching, query),
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

              final items =
                  discussions.where((e) => e.status != 'open').toList();

              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                itemBuilder: (context, index) {
                  return DiscussionCard(
                    discussion: items[index],
                    isDetail: true,
                    withProfile: true,
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 8);
                },
                itemCount: items.length,
              );
            }

            return PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: pageController,
              onPageChanged: (index) {
                switch (index) {
                  case 0:
                    selectedStatus.value = QuestionStatus.discuss;
                    break;
                  case 1:
                    selectedStatus.value = QuestionStatus.solved;
                    break;
                }
              },
              children: [
                DiscussionListPage(
                  discussions: discussions,
                  isDetail: true,
                  withProfile: true,
                ),
                DiscussionListPage(
                  discussions: discussions,
                  isDetail: true,
                  withProfile: true,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget buildHeaderContainer(bool isSearching, String query) {
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
              onChanged: searchDiscussion,
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
            child: ValueListenableBuilder(
              valueListenable: selectedStatus,
              builder: (context, type, child) {
                return SegmentedButton<QuestionStatus>(
                  segments: const [
                    ButtonSegment(
                      value: QuestionStatus.discuss,
                      label: Text('Dalam Diskusi'),
                    ),
                    ButtonSegment(
                      value: QuestionStatus.solved,
                      label: Text('Telah Selesai'),
                    ),
                  ],
                  selected: {type},
                  showSelectedIcon: false,
                  onSelectionChanged: (newSelection) {
                    final newValue = newSelection.first;

                    selectedStatus.value = newValue;

                    pageController.animateToPage(
                      newSelection.first.index - 1,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );

                    ref.read(discussionStatusProvider.notifier).state =
                        discussionStatus[newValue.name.toCapitalize()]!;
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void searchDiscussion(String query) {
    ref.read(queryProvider.notifier).state = query;

    if (query.isNotEmpty) {
      EasyDebounce.debounce(
        'search-debouncer',
        const Duration(milliseconds: 800),
        () {
          ref.read(UserDiscussionsProvider(
            query: query,
            type: 'specific',
          ));
        },
      );
    } else {
      ref.invalidate(userDiscussionsProvider);
    }
  }
}
