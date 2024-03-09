// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:percent_indicator/linear_percent_indicator.dart';

// Project imports:
import 'package:law_app/core/routes/route_names.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/credential_saver.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/admin/data/models/book_models/book_model.dart';
import 'package:law_app/features/shared/widgets/custom_network_image.dart';

class BookCard extends StatelessWidget {
  final BookModel book;
  final VoidCallback? onLongPress;

  const BookCard({
    super.key,
    required this.book,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    double? complete;

    if (book.currentPage != null) {
      complete = book.currentPage! / book.pageAmt!;
    }

    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      color: scaffoldBackgroundColor,
      surfaceTintColor: scaffoldBackgroundColor,
      shadowColor: Colors.black.withOpacity(.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: CustomNetworkImage(
                    imageUrl: book.coverImage!,
                    placeHolderSize: 24,
                    aspectRatio: 2 / 3,
                    radius: 8,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${book.title}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.titleMedium!.copyWith(height: 0),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${book.writer}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.bodySmall!.copyWith(
                            color: primaryColor,
                          ),
                        ),
                        if (book.currentPage != null) ...[
                          const SizedBox(height: 6),
                          LinearPercentIndicator(
                            lineHeight: 8,
                            barRadius: const Radius.circular(8),
                            padding: const EdgeInsets.only(right: 8),
                            animation: true,
                            curve: Curves.easeOut,
                            progressColor: successColor,
                            backgroundColor: secondaryTextColor,
                            percent: complete!,
                            trailing: Text(
                              '${(complete * 100).toInt()}%',
                              style: textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: onTap,
                onLongPress: onLongPress,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onTap() {
    switch (CredentialSaver.user!.role) {
      case 'admin':
        navigatorKey.currentState!.pushNamed(
          bookManagementDetailRoute,
          arguments: book.id,
        );
        break;
      default:
        navigatorKey.currentState!.pushNamed(
          libraryBookDetailRoute,
          arguments: book.id,
        );
        break;
    }
  }
}
