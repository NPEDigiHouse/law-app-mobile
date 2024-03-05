// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_file_plus/open_file_plus.dart';

// Project imports:
import 'package:law_app/core/enums/banner_type.dart';
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/routes/route_names.dart';
import 'package:law_app/core/services/file_service.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/admin/presentation/library/pages/book_management_form_page.dart';
import 'package:law_app/features/library/presentation/providers/book_detail_provider.dart';
import 'package:law_app/features/library/presentation/providers/book_provider.dart';
import 'package:law_app/features/library/presentation/providers/delete_book_provider.dart';
import 'package:law_app/features/shared/widgets/custom_network_image.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/loading_indicator.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class BookManagementDetailPage extends ConsumerWidget {
  final int id;

  const BookManagementDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final book = ref.watch(BookDetailProvider(id: id));

    ref.listen(BookDetailProvider(id: id), (_, state) {
      state.when(
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
        loading: () {},
        data: (_) {},
      );
    });

    ref.listen(deleteBookProvider, (_, state) {
      state.when(
        error: (error, _) {
          navigatorKey.currentState!.pop();
          navigatorKey.currentState!.pop();

          if ('$error' == kNoInternetConnection) {
            context.showNetworkErrorModalBottomSheet();
          } else {
            context.showBanner(message: '$error', type: BannerType.error);
          }
        },
        loading: () => context.showLoadingDialog(),
        data: (data) {
          if (data != null) {
            ref.invalidate(bookProvider);

            context.showBanner(
              message: 'Buku berhasil dihapus!',
              type: BannerType.success,
            );

            navigatorKey.currentState!.pop();
            navigatorKey.currentState!.pop();
            navigatorKey.currentState!.pop();
          }
        },
      );
    });

    return book.when(
      loading: () => const LoadingIndicator(withScaffold: true),
      error: (_, __) => const Scaffold(),
      data: (book) {
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
                        HeaderContainer(
                          height: 270,
                          title: 'Detail Buku',
                          withBackButton: true,
                          withTrailingButton: true,
                          trailingButtonIconName: 'trash-line.svg',
                          trailingButtonTooltip: 'Hapus',
                          onPressedTrailingButton: () {
                            context.showConfirmDialog(
                              title: 'Hapus Buku?',
                              message: 'Anda yakin ingin menghapus buku ini!',
                              primaryButtonText: 'Hapus',
                              onPressedPrimaryButton: () {
                                ref
                                    .read(deleteBookProvider.notifier)
                                    .deleteBook(id: id);
                              },
                            );
                          },
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
                                            style:
                                                textTheme.bodySmall!.copyWith(
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
                                            '${book.category?.name}',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style:
                                                textTheme.bodySmall!.copyWith(
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
                            child: IconButton(
                              onPressed: () => openPDF(context, book.bookUrl!),
                              icon: SvgAsset(
                                assetPath: AssetPath.getIcon('eye-solid.svg'),
                                color: primaryColor,
                                width: 20,
                              ),
                              tooltip: 'Lihat',
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
          floatingActionButton: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(
                colors: GradientColors.redPastel,
              ),
            ),
            child: IconButton(
              onPressed: () => navigatorKey.currentState!.pushNamed(
                bookManagementFormRoute,
                arguments: BookManagementFormPageArgs(
                  title: 'Edit Buku',
                  book: book,
                ),
              ),
              icon: SvgAsset(
                assetPath: AssetPath.getIcon('pencil-solid.svg'),
                color: scaffoldBackgroundColor,
                width: 24,
              ),
              tooltip: 'Edit',
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

  Future<void> openPDF(BuildContext context, String url) async {
    context.showLoadingDialog();

    final file = await FileService.downloadFile(url: url);

    if (file != null) {
      final result = await OpenFile.open(file.path);

      debugPrint(result.message);
    }

    navigatorKey.currentState!.pop();
  }
}
