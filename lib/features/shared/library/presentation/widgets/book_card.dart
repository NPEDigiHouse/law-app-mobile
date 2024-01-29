import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/dummies_data.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final VoidCallback? onTap;

  const BookCard({
    super.key,
    required this.book,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      color: scaffoldBackgroundColor,
      surfaceTintColor: scaffoldBackgroundColor,
      shadowColor: Colors.black.withOpacity(.2),
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
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.asset(
                    AssetPath.getImage(book.image),
                    fit: BoxFit.fill,
                    width: 64,
                    height: 88,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.titleMedium,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        book.author,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodySmall!.copyWith(
                          color: secondaryTextColor,
                        ),
                      ),
                      if (book.completePercentage != null) ...[
                        const Spacer(),
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
                          ),
                        ),
                      ] else ...[
                        const SizedBox(height: 6),
                        Text(
                          '*Belum dibaca',
                          style: textTheme.bodySmall!.copyWith(
                            fontWeight: FontWeight.w700,
                            color: primaryColor,
                          ),
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
                onTap: onTap,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
