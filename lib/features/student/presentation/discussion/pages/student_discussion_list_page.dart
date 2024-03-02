// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:law_app/core/enums/banner_type.dart';
import 'package:law_app/core/enums/question_type.dart';
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/shared/pages/discussion_list_page.dart';
import 'package:law_app/features/shared/providers/discussion_filter_provider.dart';
import 'package:law_app/features/shared/providers/discussion_providers/get_user_discussions_provider.dart';
import 'package:law_app/features/shared/widgets/custom_filter_chip.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/loading_indicator.dart';

class StudentDiscussionListPage extends ConsumerStatefulWidget {
  const StudentDiscussionListPage({super.key});

  @override
  ConsumerState<StudentDiscussionListPage> createState() =>
      _StudentQuestionListPageState();
}

class _StudentQuestionListPageState
    extends ConsumerState<StudentDiscussionListPage> {
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
    final status = ref.watch(discussionStatusProvider);
    final type = ref.watch(discussionTypeProvider);

    final labels = discussionStatus.keys.toList();

    final discussions = ref.watch(
      GetUserDiscussionsProvider(status: status, type: type),
    );

    ref.listen(
      GetUserDiscussionsProvider(status: status, type: type),
      (_, state) {
        state.when(
          error: (error, _) {
            if ('$error' == kNoInternetConnection) {
              context.showNetworkErrorModalBottomSheet(
                onPressedPrimaryButton: () {
                  navigatorKey.currentState!.pop();
                  ref.invalidate(getUserDiscussionsProvider);
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

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(180),
        child: SizedBox(
          height: 180,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: Container(
                  color: scaffoldBackgroundColor,
                ),
              ),
              const HeaderContainer(
                title: 'Pertanyaan Saya',
                withBackButton: true,
                height: 180,
              ),
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
            data: (discussions) {
              if (discussions == null) {
                return const SliverFillRemaining();
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
                    DiscussionListPage(discussions: discussions),
                    DiscussionListPage(discussions: discussions),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
