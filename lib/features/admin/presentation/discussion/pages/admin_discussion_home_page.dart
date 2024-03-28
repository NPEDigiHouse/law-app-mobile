// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:law_app/core/enums/banner_type.dart';
import 'package:law_app/core/enums/discussion_type.dart';
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/helpers/function_helper.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/shared/pages/discussion_list_page.dart';
import 'package:law_app/features/shared/providers/discussion_providers/discussion_provider.dart';
import 'package:law_app/features/shared/providers/manual_providers/discussion_filter_provider.dart';
import 'package:law_app/features/shared/providers/manual_providers/search_provider.dart';
import 'package:law_app/features/shared/widgets/custom_filter_chip.dart';
import 'package:law_app/features/shared/widgets/form_field/search_field.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/loading_indicator.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class AdminDiscussionHomePage extends ConsumerStatefulWidget {
  const AdminDiscussionHomePage({super.key});

  @override
  ConsumerState<AdminDiscussionHomePage> createState() =>
      _AdminDiscussionHomePageState();
}

class _AdminDiscussionHomePageState
    extends ConsumerState<AdminDiscussionHomePage> {
  late final ValueNotifier<DiscussionType> selectedType;

  @override
  void initState() {
    super.initState();

    selectedType = ValueNotifier(DiscussionType.general);
  }

  @override
  void dispose() {
    super.dispose();

    selectedType.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final labels = discussionStatus.keys.toList();
    final isSearching = ref.watch(isSearchingProvider);
    final query = ref.watch(queryProvider);
    final type = ref.watch(discussionTypeProvider);
    final status = ref.watch(discussionStatusProvider);

    final discussions = ref.watch(
      DiscussionProvider(
        query: query,
        type: type,
        status: status,
      ),
    );

    ref.listen(
      DiscussionProvider(
        query: query,
        type: type,
        status: status,
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
            type: type,
            status: status,
          ),
        );
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(isSearching ? 220 : 180),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: Container(
                  color: scaffoldBackgroundColor,
                ),
              ),
              buildHeaderContainer(isSearching, query, type, status),
            ],
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

                return SliverFillRemaining(
                  child: DiscussionListPage(
                    discussions: discussions,
                    isDetail: true,
                    withProfile: true,
                    hasMore: hasMore,
                    onFetchMoreItems: () => fetchMoreDiscussions(
                      query,
                      type,
                      status,
                      discussions.length,
                    ),
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
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(
                'Cari Diskusi',
                style: textTheme.titleMedium!.copyWith(
                  color: scaffoldBackgroundColor,
                ),
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
            const SizedBox(height: 16),
            buildSegmentedButton(),
            const SizedBox(height: 20),
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
                    'Kelola Pertanyaan',
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
          buildSegmentedButton(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  ValueListenableBuilder<DiscussionType> buildSegmentedButton() {
    return ValueListenableBuilder(
      valueListenable: selectedType,
      builder: (context, type, child) {
        return SegmentedButton<DiscussionType>(
          segments: const [
            ButtonSegment(
              value: DiscussionType.general,
              label: Text('Pertanyaan Umum'),
            ),
            ButtonSegment(
              value: DiscussionType.specific,
              label: Text('Pertanyaan Khusus'),
            ),
          ],
          selected: {type},
          showSelectedIcon: false,
          onSelectionChanged: (newSelection) {
            selectedType.value = newSelection.first;

            ref.read(discussionTypeProvider.notifier).state =
                newSelection.first.name;
          },
        );
      },
    );
  }

  void fetchMoreDiscussions(
    String query,
    String type,
    String status,
    int currentLength,
  ) {
    ref
        .read(DiscussionProvider(
          query: query,
          type: type,
          status: status,
        ).notifier)
        .fetchMoreDiscussions(
          query: query,
          type: type,
          status: status,
          offset: currentLength,
        );
  }

  void searchDiscussion(
    String query,
    String type,
    String status,
  ) {
    if (query.isNotEmpty) {
      ref.read(
        DiscussionProvider(
          query: query,
          type: type,
          status: status,
        ),
      );
    } else {
      ref.invalidate(discussionProvider);
    }

    ref.read(queryProvider.notifier).state = query;
  }
}
