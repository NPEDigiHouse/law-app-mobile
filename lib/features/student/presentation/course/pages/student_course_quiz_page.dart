import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:law_app/core/extensions/button_extension.dart';
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/helpers/function_helper.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/dummies_data.dart';
import 'package:law_app/features/shared/providers/count_down_timer_provider.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';
import 'package:law_app/features/student/presentation/course/widgets/option_card.dart';

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
      error: (error, stackTrace) => null,
      loading: () => null,
    );

    ref.listen(timerProvider, (previous, next) {
      if (next.value == 0) {
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
                        return QuestionPage(
                          number: index + 1,
                          item: widget.items[index],
                          isFirst: page == 0,
                          isLast: page == widget.items.length - 1,
                          onPressedPreviousButton: () {
                            pageController.jumpToPage(page - 1);
                          },
                          onPressedNextButton: () {
                            pageController.jumpToPage(page + 1);
                          },
                          onOptionChanged: (option) => results[index] = option,
                          results:
                              page == widget.items.length - 1 ? results : null,
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

class StudentCourseQuizArgs {
  final int duration;
  final List<Item> items;

  const StudentCourseQuizArgs({
    required this.duration,
    required this.items,
  });
}

class QuestionPage extends StatefulWidget {
  final int number;
  final Item item;
  final bool isFirst;
  final bool isLast;
  final VoidCallback onPressedPreviousButton;
  final VoidCallback onPressedNextButton;
  final ValueChanged<String> onOptionChanged;
  final List<String>? results;

  const QuestionPage({
    super.key,
    required this.number,
    required this.item,
    required this.isFirst,
    required this.isLast,
    required this.onPressedPreviousButton,
    required this.onPressedNextButton,
    required this.onOptionChanged,
    this.results,
  });

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage>
    with AutomaticKeepAliveClientMixin {
  late final ValueNotifier<String?> selectedOption;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    selectedOption = ValueNotifier(null);
  }

  @override
  void dispose() {
    super.dispose();

    selectedOption.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      shrinkWrap: true,
      children: [
        Text(
          'Soal No. ${widget.number}',
          style: textTheme.titleLarge!.copyWith(
            color: primaryColor,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 4,
            bottom: 16,
          ),
          child: Text(widget.item.question),
        ),
        ...List<ValueListenableBuilder<String?>>.generate(
          widget.item.answers.length,
          (index) => ValueListenableBuilder(
            valueListenable: selectedOption,
            builder: (context, option, child) {
              final options = widget.item.answers.keys.toList();
              final values = widget.item.answers.values.toList();

              return Padding(
                padding: EdgeInsets.only(
                  bottom: index == options.length - 1 ? 0 : 8,
                ),
                child: OptionCard(
                  label: '${options[index]}. ${values[index]}',
                  selected: option == options[index],
                  onSelected: (_) {
                    selectedOption.value = options[index];
                    widget.onOptionChanged(options[index]);
                  },
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Visibility(
              visible: !widget.isFirst,
              replacement: const SizedBox(
                width: 36,
                height: 36,
              ),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: secondaryColor,
                ),
                child: IconButton(
                  onPressed: widget.onPressedPreviousButton,
                  icon: SvgAsset(
                    assetPath: AssetPath.getIcon('caret-line-left.svg'),
                    color: primaryColor,
                    width: 20,
                  ),
                  tooltip: 'Sebelumnya',
                ),
              ),
            ),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: secondaryColor,
              ),
              child: IconButton(
                onPressed: () {},
                icon: SvgAsset(
                  assetPath: AssetPath.getIcon('grid-view-solid.svg'),
                  color: primaryColor,
                  width: 20,
                ),
                tooltip: 'Navigasi Soal',
              ),
            ),
            Visibility(
              visible: !widget.isLast,
              replacement: const SizedBox(
                width: 36,
                height: 36,
              ),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: secondaryColor,
                ),
                child: IconButton(
                  onPressed: widget.onPressedNextButton,
                  icon: SvgAsset(
                    assetPath: AssetPath.getIcon('caret-line-right.svg'),
                    color: primaryColor,
                    width: 20,
                  ),
                  tooltip: 'Selanjutnya',
                ),
              ),
            ),
          ],
        ),
        if (widget.isLast) ...[
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () {
              if (widget.results!.contains('')) {
                context.showCustomAlertDialog(
                  title: 'Submit Quiz?',
                  message:
                      'Masih terdapat pertanyaan yang belum dijawab! Yakin ingin mengumpulkan quiz sekarang?',
                  primaryButtonText: 'Submit',
                  onPressedPrimaryButton: () {
                    navigatorKey.currentState!.pop();
                    navigatorKey.currentState!.pop(widget.results);
                  },
                );
              } else {
                context.showConfirmDialog(
                  title: 'Submit Quiz?',
                  message: 'Pastikan kamu yakin dengan semua jawaban kamu.',
                  primaryButtonText: 'Submit',
                  onPressedPrimaryButton: () {
                    navigatorKey.currentState!.pop();
                    navigatorKey.currentState!.pop(widget.results);
                  },
                );
              }
            },
            child: const Text('Submit Quiz!'),
          ).fullWidth(),
        ],
      ],
    );
  }
}
