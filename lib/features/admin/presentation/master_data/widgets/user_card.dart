import 'package:flutter/material.dart';
import 'package:law_app/core/extensions/string_extension.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/helpers/function_helper.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
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
      radius: 8,
      padding: const EdgeInsets.symmetric(
        vertical: 12,
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
      onTap: () {},
      child: Row(
        children: [
          CircleProfileAvatar(
            image: user.profilePict,
            radius: 28,
            borderColor: accentColor,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.username,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall!.copyWith(
                    color: secondaryTextColor,
                  ),
                ),
                Text(
                  user.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleSmall,
                ),
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
            size: 18,
            onPressed: () {},
            tooltip: 'Hapus',
          ),
        ],
      ),
    );
  }
}
