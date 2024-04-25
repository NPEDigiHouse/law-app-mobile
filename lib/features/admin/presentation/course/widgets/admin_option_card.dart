// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/admin/data/models/course_models/option_model.dart';
import 'package:law_app/features/shared/providers/course_providers/option_actions_provider.dart';
import 'package:law_app/features/shared/widgets/custom_icon_button.dart';
import 'package:law_app/features/shared/widgets/ink_well_container.dart';

class AdminOptionCard extends ConsumerWidget {
  final String optionKey;
  final OptionModel option;
  final bool isCorrectOption;
  final bool preventAction;

  const AdminOptionCard({
    super.key,
    required this.optionKey,
    required this.option,
    this.isCorrectOption = false,
    this.preventAction = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWellContainer(
      color: isCorrectOption ? successColor : scaffoldBackgroundColor,
      radius: 12,
      padding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 16,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.08),
          offset: const Offset(0, 1),
          blurRadius: 1,
          spreadRadius: 1,
        ),
      ],
      onTap: preventAction
          ? null
          : () => context.showSingleFormDialog(
                title: 'Edit Jawaban',
                name: 'title',
                label: 'Jawaban',
                hintText: 'Masukkan jawaban',
                initialValue: option.title,
                maxLines: 5,
                primaryButtonText: 'Edit',
                onSubmitted: (value) {
                  navigatorKey.currentState!.pop();

                  ref.read(optionActionsProvider.notifier).editOption(
                        option: option.copyWith(
                          title: value['title'],
                        ),
                      );
                },
              ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '$optionKey. ${option.title}',
              style: textTheme.bodyMedium!.copyWith(
                color: isCorrectOption ? scaffoldBackgroundColor : primaryColor,
              ),
            ),
          ),
          if (!preventAction) ...[
            const SizedBox(width: 8),
            CustomIconButton(
              iconName: 'trash-line.svg',
              color: errorColor,
              size: 20,
              onPressed: () => context.showConfirmDialog(
                title: 'Hapus Jawaban?',
                message: 'Anda yakin ingin menghapus jawaban ini?',
                primaryButtonText: 'Hapus',
                onPressedPrimaryButton: () {
                  navigatorKey.currentState!.pop();

                  ref.read(optionActionsProvider.notifier).deleteOption(id: option.id!);
                },
              ),
              tooltip: 'Hapus',
            ),
          ],
        ],
      ),
    );
  }
}
