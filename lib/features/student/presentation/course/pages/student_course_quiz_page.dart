// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:law_app/core/enums/banner_type.dart';
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/helpers/function_helper.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/admin/data/models/course_models/quiz_model.dart';
import 'package:law_app/features/shared/providers/course_providers/question_provider.dart';
import 'package:law_app/features/shared/providers/generated_providers/count_down_timer_provider.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/loading_indicator.dart';
import 'package:law_app/features/student/presentation/course/widgets/question_view.dart';

final answersProvider = StateProvider<List<Map<String, int?>>>((ref) => []);

class StudentCourseQuizPage extends ConsumerStatefulWidget {
  final QuizModel quiz;

  const StudentCourseQuizPage({super.key, required this.quiz});

  @override
  ConsumerState<StudentCourseQuizPage> createState() => _StudentCourseQuizPageState();
}

class _StudentCourseQuizPageState extends ConsumerState<StudentCourseQuizPage> {
  late final ValueNotifier<int> selectedPage;
  late final PageController pageController;

  @override
  void initState() {
    super.initState();

    selectedPage = ValueNotifier(0);
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();

    selectedPage.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final questions = ref.watch(QuestionProvider(quizId: widget.quiz.id!));
    final answers = ref.watch(answersProvider);

    ref.listen(QuestionProvider(quizId: widget.quiz.id!), (_, state) {
      state.whenOrNull(
        error: (error, _) {
          if ('$error' == kNoInternetConnection) {
            context.showNetworkErrorModalBottomSheet(
              onPressedPrimaryButton: () {
                navigatorKey.currentState!.pop();
                ref.invalidate(questionProvider);
              },
            );
          } else {
            context.showBanner(message: '$error', type: BannerType.error);
          }
        },
        data: (questions) {
          if (questions != null) {
            ref.read(answersProvider.notifier).state = List.generate(questions.length, (index) {
              return {
                'quizQuestionId': questions[index].id,
                'selectedAnswerId': null,
              };
            });
          }
        },
      );
    });

    return questions.when(
      loading: () => const LoadingIndicator(withScaffold: true),
      error: (_, __) => const Scaffold(),
      data: (questions) {
        if (questions == null) return const Scaffold();

        final timerProvider = CountDownTimerProvider(
          initialValue: widget.quiz.duration! * 60,
        );

        final timer = ref.watch(timerProvider);

        final seconds = timer.whenOrNull(
          data: (value) => value,
        );

        ref.listen(timerProvider, (_, state) {
          if (state.value == 0) {
            if (ModalRoute.of(context)?.isCurrent != true) {
              navigatorKey.currentState!.pop();
            }

            navigatorKey.currentState!.pop(answers);
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
                        questions.length,
                        (index) => ValueListenableBuilder(
                          valueListenable: selectedPage,
                          builder: (context, page, child) {
                            return QuestionView(
                              pageController: pageController,
                              currentPage: page,
                              questionId: questions[index].id!,
                              questionNumber: index + 1,
                              answers: answers,
                              onOptionChanged: (answer) => answers[index] = answer,
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
      },
    );
  }

  Color getColorByRemainingSeconds(int? seconds) {
    if (seconds == null) return scaffoldBackgroundColor;

    if (seconds < 30) return errorColor;

    if (seconds < 60) return warningColor;

    return primaryColor;
  }
}
