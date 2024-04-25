// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:law_app/core/enums/banner_type.dart';
import 'package:law_app/core/enums/discussion_type.dart';
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/shared/pages/discussion_list_page.dart';
import 'package:law_app/features/shared/providers/discussion_providers/user_discussions_provider.dart';
import 'package:law_app/features/shared/providers/manual_providers/discussion_filter_provider.dart';
import 'package:law_app/features/shared/widgets/custom_filter_chip.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/loading_indicator.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class StudentDiscussionListPage extends ConsumerStatefulWidget {
  const StudentDiscussionListPage({super.key});

  @override
  ConsumerState<StudentDiscussionListPage> createState() => _StudentQuestionListPageState();
}

class _StudentQuestionListPageState extends ConsumerState<StudentDiscussionListPage> {
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
    final status = ref.watch(discussionStatusProvider);
    final type = ref.watch(discussionTypeProvider);

    final discussions = ref.watch(
      UserDiscussionsProvider(status: status, type: type),
    );

    ref.listen(
      UserDiscussionsProvider(status: status, type: type),
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

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(180),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: Container(
                color: scaffoldBackgroundColor,
              ),
            ),
            HeaderContainer(
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
                            'Pertanyaan Saya',
                            style: textTheme.titleLarge!.copyWith(
                              color: scaffoldBackgroundColor,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 40,
                        height: 40,
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  ValueListenableBuilder(
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

                          ref.read(discussionTypeProvider.notifier).state = newSelection.first.name;
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
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
            data: (discussions) {
              if (discussions == null) {
                return const SliverFillRemaining();
              }

              return SliverFillRemaining(
                child: DiscussionListPage(
                  discussions: discussions,
                  isDetail: true,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
