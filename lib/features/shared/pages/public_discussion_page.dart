// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:law_app/core/helpers/function_helper.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/dummies_data.dart';
import 'package:law_app/features/shared/providers/search_provider.dart';
import 'package:law_app/features/shared/widgets/animated_fab.dart';
import 'package:law_app/features/shared/widgets/custom_filter_chip.dart';
import 'package:law_app/features/shared/widgets/custom_information.dart';
import 'package:law_app/features/shared/widgets/feature/discussion_card.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/text_field/search_field.dart';

class PublicDiscussionPage extends ConsumerStatefulWidget {
  final String role;

  const PublicDiscussionPage({super.key, required this.role});

  @override
  ConsumerState<PublicDiscussionPage> createState() =>
      _PublicDiscussionPageState();
}

class _PublicDiscussionPageState extends ConsumerState<PublicDiscussionPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController fabAnimationController;
  late final ScrollController scrollController;

  late final List<String> categories;
  late final ValueNotifier<String> selectedCategory;

  late final ValueNotifier<String> query;
  late List<Question> questions;

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

    categories = [
      'Semua',
      'Pidana',
      'Tata Negara',
      'Syariah',
      'Lainnya',
    ];

    selectedCategory = ValueNotifier(categories.first);
    query = ValueNotifier('');
    questions = dummyQuestions;
  }

  @override
  void dispose() {
    super.dispose();

    fabAnimationController.dispose();
    scrollController.dispose();
    selectedCategory.dispose();
    query.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSearching = ref.watch(isSearchingProvider);
    final items = isSearching ? questions : dummyQuestions;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        return FunctionHelper.handleSearchingOnPop(ref, didPop, isSearching);
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(isSearching ? 124 : 96),
          child: Container(
            color: scaffoldBackgroundColor,
            child: buildHeaderContainer(isSearching),
          ),
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
                              label: categories[index],
                              selected: category == categories[index],
                              onSelected: (_) {
                                selectedCategory.value = categories[index];
                              },
                            );
                          },
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(width: 8);
                      },
                      itemCount: categories.length,
                    ),
                  ),
                ),
              Builder(
                builder: (context) {
                  if (isSearching && questions.isEmpty) {
                    return const SliverFillRemaining(
                      child: CustomInformation(
                        illustrationName: 'discussion-cuate.svg',
                        title: 'Diskusi tidak ditemukan',
                        subtitle: 'Judul diskusi tersebut tidak ditemukan.',
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
                              role: widget.role,
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
        floatingActionButton: AnimatedFloatingActionButton(
          fabAnimationController: fabAnimationController,
          scrollController: scrollController,
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
              valueListenable: query,
              builder: (context, query, child) {
                return SearchField(
                  text: query,
                  hintText: 'Cari judul diskusi',
                  autoFocus: true,
                  onChanged: searchDiscussion,
                  onFocusChange: (isFocus) {
                    if (!isFocus && query.isEmpty) {
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
    this.query.value = query;

    EasyDebounce.debounce(
      'search-debouncer',
      const Duration(milliseconds: 800),
      () {
        final result = dummyQuestions.where((question) {
          final queryLower = query.toLowerCase();
          final titleLower = question.title.toLowerCase();

          return titleLower.contains(queryLower);
        }).toList();

        setState(() => questions = result);
      },
    );

    if (query.isEmpty) {
      EasyDebounce.fire('search-debouncer');
    }
  }
}
