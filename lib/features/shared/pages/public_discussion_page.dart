// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:after_layout/after_layout.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:law_app/core/enums/banner_type.dart';
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/helpers/category_helper.dart';
import 'package:law_app/core/helpers/function_helper.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/shared/providers/discussion_providers/discussion_provider.dart';
import 'package:law_app/features/shared/providers/manual_providers/category_id_provider.dart';
import 'package:law_app/features/shared/providers/manual_providers/search_provider.dart';
import 'package:law_app/features/shared/widgets/animated_fab.dart';
import 'package:law_app/features/shared/widgets/custom_filter_chip.dart';
import 'package:law_app/features/shared/widgets/custom_information.dart';
import 'package:law_app/features/shared/widgets/feature/discussion_card.dart';
import 'package:law_app/features/shared/widgets/form_field/search_field.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/loading_indicator.dart';

class PublicDiscussionPage extends ConsumerStatefulWidget {
  const PublicDiscussionPage({super.key});

  @override
  ConsumerState<PublicDiscussionPage> createState() =>
      _PublicDiscussionPageState();
}

class _PublicDiscussionPageState extends ConsumerState<PublicDiscussionPage>
    with SingleTickerProviderStateMixin, AfterLayoutMixin {
  late final AnimationController fabAnimationController;
  late final ScrollController scrollController;

  Map<String, int?> categories = {'Semua': null};

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
  }

  @override
  Future<void> afterFirstLayout(BuildContext context) async {
    context.showLoadingDialog();

    final result = await CategoryHelper.getDiscussionCategories(ref);

    for (var e in result) {
      categories[e.name!] = e.id!;
    }

    navigatorKey.currentState!.pop();
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();

    fabAnimationController.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final labels = categories.keys.toList();
    final isSearching = ref.watch(isSearchingProvider);
    final query = ref.watch(queryProvider);
    final categoryId = ref.watch(categoryIdProvider);

    final discussions = ref.watch(
      DiscussionProvider(
        query: query,
        categoryId: categoryId,
        type: 'general',
      ),
    );

    ref.listen(
      DiscussionProvider(
        query: query,
        categoryId: categoryId,
        type: 'general',
      ),
      (_, state) {
        state.whenOrNull(
          error: (error, _) {
            if ('$error' == kNoInternetConnection) {
              context.showNetworkErrorModalBottomSheet(
                onPressedPrimaryButton: () {
                  navigatorKey.currentState!.pop();
                  ref.invalidate(discussionProvider);
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
          provider: DiscussionProvider(
            query: query,
            categoryId: categoryId,
            type: 'general',
          ),
        );
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(isSearching ? 124 : 96),
          child: Container(
            color: scaffoldBackgroundColor,
            child: buildHeaderContainer(isSearching, query, categoryId),
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
                        selected: categoryId == categories[labels[index]],
                        onSelected: (_) {
                          ref.read(categoryIdProvider.notifier).state =
                              categories[labels[index]];
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

                  if (discussions.isEmpty) {
                    return const SliverFillRemaining(
                      child: CustomInformation(
                        illustrationName: 'house-searching-cuate.svg',
                        title: 'Belum ada diskusi',
                      ),
                    );
                  }

                  return SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (index >= discussions.length) {
                            return buildFetchMoreButton(
                              query,
                              categoryId,
                              discussions.length,
                            );
                          }

                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: index == discussions.length - 1 ? 0 : 8,
                            ),
                            child: DiscussionCard(
                              discussion: discussions[index],
                              isDetail: true,
                              withProfile: true,
                            ),
                          );
                        },
                        childCount: hasMore
                            ? discussions.length + 1
                            : discussions.length,
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

  HeaderContainer buildHeaderContainer(
    bool isSearching,
    String query,
    int? categoryId,
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
              onChanged: (query) => searchDiscussion(query, categoryId),
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

  TextButton buildFetchMoreButton(
    String query,
    int? categoryId,
    int currentLength,
  ) {
    return TextButton(
      onPressed: () {
        ref
            .read(DiscussionProvider(
              query: query,
              categoryId: categoryId,
              type: 'general',
            ).notifier)
            .fetchMoreDiscussions(
              query: query,
              categoryId: categoryId,
              type: 'general',
              offset: currentLength,
            );
      },
      child: const Text('Lihat lebih banyak'),
    );
  }

  void searchDiscussion(String query, int? categoryId) {
    if (query.isNotEmpty) {
      ref.read(
        DiscussionProvider(
          query: query,
          categoryId: categoryId,
          type: 'general',
        ),
      );
    } else {
      ref.invalidate(discussionProvider);
    }

    ref.read(queryProvider.notifier).state = query;
  }
}
