// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/extensions/string_extension.dart';
import 'package:law_app/core/helpers/function_helper.dart';
import 'package:law_app/core/routes/route_names.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/dummies_data.dart';
import 'package:law_app/features/shared/widgets/circle_profile_avatar.dart';
import 'package:law_app/features/shared/widgets/custom_icon_button.dart';
import 'package:law_app/features/shared/widgets/ink_well_container.dart';
import 'package:law_app/features/shared/widgets/label_chip.dart';

class UserCard extends StatelessWidget {
  final User user;

  const UserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
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
        arguments: user,
      ),
      child: Row(
        children: [
          CircleProfileAvatar(
            image: user.profilePict,
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
                  user.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleSmall,
                ),
                const SizedBox(height: 4),
                LabelChip(
                  text: user.role.toCapitalize(),
                  color: FunctionHelper.getColorByRole(user.role),
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
              onPressedPrimaryButton: () {},
            ),
            tooltip: 'Hapus',
          ),
        ],
      ),
    );
  }
}
