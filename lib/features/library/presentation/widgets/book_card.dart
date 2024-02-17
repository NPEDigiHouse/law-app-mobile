import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/core/utils/routes.dart';
import 'package:law_app/dummies_data.dart';
import 'package:law_app/features/shared/widgets/label_chip.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final bool isThreeLine;

  const BookCard({
    super.key,
    required this.book,
    this.isThreeLine = true,
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
        borderRadius: BorderRadius.circular(8),
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: AspectRatio(
                      aspectRatio: 2 / 3,
                      child: Image.asset(
                        AssetPath.getImage(book.image),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        book.author,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodySmall!.copyWith(
                          color: secondaryTextColor,
                        ),
                      ),
                      if (isThreeLine) ...[
                        const SizedBox(height: 10),
                        if (book.completePercentage != null)
                          LinearPercentIndicator(
                            lineHeight: 8,
                            barRadius: const Radius.circular(8),
                            padding: const EdgeInsets.only(right: 8),
                            animation: true,
                            curve: Curves.easeIn,
                            percent: book.completePercentage! / 100,
                            progressColor: successColor,
                            backgroundColor: secondaryTextColor,
                            trailing: Text(
                              '${book.completePercentage!.toInt()}%',
                              style: textTheme.bodySmall,
                            ),
                          )
                        else
                          const LabelChip(
                            text: 'Belum Dibaca',
                            color: infoColor,
                          ),
                      ],
                    ],
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
                onTap: () => navigatorKey.currentState!.pushNamed(
                  libraryBookDetailRoute,
                  arguments: book,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
