// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:law_app/core/enums/banner_type.dart';

// Project imports:
import 'package:law_app/core/enums/question_type.dart';
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/helpers/function_helper.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/shared/pages/discussion_list_page.dart';
import 'package:law_app/features/shared/providers/discussion_filter_provider.dart';
import 'package:law_app/features/shared/providers/discussion_providers/get_discussions_provider.dart';
import 'package:law_app/features/shared/providers/offset_provider.dart';
import 'package:law_app/features/shared/providers/search_provider.dart';
import 'package:law_app/features/shared/widgets/custom_filter_chip.dart';
import 'package:law_app/features/shared/widgets/custom_information.dart';
import 'package:law_app/features/shared/widgets/form_field/search_field.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/loading_indicator.dart';

class AdminDiscussionHomePage extends ConsumerStatefulWidget {
  const AdminDiscussionHomePage({super.key});

  @override
  ConsumerState<AdminDiscussionHomePage> createState() =>
      _AdminDiscussionHomePageState();
}

class _AdminDiscussionHomePageState
    extends ConsumerState<AdminDiscussionHomePage> {
  late final ValueNotifier<QuestionType> selectedType;
  late final PageController pageController;

  @override
  void initState() {
    super.initState();

    selectedType = ValueNotifier(QuestionType.general);
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();

    selectedType.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSearching = ref.watch(isSearchingProvider);
    final query = ref.watch(queryProvider);
    final type = ref.watch(discussionTypeProvider);
    final status = ref.watch(discussionStatusProvider);
    final offset = ref.watch(offsetProvider);

    final labels = discussionStatus.keys.toList();

    final discussions = ref.watch(
      GetDiscussionsProvider(
        query: query,
        type: type,
        status: status,
      ),
    );

    ref.listen(
      GetDiscussionsProvider(
        query: query,
        type: type,
        status: status,
      ),
      (_, state) {
        state.when(
          error: (error, _) {
            if ('$error' == kNoInternetConnection) {
              context.showNetworkErrorModalBottomSheet(
                onPressedPrimaryButton: () {
                  navigatorKey.currentState!.pop();
                  ref.invalidate(getDiscussionsProvider);
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
          provider: GetDiscussionsProvider(
            type: type,
            status: status,
          ),
        );
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(isSearching ? 220 : 180),
          child: SizedBox(
            height: isSearching ? 220 : 180,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: Container(
                    color: scaffoldBackgroundColor,
                  ),
                ),
                buildHeaderContainer(isSearching, query, type, status),
                Positioned(
                  left: 20,
                  right: 20,
                  bottom: 20,
                  child: ValueListenableBuilder(
                    valueListenable: selectedType,
                    builder: (context, type, child) {
                      return SegmentedButton<QuestionType>(
                        segments: const [
                          ButtonSegment(
                            value: QuestionType.general,
                            label: Text('Pertanyaan Umum'),
                          ),
                          ButtonSegment(
                            value: QuestionType.specific,
                            label: Text('Pertanyaan Khusus'),
                          ),
                        ],
                        selected: {type},
                        showSelectedIcon: false,
                        onSelectionChanged: (newSelection) {
                          selectedType.value = newSelection.first;

                          pageController.animateToPage(
                            newSelection.first.index,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                          );

                          ref.read(discussionTypeProvider.notifier).state =
                              newSelection.first.name;
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        body: CustomScrollView(
          physics: const NeverScrollableScrollPhysics(),
          slivers: [
            SliverAppBar(
              pinned: true,
              toolbarHeight: 64,
              automaticallyImplyLeading: false,
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  color: scaffoldBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.1),
                      offset: const Offset(0, 2),
                      blurRadius: 4,
                      spreadRadius: -1,
                    ),
                  ],
                ),
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return CustomFilterChip(
                      label: labels[index],
                      selected: status == discussionStatus[labels[index]],
                      onSelected: (_) {
                        ref.read(discussionStatusProvider.notifier).state =
                            discussionStatus[labels[index]]!;
                      },
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(width: 8);
                  },
                  itemCount: discussionStatus.length,
                ),
              ),
            ),
            discussions.when(
              loading: () => const SliverFillRemaining(
                child: LoadingIndicator(),
              ),
              error: (_, __) => const SliverFillRemaining(),
              data: (data) {
                final discussions = data.discussions;
                final hasMore = data.hasMore;

                if (discussions == null || hasMore == null) {
                  return const SliverFillRemaining();
                }

                if (isSearching && query.isNotEmpty && discussions.isEmpty) {
                  return const SliverFillRemaining(
                    child: CustomInformation(
                      illustrationName: 'discussion-cuate.svg',
                      title: 'Diskusi tidak ditemukan',
                      subtitle: 'Judul diskusi tersebut tidak ditemukan.',
                    ),
                  );
                }

                return SliverFillRemaining(
                  child: PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: pageController,
                    onPageChanged: (index) {
                      switch (index) {
                        case 0:
                          selectedType.value = QuestionType.general;
                          break;
                        case 1:
                          selectedType.value = QuestionType.specific;
                          break;
                      }
                    },
                    children: [
                      DiscussionListPage(
                        discussions: discussions,
                        isDetail: true,
                        withProfile: true,
                        hasMore: hasMore,
                        onFetchMoreItems: () => fetchMoreDiscussions(
                          query,
                          type,
                          status,
                          offset,
                        ),
                      ),
                      DiscussionListPage(
                        discussions: discussions,
                        isDetail: true,
                        withProfile: true,
                        hasMore: hasMore,
                        onFetchMoreItems: () => fetchMoreDiscussions(
                          query,
                          type,
                          status,
                          offset,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  HeaderContainer buildHeaderContainer(
    bool isSearching,
    String query,
    String type,
    String status,
  ) {
    if (isSearching) {
      return HeaderContainer(
        child: Column(
          children: [
            Text(
              'Cari Diskusi',
              style: textTheme.titleMedium!.copyWith(
                color: scaffoldBackgroundColor,
              ),
            ),
            const SizedBox(height: 10),
            SearchField(
              text: query,
              hintText: 'Cari judul diskusi',
              autoFocus: true,
              onChanged: (query) => searchDiscussion(query, type, status),
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
      title: 'Kelola Pertanyaan',
      withBackButton: true,
      withTrailingButton: true,
      trailingButtonIconName: "search-line.svg",
      trailingButtonTooltip: "Cari",
      onPressedTrailingButton: () {
        ref.read(isSearchingProvider.notifier).state = true;
      },
    );
  }

  void fetchMoreDiscussions(
    String query,
    String type,
    String status,
    int offset,
  ) {
    ref
        .read(GetDiscussionsProvider(
          query: query,
          type: type,
          status: status,
        ).notifier)
        .fetchMoreDiscussions(
          query: query,
          type: type,
          status: status,
          offset: offset,
        );

    ref.read(offsetProvider.notifier).state = offset + 20;
  }

  void searchDiscussion(
    String query,
    String type,
    String status,
  ) {
    ref.read(queryProvider.notifier).state = query;

    if (query.isNotEmpty) {
      EasyDebounce.debounce(
        'search-debouncer',
        const Duration(milliseconds: 800),
        () {
          ref.read(GetDiscussionsProvider(
            query: query,
            type: type,
            status: status,
          ));

          ref.invalidate(offsetProvider);
        },
      );
    } else {
      ref.invalidate(getDiscussionsProvider);
    }
  }
}
