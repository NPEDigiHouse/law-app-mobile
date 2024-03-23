// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/helpers/function_helper.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/dummies_data.dart';
import 'package:law_app/features/shared/providers/generated_providers/count_down_timer_provider.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/student/presentation/course/widgets/item_view.dart';

class StudentCourseQuizPage extends ConsumerStatefulWidget {
  final int duration;
  final List<Item> items;

  const StudentCourseQuizPage({
    super.key,
    required this.duration,
    required this.items,
  });

  @override
  ConsumerState<StudentCourseQuizPage> createState() =>
      _StudentCourseQuizPageState();
}

class _StudentCourseQuizPageState extends ConsumerState<StudentCourseQuizPage> {
  late final ValueNotifier<int> selectedPage;
  late final PageController pageController;
  late List<String> results;

  @override
  void initState() {
    super.initState();

    selectedPage = ValueNotifier(0);
    pageController = PageController();
    results = List<String>.generate(widget.items.length, (_) => '');
  }

  @override
  void dispose() {
    super.dispose();

    selectedPage.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timerProvider = CountDownTimerProvider(
      initialValue: widget.duration * 60,
    );

    final timer = ref.watch(timerProvider);

    final seconds = timer.when<int?>(
      data: (value) => value,
      error: (_, __) => null,
      loading: () => null,
    );

    ref.listen(timerProvider, (_, state) {
      if (state.value == 0) {
        if (ModalRoute.of(context)?.isCurrent != true) {
          navigatorKey.currentState!.pop();
        }

        navigatorKey.currentState!.pop(results);
      }
    });

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;

        context.showConfirmDialog(
          title: 'Batalkan Quiz?',
          message: 'Apakah kamu yakin ingin membatalkan quiz ini?',
          primaryButtonText: 'Batalkan',
          onPressedPrimaryButton: () {
            context.back();
            navigatorKey.currentState!.pop();
          },
        );
      },
      child: Scaffold(
        body: NestedScrollView(
          physics: const NeverScrollableScrollPhysics(),
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              const SliverAppBar(
                pinned: true,
                toolbarHeight: 96,
                automaticallyImplyLeading: false,
                flexibleSpace: HeaderContainer(
                  title: 'Quiz',
                ),
              ),
            ];
          },
          body: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                sliver: SliverToBoxAdapter(
                  child: Center(
                    child: Container(
                      width: 80,
                      padding: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: getColorByRemainingSeconds(seconds),
                      ),
                      child: Center(
                        child: Text(
                          FunctionHelper.formattedCountDownTimer(seconds ?? 0),
                          style: textTheme.titleMedium!.copyWith(
                            color: scaffoldBackgroundColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SliverFillRemaining(
                child: PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: pageController,
                  onPageChanged: (index) => selectedPage.value = index,
                  children: List<ValueListenableBuilder<int>>.generate(
                    widget.items.length,
                    (index) => ValueListenableBuilder(
                      valueListenable: selectedPage,
                      builder: (context, page, child) {
                        return ItemView(
                          pageController: pageController,
                          currentPage: page,
                          number: index + 1,
                          item: widget.items[index],
                          onOptionChanged: (option) => results[index] = option,
                          results: results,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color getColorByRemainingSeconds(int? seconds) {
    if (seconds == null) return scaffoldBackgroundColor;

    if (seconds < 30) return errorColor;

    if (seconds < 60) return warningColor;

    return primaryColor;
  }
}

class StudentCourseQuizPageArgs {
  final int duration;
  final List<Item> items;

  const StudentCourseQuizPageArgs({
    required this.duration,
    required this.items,
  });
}
