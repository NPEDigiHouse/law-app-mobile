// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:law_app/core/extensions/button_extension.dart';
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/dummies_data.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';
import 'package:law_app/features/student/presentation/course/widgets/item_navigation_bottom_sheet.dart';
import 'package:law_app/features/student/presentation/course/widgets/option_card.dart';

class ItemView extends StatefulWidget {
  final PageController pageController;
  final int currentPage;
  final int number;
  final Item item;
  final ValueChanged<String> onOptionChanged;
  final List<String> results;

  const ItemView({
    super.key,
    required this.pageController,
    required this.currentPage,
    required this.number,
    required this.item,
    required this.onOptionChanged,
    required this.results,
  });

  @override
  State<ItemView> createState() => _ItemViewState();
}

class _ItemViewState extends State<ItemView>
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
              visible: !(widget.currentPage == 0),
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
                  builder: (context) => ItemNavigationBottomSheet(
                    length: widget.results.length,
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
              visible: !(widget.currentPage == widget.results.length - 1),
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
        if (widget.currentPage == widget.results.length - 1) ...[
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () {
              if (widget.results.contains('')) {
                context.showCustomAlertDialog(
                  title: 'Submit Quiz?',
                  message:
                      'Kamu masih memiliki pertanyaan yang belum dijawab! Yakin ingin mengumpulkan quiz sekarang?',
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
