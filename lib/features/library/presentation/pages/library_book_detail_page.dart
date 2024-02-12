import 'package:flutter/material.dart';
import 'package:law_app/core/extensions/button_extension.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:law_app/core/enums/banner_type.dart';
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/dummies_data.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class LibraryBookDetailRoute extends StatefulWidget {
  final Book book;

  const LibraryBookDetailRoute({super.key, required this.book});

  @override
  State<LibraryBookDetailRoute> createState() => _LibraryBookDetailRouteState();
}

class _LibraryBookDetailRouteState extends State<LibraryBookDetailRoute> {
  late final ValueNotifier<bool> isSaved;

  @override
  void initState() {
    super.initState();

    isSaved = ValueNotifier(false);
  }

  @override
  void dispose() {
    super.dispose();

    isSaved.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bookDetail = {
      'title': widget.book.title,
      'author': widget.book.author,
      'image': widget.book.image,
      'completePercentage': widget.book.completePercentage,
      'publishedYear': 2020,
      'category': 'Hukum Perdata',
      'totalPage': 400,
      'publisher': 'Penerbit Erlangga',
      'synopsis':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi lacinia maximus erat vel fermentum. Mauris ut aliquet justo, et consectetur lorem.\n\nNam semper vehicula ex, ac fermentum orci elementum ac.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi lacinia maximus erat vel fermentum. Mauris ut aliquet justo, et consectetur.'
    };

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;

        context.back();
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: NestedScrollView(
          physics: const NeverScrollableScrollPhysics(),
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                pinned: true,
                toolbarHeight: 260,
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                flexibleSpace: SizedBox(
                  height: 300,
                  child: Stack(
                    children: [
                      const HeaderContainer(
                        height: 270,
                        title: 'Detail Buku',
                        withBackButton: true,
                      ),
                      Positioned(
                        left: 20,
                        right: 20,
                        bottom: 0,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 1,
                              child: AspectRatio(
                                aspectRatio: 2 / 3,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: scaffoldBackgroundColor,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(.15),
                                        offset: const Offset(2, 2),
                                        blurRadius: 4,
                                        spreadRadius: -1,
                                      ),
                                    ],
                                    image: DecorationImage(
                                      image: AssetImage(
                                        AssetPath.getImage(
                                          bookDetail['image'] as String,
                                        ),
                                      ),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 2,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${bookDetail['title'] as String} (${bookDetail['publishedYear'] as int})',
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: textTheme.titleMedium!.copyWith(
                                      color: accentTextColor,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      SvgAsset(
                                        assetPath: AssetPath.getIcon(
                                          'user-solid.svg',
                                        ),
                                        color: scaffoldBackgroundColor,
                                        width: 16,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          bookDetail['author'] as String,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: textTheme.bodySmall!.copyWith(
                                            color: scaffoldBackgroundColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      SvgAsset(
                                        assetPath: AssetPath.getIcon(
                                          'grid-view-solid.svg',
                                        ),
                                        color: scaffoldBackgroundColor,
                                        width: 16,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          bookDetail['category'] as String,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: textTheme.bodySmall!.copyWith(
                                            color: scaffoldBackgroundColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        right: 20,
                        bottom: 0,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: secondaryColor,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(.15),
                                offset: const Offset(2, 2),
                                blurRadius: 4,
                                spreadRadius: -1,
                              ),
                            ],
                          ),
                          child: ValueListenableBuilder(
                            valueListenable: isSaved,
                            builder: (context, isSaved, child) {
                              return IconButton(
                                onPressed: () => saveOrUnsaveBook(!isSaved),
                                icon: SvgAsset(
                                  assetPath: AssetPath.getIcon(
                                    isSaved
                                        ? 'bookmark-solid.svg'
                                        : 'bookmark-line.svg',
                                  ),
                                  color: primaryColor,
                                  width: 24,
                                ),
                                tooltip: 'Save',
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  SizedBox(
                    height: kTextTabBarHeight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TabBar(
                        indicatorWeight: 1,
                        indicatorSize: TabBarIndicatorSize.tab,
                        dividerColor: secondaryTextColor,
                        unselectedLabelStyle: textTheme.bodyMedium!.copyWith(
                          color: secondaryTextColor,
                        ),
                        tabs: const [
                          Tab(text: 'Sinopsis'),
                          Tab(text: 'Detail'),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                          child: Text(
                            bookDetail['synopsis'] as String,
                            style: textTheme.bodySmall,
                          ),
                        ),
                        ListView(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                          children: [
                            buildBookDetailField(
                              label: 'Judul',
                              value: bookDetail['title'] as String,
                            ),
                            buildBookDetailField(
                              label: 'Penulis',
                              value: bookDetail['author'] as String,
                            ),
                            buildBookDetailField(
                              label: 'Tahun Terbit',
                              value: '${bookDetail['publishedYear'] as int}',
                            ),
                            buildBookDetailField(
                              label: 'Kategori',
                              value: bookDetail['category'] as String,
                            ),
                            buildBookDetailField(
                              label: 'Jumlah Halaman',
                              value: '${bookDetail['totalPage'] as int} Hal.',
                            ),
                            buildBookDetailField(
                              label: 'Jumlah Halaman',
                              value: bookDetail['publisher'] as String,
                              bottomPadding: 0,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomSheet: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, -2),
                blurRadius: 4,
                spreadRadius: -1,
                color: Colors.black.withOpacity(.1),
              ),
            ],
            color: scaffoldBackgroundColor,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (bookDetail['completePercentage'] != null) ...[
                Text(
                  'Progres Membaca',
                  style: textTheme.bodyMedium!.copyWith(
                    color: secondaryTextColor,
                  ),
                ),
                const SizedBox(height: 8),
                LinearPercentIndicator(
                  lineHeight: 10,
                  barRadius: const Radius.circular(10),
                  padding: const EdgeInsets.only(right: 8),
                  animation: true,
                  animationDuration: 1000,
                  curve: Curves.easeIn,
                  percent: (bookDetail['completePercentage'] as double) / 100,
                  progressColor: successColor,
                  backgroundColor: secondaryTextColor,
                  trailing: Text(
                    '${(bookDetail['completePercentage'] as double).toInt()}%',
                  ),
                ),
              ] else
                Text(
                  'Belum pernah dibaca',
                  style: textTheme.bodyMedium!.copyWith(
                    color: secondaryTextColor,
                  ),
                ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () {},
                child: const Text('Mulai Membaca'),
              ).fullWidth(),
            ],
          ),
        ),
      ),
    );
  }

  Padding buildBookDetailField({
    required String label,
    required String value,
    double bottomPadding = 16,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: textTheme.labelSmall,
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: textTheme.titleSmall,
          ),
        ],
      ),
    );
  }

  void saveOrUnsaveBook(bool isSaved) {
    this.isSaved.value = isSaved;

    if (isSaved) {
      context.showBanner(
        message: 'Buku dimasukkan ke daftar buku disimpan!',
        type: BannerType.success,
      );
    } else {
      context.showBanner(
        message: 'Buku dikeluarkan dari daftar buku disimpan!',
        type: BannerType.warning,
      );
    }
  }
}
