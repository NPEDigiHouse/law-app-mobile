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

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(96),
        child: HeaderContainer(
          title: 'Daftar Buku',
          withBackButton: true,
        ),
      ),
      body: books.whenOrNull(
        loading: () => const LoadingIndicator(),
        data: (data) {
          final books = data.books;
          final hasMore = data.hasMore;

          if (books == null || hasMore == null) return null;

          if (books.isEmpty) {
            return const CustomInformation(
              illustrationName: 'house-searching-cuate.svg',
              title: 'Daftar buku belum ada',
              subtitle: 'Tambahkan buku dengan menekan tombol di bawah.',
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(
              vertical: 24,
              horizontal: 20,
            ),
            itemBuilder: (context, index) {
              if (index >= books.length) {
                return buildFetchMoreButton(ref, books.length);
              }

              return BookCard(book: books[index]);
            },
            separatorBuilder: (context, index) {
              return const SizedBox(height: 8);
            },
            itemCount: hasMore ? books.length + 1 : books.length,
          );
        },
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
