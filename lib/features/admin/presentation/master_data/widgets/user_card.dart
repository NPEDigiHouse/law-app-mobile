// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/extensions/string_extension.dart';
import 'package:law_app/core/helpers/function_helper.dart';
import 'package:law_app/core/routes/route_names.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/admin/presentation/master_data/providers/master_data_provider.dart';
import 'package:law_app/features/shared/models/user_model.dart';
import 'package:law_app/features/shared/widgets/circle_profile_avatar.dart';
import 'package:law_app/features/shared/widgets/custom_icon_button.dart';
import 'package:law_app/features/shared/widgets/ink_well_container.dart';
import 'package:law_app/features/shared/widgets/label_chip.dart';

class UserCard extends ConsumerWidget {
  final UserModel user;

  const UserCard({super.key, required this.user});

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
        masterDataUserDetailRoute,
        arguments: user.id,
      ),
      child: Row(
        children: [
          CircleProfileAvatar(
            imageUrl: user.profilePicture,
            radius: 28,
            borderColor: accentColor,
            borderSize: 1,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '@${user.username}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall!.copyWith(
                    color: secondaryTextColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${user.name}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleSmall,
                ),
                const SizedBox(height: 4),
                LabelChip(
                  text: '${user.role?.toCapitalize()}',
                  color: FunctionHelper.getColorByRole(user.role ?? ''),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          CustomIconButton(
            iconName: 'trash-line.svg',
            color: errorColor,
            size: 20,
            onPressed: () => context.showConfirmDialog(
              title: 'Hapus User',
              message: 'Anda yakin ingin menghapus seluruh data user ini?',
              primaryButtonText: 'Hapus',
              onPressedPrimaryButton: () {
                ref.read(masterDataProvider.notifier).deleteUser(id: user.id!);

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
