// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:law_app/core/enums/banner_type.dart';
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/routes/route_names.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/admin/presentation/library/pages/book_management_form_page.dart';
import 'package:law_app/features/library/presentation/providers/book_actions_provider.dart';
import 'package:law_app/features/library/presentation/providers/book_provider.dart';
import 'package:law_app/features/shared/widgets/custom_information.dart';
import 'package:law_app/features/shared/widgets/feature/book_card.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/loading_indicator.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class BookManagementListPage extends ConsumerWidget {
  const BookManagementListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final books = ref.watch(BookProvider());

    ref.listen(BookProvider(), (_, state) {
      state.whenOrNull(
        error: (error, _) {
          if ('$error' == kNoInternetConnection) {
            context.showNetworkErrorModalBottomSheet(
              onPressedPrimaryButton: () {
                navigatorKey.currentState!.pop();
                ref.invalidate(bookProvider);
              },
            );
          } else {
            context.showBanner(message: '$error', type: BannerType.error);
          }
        },
      );
    });

    ref.listen(bookActionsProvider, (_, state) {
      state.when(
        error: (error, _) {
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
            navigatorKey.currentState!.pop();
            ref.invalidate(bookProvider);

            context.showBanner(message: data, type: BannerType.success);
          }
        },
      );
    });

    return books.when(
      loading: () => const LoadingIndicator(withScaffold: true),
      error: (_, __) => const Scaffold(),
      data: (data) {
        final books = data.books;
        final hasMore = data.hasMore;

        if (books == null || hasMore == null) return const Scaffold();

        return Scaffold(
          backgroundColor: backgroundColor,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                toolbarHeight: 140,
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                flexibleSpace: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const HeaderContainer(
                      height: 125,
                      title: 'Daftar Buku',
                      withBackButton: true,
                    ),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 24,
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(10),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.1),
                            offset: const Offset(2, 2),
                            blurRadius: 4,
                            spreadRadius: -1,
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Total Buku',
                              style: textTheme.bodyMedium!.copyWith(
                                color: primaryColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${books.length}',
                            style: textTheme.titleSmall!.copyWith(
                              color: primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                sliver: books.isEmpty
                    ? const SliverFillRemaining(
                        child: CustomInformation(
                          illustrationName: 'house-searching-cuate.svg',
                          title: 'Belum ada data',
                        ),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            if (index >= books.length) {
                              return buildFetchMoreButton(ref, books.length);
                            }

                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: index == books.length - 1 ? 0 : 8,
                              ),
                              child: BookCard(book: books[index]),
                            );
                          },
                          childCount: hasMore ? books.length + 1 : books.length,
                        ),
                      ),
              ),
            ],
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
                arguments: const BookManagementFormPageArgs(
                  title: 'Tambah Buku',
                ),
              ),
              icon: SvgAsset(
                assetPath: AssetPath.getIcon('plus-line.svg'),
                color: scaffoldBackgroundColor,
                width: 24,
              ),
              tooltip: 'Tambah',
            ),
          ),
        );
      },
    );
  }

  TextButton buildFetchMoreButton(WidgetRef ref, int currentLength) {
    return TextButton(
      onPressed: () {
        ref.read(BookProvider().notifier).fetchMoreBooks(offset: currentLength);
      },
      child: const Text('Lihat lebih banyak'),
    );
  }
}
