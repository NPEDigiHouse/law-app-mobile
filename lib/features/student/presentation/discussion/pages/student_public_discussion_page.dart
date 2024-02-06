import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/helpers/function_helper.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/dummies_data.dart';
import 'package:law_app/features/shared/widgets/custom_filter_chip.dart';
import 'package:law_app/features/shared/widgets/custom_information.dart';
import 'package:law_app/features/shared/widgets/discussion_card.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';
import 'package:law_app/features/shared/widgets/text_field/search_field.dart';

final isSearchingProvider = StateProvider.autoDispose<bool>((ref) => false);

class StudentPublicDiscussionPage extends ConsumerStatefulWidget {
  const StudentPublicDiscussionPage({super.key});

  @override
  ConsumerState<StudentPublicDiscussionPage> createState() =>
      _StudentPublicDiscussionPageState();
}

class _StudentPublicDiscussionPageState
    extends ConsumerState<StudentPublicDiscussionPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController fabAnimationController;
  late final ScrollController scrollController;

  late final List<String> questionCategories;
  late final ValueNotifier<String> selectedCategory;

  late final ValueNotifier<String> searchQuery;
  late List<Question> questionList;

  @override
  void initState() {
    super.initState();

    fabAnimationController = AnimationController(
      vsync: this,
      duration: kThemeAnimationDuration,
    );

    scrollController = ScrollController()
      ..addListener(() {
        if (scrollController.offset == 0) {
          fabAnimationController.reverse();
        }
      });

    questionCategories = [
      'Semua',
      'Pidana',
      'Tata Negara',
      'Syariah',
      'Lainnya',
    ];

    selectedCategory = ValueNotifier(questionCategories[0]);
    searchQuery = ValueNotifier('');
    questionList = questions;
  }

  @override
  void dispose() {
    super.dispose();

    fabAnimationController.dispose();
    scrollController.dispose();
    selectedCategory.dispose();
    searchQuery.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSearching = ref.watch(isSearchingProvider);
    final items = isSearching ? questionList : questions;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        handleSearchingOnPop(didPop, isSearching);
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(isSearching ? 124 : 96),
          child: buildHeaderContainer(isSearching),
        ),
        body: NotificationListener<UserScrollNotification>(
          onNotification: (notification) {
            return FunctionHelper.handleFabVisibilityOnScroll(
              notification,
              fabAnimationController,
            );
          },
          child: CustomScrollView(
            controller: scrollController,
            slivers: [
              if (items.isNotEmpty)
                SliverAppBar(
                  pinned: true,
                  toolbarHeight: 64,
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.transparent,
                  surfaceTintColor: Colors.transparent,
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
                        return ValueListenableBuilder(
                          valueListenable: selectedCategory,
                          builder: (context, category, child) {
                            return CustomFilterChip(
                              label: questionCategories[index],
                              selected: category == questionCategories[index],
                              onSelected: (_) {
                                selectedCategory.value =
                                    questionCategories[index];
                              },
                            );
                          },
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(width: 8);
                      },
                      itemCount: questionCategories.length,
                    ),
                  ),
                ),
              if (isSearching)
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  sliver: SliverToBoxAdapter(
                    child: GestureDetector(
                      onTap: () {
                        ref.read(isSearchingProvider.notifier).state = false;
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgAsset(
                            assetPath: AssetPath.getIcon('caret-line-left.svg'),
                            color: secondaryTextColor,
                            width: 18,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Kembali',
                            style: textTheme.labelLarge!.copyWith(
                              fontWeight: FontWeight.w600,
                              color: secondaryTextColor,
                              height: 0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              Builder(
                builder: (context) {
                  if (isSearching && questionList.isEmpty) {
                    return const SliverFillRemaining(
                      child: CustomInformation(
                        illustrationName: 'discussion-cuate.svg',
                        title: 'Diskusi tidak ditemukan',
                        subtitle:
                            'Judul diskusi/pertanyaan umum tersebut tidak ditemukan.',
                      ),
                    );
                  }

                  return SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: index == items.length - 1 ? 0 : 8,
                            ),
                            child: DiscussionCard(
                              question: items[index],
                              isDetail: true,
                              withProfile: true,
                            ),
                          );
                        },
                        childCount: items.length,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        floatingActionButton: ScaleTransition(
          scale: fabAnimationController,
          alignment: Alignment.bottomCenter,
          child: FloatingActionButton.small(
            onPressed: () => scrollController.jumpTo(0),
            elevation: 2,
            backgroundColor: secondaryColor,
            tooltip: 'Kembali ke atas',
            child: SvgAsset(
              assetPath: AssetPath.getIcon('caret-line-up.svg'),
              color: primaryColor,
              width: 20,
            ),
          ),
        ),
      ),
    );
  }

  HeaderContainer buildHeaderContainer(bool isSearching) {
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
            ValueListenableBuilder(
              valueListenable: searchQuery,
              builder: (context, query, child) {
                return SearchField(
                  text: query,
                  hintText: 'Cari judul diskusi',
                  autoFocus: true,
                  onChanged: searchDiscussion,
                  onFocusChanged: (value) {
                    if (!value && query.isEmpty) {
                      ref.read(isSearchingProvider.notifier).state = false;
                    }
                  },
                );
              },
            ),
          ],
        ),
      );
    }

    return HeaderContainer(
      title: 'Diskusi Umum',
      withBackButton: true,
      withTrailingButton: true,
      trailingButtonIconName: 'search-line.svg',
      trailingButtonTooltip: 'Cari',
      onPressedTrailingButton: () {
        ref.read(isSearchingProvider.notifier).state = true;
      },
    );
  }

  void searchDiscussion(String query) {
    searchQuery.value = query;

    EasyDebounce.debounce(
      'search-debouncer',
      const Duration(milliseconds: 800),
      () {
        final result = questions.where((question) {
          final queryLower = query.toLowerCase();
          final titleLower = question.title.toLowerCase();

          return titleLower.contains(queryLower);
        }).toList();

        setState(() => questionList = result);
      },
    );

    if (query.isEmpty) {
      EasyDebounce.fire('search-debouncer');
    }
  }

  void handleSearchingOnPop(bool didPop, bool isSearching) {
    if (didPop) return;

    if (isSearching) {
      ref.read(isSearchingProvider.notifier).state = false;
    } else {
      navigatorKey.currentState!.pop();
    }
  }
}
