// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:law_app/core/enums/banner_type.dart';
import 'package:law_app/core/extensions/button_extension.dart';
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/admin/data/models/course_models/option_model.dart';
import 'package:law_app/features/shared/providers/course_providers/question_detail_provider.dart';
import 'package:law_app/features/shared/widgets/loading_indicator.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';
import 'package:law_app/features/student/presentation/course/widgets/option_card.dart';
import 'package:law_app/features/student/presentation/course/widgets/question_navigation_bottom_sheet.dart';

class QuestionView extends ConsumerStatefulWidget {
  final PageController pageController;
  final int currentPage;
  final int questionId;
  final int questionNumber;
  final List<Map<String, int?>> answers;
  final ValueChanged<Map<String, int?>> onOptionChanged;

  const QuestionView({
    super.key,
    required this.pageController,
    required this.currentPage,
    required this.questionId,
    required this.questionNumber,
    required this.answers,
    required this.onOptionChanged,
  });

  @override
  ConsumerState<QuestionView> createState() => _QuestionViewState();
}

class _QuestionViewState extends ConsumerState<QuestionView> with AutomaticKeepAliveClientMixin {
  late final ValueNotifier<OptionModel?> selectedOption;

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

    final data = ref.watch(QuestionDetailProvider(id: widget.questionId));

    ref.listen(QuestionDetailProvider(id: widget.questionId), (_, state) {
      state.whenOrNull(
        error: (error, _) {
          context.showBanner(message: '$error', type: BannerType.error);
        },
      );
    });

    return data.when(
      loading: () => const LoadingIndicator(),
      error: (_, __) => const SizedBox(),
      data: (data) {
        final question = data.question;
        final options = data.options;

        if (question == null || options == null) return const SizedBox();

        final optionKeys = ['A', 'B', 'C', 'D'];

        return ListView(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          shrinkWrap: true,
          children: [
            Text(
              'Soal No. ${widget.questionNumber}',
              style: textTheme.titleLarge!.copyWith(
                color: primaryColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 4,
                bottom: 16,
              ),
              child: Text('${question.title}'),
            ),
            ...List<ValueListenableBuilder<OptionModel?>>.generate(
              options.length,
              (index) => ValueListenableBuilder(
                valueListenable: selectedOption,
                builder: (context, option, child) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: index == options.length - 1 ? 0 : 8,
                    ),
                    child: OptionCard(
                      label: '${optionKeys[index]}. ${options[index].title}',
                      selected: option == options[index],
                      onSelected: (_) {
                        selectedOption.value = options[index];

                        widget.onOptionChanged({
                          'quizQuestionId': question.id,
                          'selectedAnswerId': options[index].id,
                        });
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
                  visible: widget.currentPage != 0,
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
                      onPressed: () {
                        widget.pageController.jumpToPage(widget.currentPage - 1);
                      },
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
                    onPressed: () => showModalBottomSheet(
                      context: context,
                      enableDrag: false,
                      isScrollControlled: true,
                      builder: (context) => QuestionNavigationBottomSheet(
                        length: widget.answers.length,
                        onItemTapped: (index) {
                          widget.pageController.jumpToPage(index);
                          navigatorKey.currentState!.pop();
                        },
                      ),
                    ),
                    icon: SvgAsset(
                      assetPath: AssetPath.getIcon('grid-view-solid.svg'),
                      color: primaryColor,
                      width: 20,
                    ),
                    tooltip: 'Navigasi Soal',
                  ),
                ),
                Visibility(
                  visible: widget.currentPage != widget.answers.length - 1,
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
                      onPressed: () {
                        widget.pageController.jumpToPage(widget.currentPage + 1);
                      },
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
            if (widget.currentPage == widget.answers.length - 1) ...[
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () {
                  if (widget.answers.any((e) => e['selectedAnswerId'] == null)) {
                    context.showCustomAlertDialog(
                      title: 'Submit Quiz?',
                      message:
                          'Kamu masih memiliki pertanyaan yang belum dijawab! Anda yakin ingin mengumpulkan quiz sekarang?',
                      primaryButtonText: 'Submit',
                      onPressedPrimaryButton: () {
                        navigatorKey.currentState!.pop();
                        navigatorKey.currentState!.pop(widget.answers);
                      },
                    );
                  } else {
                    context.showConfirmDialog(
                      title: 'Submit Quiz?',
                      message: 'Pastikan kamu yakin dengan semua jawaban yang telah dipilih!',
                      primaryButtonText: 'Submit',
                      onPressedPrimaryButton: () {
                        navigatorKey.currentState!.pop();
                        navigatorKey.currentState!.pop(widget.answers);
                      },
                    );
                  }
                },
                child: const Text('Submit Quiz!'),
              ).fullWidth(),
            ],
          ],
        );
      },
    );
  }
}
