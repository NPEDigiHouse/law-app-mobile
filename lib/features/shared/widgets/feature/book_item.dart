// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:law_app/core/routes/route_names.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/admin/data/models/book_models/book_model.dart';
import 'package:law_app/features/shared/widgets/custom_network_image.dart';

class BookItem extends StatelessWidget {
  final double? width;
  final double? height;
  final int? titleMaxLines;
  final BookModel book;

  const BookItem({
    super.key,
    this.width,
    this.height,
    this.titleMaxLines = 2,
    required this.book,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CustomNetworkImage(
          width: width,
          height: height,
          fit: BoxFit.fill,
          imageUrl: book.coverImage!,
          placeHolderSize: 24,
          radius: 8,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.1),
              offset: const Offset(0, -2),
              blurRadius: 4,
            ),
          ],
        ),
        Container(
          width: width,
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(8),
            ),
            gradient: LinearGradient(
              colors: GradientColors.redPastel,
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Text(
                  '${book.title}\n',
                  maxLines: titleMaxLines,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: textTheme.bodySmall!.copyWith(
                    color: scaffoldBackgroundColor,
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
              onTap: () => navigatorKey.currentState!.pushNamed(
                libraryBookDetailRoute,
                arguments: book.id,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
