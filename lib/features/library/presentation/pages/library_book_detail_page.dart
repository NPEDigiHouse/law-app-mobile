// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

// Project imports:
import 'package:law_app/core/enums/banner_type.dart';
import 'package:law_app/core/extensions/button_extension.dart';
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/routes/route_names.dart';
import 'package:law_app/core/services/file_service.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/admin/data/models/book_models/book_detail_model.dart';
import 'package:law_app/features/admin/data/models/book_models/book_saved_model.dart';
import 'package:law_app/features/library/presentation/pages/library_read_book_page.dart';
import 'package:law_app/features/library/presentation/providers/book_detail_provider.dart';
import 'package:law_app/features/library/presentation/providers/library_provider.dart';
import 'package:law_app/features/library/presentation/providers/save_book_provider.dart';
import 'package:law_app/features/library/presentation/providers/unsave_book_provider.dart';
import 'package:law_app/features/library/presentation/providers/update_user_read_provider.dart';
import 'package:law_app/features/shared/widgets/custom_network_image.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/loading_indicator.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class LibraryBookDetailRoute extends ConsumerWidget {
  final int id;

  const LibraryBookDetailRoute({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final book = ref.watch(BookDetailProvider(id: id));

    ref.listen(BookDetailProvider(id: id), (_, state) {
      state.whenOrNull(
        error: (error, _) {
          if ('$error' == kNoInternetConnection) {
            context.showNetworkErrorModalBottomSheet(
              onPressedPrimaryButton: () {
                navigatorKey.currentState!.pop();
                ref.invalidate(bookDetailProvider);
              },
            );
          } else {
            context.showBanner(message: '$error', type: BannerType.error);
          }
        },
      );
    });

    ref.listen(saveBookProvider, (_, state) {
      state.whenOrNull(
        error: (error, _) {
          if ('$error' == kNoInternetConnection) {
            context.showBanner(
              message: 'Gagal menyimpan buku. Periksa koneksi internet!',
              type: BannerType.error,
            );
          } else {
            context.showBanner(message: '$error', type: BannerType.error);
          }
        },
        data: (data) {
          if (data != null) {
            ref.invalidate(bookDetailProvider);

            context.showBanner(
              message: 'Buku dimasukkan ke daftar buku disimpan!',
              type: BannerType.success,
            );
          }
        },
      );
    });

    ref.listen(unsaveBookProvider, (_, state) {
      state.whenOrNull(
        error: (error, _) {
          if ('$error' == kNoInternetConnection) {
            context.showBanner(
              message: 'Gagal menghapus buku. Periksa koneksi internet!',
              type: BannerType.error,
            );
          } else {
            context.showBanner(message: '$error', type: BannerType.error);
          }
        },
        data: (data) {
          if (data != null) {
            ref.invalidate(bookDetailProvider);

            context.showBanner(
              message: 'Buku dikeluarkan dari daftar buku disimpan!',
              type: BannerType.success,
            );
          }
        },
      );
    });

    ref.listen(updateUserReadProvider, (_, state) {
      state.whenOrNull(
        error: (error, _) {
          if ('$error' == kNoInternetConnection) {
            context.showBanner(
              message: 'Progress gagal diupdate. Tidak ada koneksi internet!',
              type: BannerType.error,
            );
          } else {
            context.showBanner(message: '$error', type: BannerType.error);
          }
        },
        data: (data) {
          if (data != null) {
            ref.invalidate(BookDetailProvider(id: id));
            ref.invalidate(libraryProvider);
          }
        },
      );
    });

    return book.when(
      loading: () => const LoadingIndicator(withScaffold: true),
      error: (_, __) => const Scaffold(),
      data: (data) {
        final book = data.book;
        final savedBook = data.savedBook;

        if (book == null) return const Scaffold();

        return Scaffold(
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
                                child: CustomNetworkImage(
                                  imageUrl: book.coverImage!,
                                  placeHolderSize: 32,
                                  aspectRatio: 2 / 3,
                                  radius: 8,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(.15),
                                      offset: const Offset(2, 2),
                                      blurRadius: 4,
                                      spreadRadius: -1,
                                    ),
                                  ],
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
                                      '${book.title} (${book.releaseDate?.year})',
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
                                            '${book.writer}',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: textTheme.bodySmall!.copyWith(
                                                color: scaffoldBackgroundColor),
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
                                            '${book.category?.name}',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: textTheme.bodySmall!.copyWith(
                                                color: scaffoldBackgroundColor),
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
                            child: IconButton(
                              onPressed: () => saveOrUnsaveBook(
                                context: context,
                                ref: ref,
                                bookId: book.id!,
                                savedBook: savedBook,
                              ),
                              icon: SvgAsset(
                                assetPath: AssetPath.getIcon(
                                  savedBook != null
                                      ? 'bookmark-solid.svg'
                                      : 'bookmark-line.svg',
                                ),
                                color: primaryColor,
                                width: 24,
                              ),
                              tooltip: 'Save',
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
                            Tab(text: 'Detail'),
                            Tab(text: 'Sinopsis'),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          ListView(
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                            children: [
                              buildBookDetailField(
                                label: 'Judul',
                                value: '${book.title}',
                              ),
                              buildBookDetailField(
                                label: 'Penulis',
                                value: '${book.writer}',
                              ),
                              buildBookDetailField(
                                label: 'Tahun Terbit',
                                value: '${book.releaseDate?.year}',
                              ),
                              buildBookDetailField(
                                label: 'Kategori',
                                value: '${book.category?.name}',
                              ),
                              buildBookDetailField(
                                label: 'Jumlah Halaman',
                                value: '${book.pageAmt} Hal.',
                              ),
                              buildBookDetailField(
                                label: 'Penerbit',
                                value: '${book.publisher}',
                                bottomPadding: 0,
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                            child: Text(
                              '${book.synopsis}',
                              style: textTheme.bodySmall,
                            ),
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
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            decoration: BoxDecoration(
              color: scaffoldBackgroundColor,
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
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (book.currentPage != null) ...[
                  Text(
                    'Progres Membaca',
                    style: textTheme.bodyMedium!.copyWith(
                      color: secondaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  LinearPercentIndicator(
                    lineHeight: 10,
                    barRadius: const Radius.circular(10),
                    padding: const EdgeInsets.only(right: 8),
                    animation: true,
                    curve: Curves.easeOut,
                    progressColor: successColor,
                    backgroundColor: secondaryTextColor,
                    percent: book.currentPage! / book.pageAmt!,
                    trailing: Text(
                      '${((book.currentPage! / book.pageAmt!) * 100).toInt()}%',
                    ),
                  ),
                ] else
                  Text(
                    'Belum pernah dibaca',
                    style: textTheme.bodyMedium!.copyWith(
                      color: secondaryTextColor,
                    ),
                  ),
                const SizedBox(height: 8),
                FilledButton(
                  onPressed: () => openPDF(context, book),
                  child: Text(
                    readBookButtonText(book.currentPage, book.pageAmt!),
                  ),
                ).fullWidth(),
              ],
            ),
          ),
        );
      },
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
            style: textTheme.titleMedium,
          ),
        ],
      ),
    );
  }

  void saveOrUnsaveBook({
    required BuildContext context,
    required WidgetRef ref,
    required int bookId,
    BookSavedModel? savedBook,
  }) {
    if (savedBook != null) {
      ref.read(unsaveBookProvider.notifier).unsaveBook(id: savedBook.id!);
    } else {
      ref.read(saveBookProvider.notifier).saveBook(bookId: bookId);
    }
  }

  String readBookButtonText(int? currentPage, int pageAmt) {
    if (currentPage == null) return 'Mulai Membaca';

    if (currentPage < pageAmt) return 'Lanjutkan Membaca';

    return 'Baca Lagi';
  }

  Future<void> openPDF(BuildContext context, BookDetailModel book) async {
    context.showLoadingDialog();

    final path = await FileService.downloadFile(
      url: book.bookUrl!,
      flush: true,
    );

    navigatorKey.currentState!.pop();

    if (path != null) {
      navigatorKey.currentState!.pushNamed(
        libraryReadBookRoute,
        arguments: LibraryReadBookPageArgs(path: path, book: book),
      );
    } else {
      if (!context.mounted) return;

      context.showBanner(
        message: 'Gagal mengunduh file. Periksa koneksi internet!',
        type: BannerType.error,
      );
    }
  }
}
