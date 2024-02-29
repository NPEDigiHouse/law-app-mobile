// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/routes/route_names.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/admin/data/models/glossary_model.dart';
import 'package:law_app/features/glossary/presentation/pages/glossary_detail_page.dart';
import 'package:law_app/features/glossary/presentation/providers/glossaries_provider.dart';
import 'package:law_app/features/shared/widgets/custom_icon_button.dart';
import 'package:law_app/features/shared/widgets/ink_well_container.dart';

class GlossaryCard extends ConsumerWidget {
  final GlossaryModel glossary;

  const GlossaryCard({super.key, required this.glossary});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWellContainer(
      color: scaffoldBackgroundColor,
      radius: 10,
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 16,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.1),
          offset: const Offset(0, 1),
          blurRadius: 4,
          spreadRadius: -1,
        ),
      ],
      onTap: () => navigatorKey.currentState!.pushNamed(
        glossaryDetailRoute,
        arguments: GlossaryDetailPageArgs(
          id: glossary.id!,
          isAdmin: true,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '${glossary.title}',
              style: textTheme.titleMedium,
            ),
          ),
          const SizedBox(width: 8),
          CustomIconButton(
            iconName: 'trash-line.svg',
            color: errorColor,
            size: 20,
            onPressed: () => context.showConfirmDialog(
              title: 'Hapus Kosa Kata',
              message: 'Anda yakin ingin menghapus istilah kata ini?',
              primaryButtonText: 'Hapus',
              onPressedPrimaryButton: () {
                ref
                    .read(glossariesProvider.notifier)
                    .deleteGlossary(id: glossary.id!);

                navigatorKey.currentState!.pop();
              },
            ),
            tooltip: 'Hapus',
          ),
        ],
      ),
    );
  }
}
