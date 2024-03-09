// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:law_app/core/enums/banner_type.dart';
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/credential_saver.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/admin/data/models/book_models/book_detail_model.dart';
import 'package:law_app/features/library/presentation/providers/book_detail_provider.dart';
import 'package:law_app/features/library/presentation/providers/library_provider.dart';
import 'package:law_app/features/library/presentation/providers/read_book_provider.dart';
import 'package:law_app/features/library/presentation/providers/update_user_read_provider.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

final totalPagesProvider = StateProvider.autoDispose<int>((ref) => 1);

class LibraryReadBookPage extends ConsumerStatefulWidget {
  final String path;
  final BookDetailModel book;

  const LibraryReadBookPage({
    super.key,
    required this.path,
    required this.book,
  });

  @override
  ConsumerState<LibraryReadBookPage> createState() =>
      _LibraryReadBookPageState();
}

class _LibraryReadBookPageState extends ConsumerState<LibraryReadBookPage> {
  late PDFViewController pdfViewController;
  late int currentPage;

  @override
  void initState() {
    super.initState();

    currentPage = widget.book.currentPage ?? 1;
  }

  @override
  Widget build(BuildContext context) {
    final totalPages = ref.watch(totalPagesProvider);

    if (widget.book.currentPage == null) {
      ref.listen(
        ReadBookProvider(
          userId: CredentialSaver.user!.id!,
          bookId: widget.book.id!,
        ),
        (_, state) {
          state.whenOrNull(
            data: (data) {
              if (data != null) {
                ref.invalidate(bookDetailProvider);
                ref.invalidate(libraryProvider);
              }
            },
          );
        },
      );
    }

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;

        if (currentPage > (widget.book.currentPage ?? 1)) {
          ref.read(updateUserReadProvider.notifier).updateUserRead(
                bookId: widget.book.id!,
                currentPage: currentPage,
              );
        }

        context.back();
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(96),
          child: HeaderContainer(
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: secondaryColor,
                  ),
                  child: IconButton(
                    onPressed: () {
                      if (currentPage > (widget.book.currentPage ?? 1)) {
                        ref
                            .read(updateUserReadProvider.notifier)
                            .updateUserRead(
                              bookId: widget.book.id!,
                              currentPage: currentPage,
                            );
                      }

                      context.back();
                    },
                    icon: SvgAsset(
                      assetPath: AssetPath.getIcon('caret-line-left.svg'),
                      color: primaryColor,
                      width: 24,
                    ),
                    tooltip: 'Kembali',
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'Halaman $currentPage dari $totalPages',
                      style: textTheme.titleMedium!.copyWith(
                        color: scaffoldBackgroundColor,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: secondaryColor,
                  ),
                  child: IconButton(
                    onPressed: () {
                      context.showSingleFormDialog(
                        title: 'Navigasi Halaman',
                        name: 'currentPage',
                        label: 'No. halaman',
                        hintText: 'Masukkan nomor halaman',
                        textInputType: TextInputType.number,
                        primaryButtonText: 'Submit',
                        onSubmitted: (value) {
                          final input = int.parse(value['currentPage']);

                          if (input > totalPages) {
                            context.showBanner(
                              message: 'Halaman $input melebihi total halaman!',
                              type: BannerType.error,
                            );
                          } else if (input < 1) {
                            context.showBanner(
                              message: 'Masukkan nomor halaman yang benar!',
                              type: BannerType.error,
                            );
                          } else {
                            pdfViewController.setPage(input - 1);
                          }

                          navigatorKey.currentState!.pop();
                        },
                      );
                    },
                    icon: const Icon(
                      Icons.switch_access_shortcut_outlined,
                      color: primaryColor,
                      size: 20,
                    ),
                    tooltip: 'Kembali',
                  ),
                ),
              ],
            ),
          ),
        ),
        body: PDFView(
          filePath: widget.path,
          defaultPage: currentPage - 1,
          pageSnap: false,
          autoSpacing: false,
          pageFling: false,
          preventLinkNavigation: true,
          onRender: (pages) {
            ref.read(totalPagesProvider.notifier).state =
                pages ?? widget.book.pageAmt!;
          },
          onViewCreated: (controller) async {
            pdfViewController = controller;
            pdfViewController.setPage(currentPage - 1);
          },
          onPageChanged: (page, total) {
            setState(() => currentPage = page! + 1);
          },
          onLinkHandler: (uri) async {
            if (await canLaunchUrl(Uri.parse(uri!))) {
              await launchUrl(Uri.parse(uri));
            }
          },
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton.small(
              heroTag: null,
              elevation: 2,
              foregroundColor: primaryColor,
              backgroundColor: secondaryColor,
              onPressed: () {
                pdfViewController.setPage(
                  currentPage == 1 ? totalPages - 1 : currentPage - 2,
                );
              },
              child: const Icon(Icons.navigate_before_rounded),
            ),
            FloatingActionButton.small(
              heroTag: null,
              elevation: 2,
              foregroundColor: primaryColor,
              backgroundColor: secondaryColor,
              onPressed: () {
                pdfViewController.setPage(
                  currentPage == totalPages ? 0 : currentPage,
                );
              },
              child: const Icon(Icons.navigate_next_rounded),
            ),
          ],
        ),
      ),
    );
  }
}

class LibraryReadBookPageArgs {
  final String path;
  final BookDetailModel book;

  const LibraryReadBookPageArgs({
    required this.path,
    required this.book,
  });
}
