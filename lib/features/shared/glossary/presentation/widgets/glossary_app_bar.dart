import 'package:flutter/material.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/core/utils/routes.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/search_field.dart';

class GlossaryAppBar extends StatelessWidget implements PreferredSizeWidget {
  const GlossaryAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return HeaderContainer(
      height: preferredSize.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Glosarium',
            style: textTheme.headlineMedium!.copyWith(
              color: accentTextColor,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Cari definisi dari berbagai kata untuk memperkaya referensi dan pengetahuanmu!',
            style: textTheme.bodyMedium!.copyWith(
              color: backgroundColor,
            ),
          ),
          const SizedBox(height: 14),
          SearchField(
            text: '',
            hintText: 'Cari kosa kata...',
            readOnly: true,
            canRequestFocus: false,
            textInputAction: TextInputAction.none,
            onTap: () => navigatorKey.currentState!.pushNamed(
              glossarySearchRoute,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(214);
}
