// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/features/shared/widgets/custom_icon_button.dart';

class DeleteConfirmDialog extends StatelessWidget {
  final Animation<double> start;
  final String title;
  final VoidCallback? onIconPressed;

  const DeleteConfirmDialog({
    super.key,
    required this.start,
    required this.title,
    this.onIconPressed,
  });

  @override
  Widget build(BuildContext context) {
    final curvedValue = Curves.ease.transform(start.value) - 3.75;

    return Transform(
      transform: Matrix4.translationValues(0, (curvedValue * -100), 0),
      child: Opacity(
        opacity: start.value,
        child: Dialog(
          elevation: 0,
          backgroundColor: scaffoldBackgroundColor,
          insetPadding: const EdgeInsets.symmetric(
            vertical: 24,
            horizontal: 32,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 12,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleSmall!.copyWith(
                    color: primaryTextColor,
                  ),
                ),
                const SizedBox(height: 4),
                CustomIconButton(
                  iconName: 'trash-line.svg',
                  color: primaryColor,
                  splashRadius: 12,
                  size: 24,
                  onPressed: onIconPressed,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
