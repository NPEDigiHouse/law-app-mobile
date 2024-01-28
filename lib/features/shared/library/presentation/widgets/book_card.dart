import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/dummies_data.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final double? completePercentage;
  final VoidCallback? onTap;

  const BookCard({
    super.key,
    required this.book,
    this.completePercentage,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      color: scaffoldBackgroundColor,
      surfaceTintColor: scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.asset(
                    AssetPath.getImage(book.image),
                    fit: BoxFit.cover,
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
                      const SizedBox(height: 6),
                      if (completePercentage != null)
                        LinearPercentIndicator(
                          lineHeight: 6,
                          barRadius: const Radius.circular(6),
                          animation: true,
                          animationDuration: 1000,
                          curve: Curves.easeIn,
                          padding: EdgeInsets.zero,
                          percent: completePercentage! / 100,
                          progressColor: successColor,
                          backgroundColor: secondaryTextColor,
                          trailing: Text('$completePercentage%'),
                        )
                      else
                        Text(
                          '*Belum dibaca',
                          style: textTheme.bodySmall!.copyWith(
                            fontWeight: FontWeight.w700,
                            color: primaryColor,
                          ),
                        ),
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
                borderRadius: BorderRadius.circular(12),
                onTap: onTap,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
