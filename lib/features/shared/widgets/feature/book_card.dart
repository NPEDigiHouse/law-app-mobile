// Flutter imports:
import 'package:flutter/material.dart';

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
  final bool isThreeLine;

  const BookCard({
    super.key,
    required this.book,
    this.isThreeLine = false,
  });

  @override
  Widget build(BuildContext context) {
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
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Column(
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
                        if (isThreeLine) ...[
                          const SizedBox(height: 10),
                          // if (book.completePercentage != null)
                          //   LinearPercentIndicator(
                          //     lineHeight: 8,
                          //     barRadius: const Radius.circular(8),
                          //     padding: const EdgeInsets.only(right: 8),
                          //     animation: true,
                          //     curve: Curves.easeIn,
                          //     percent: book.completePercentage! / 100,
                          //     progressColor: successColor,
                          //     backgroundColor: secondaryTextColor,
                          //     trailing: Text(
                          //       '${book.completePercentage!.toInt()}%',
                          //       style: textTheme.bodySmall,
                          //     ),
                          //   )
                          // else
                          //   const LabelChip(
                          //     text: 'Belum Dibaca',
                          //     color: infoColor,
                          //   ),
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
                borderRadius: BorderRadius.circular(8),
                onTap: onTap,
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
