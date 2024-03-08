// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:law_app/core/enums/banner_type.dart';
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/admin/presentation/library/widgets/book_category_card.dart';
import 'package:law_app/features/library/presentation/providers/book_category_provider.dart';
import 'package:law_app/features/shared/widgets/custom_information.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/loading_indicator.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class BookManagementCategoryPage extends ConsumerWidget {
  const BookManagementCategoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(bookCategoryProvider);

    ref.listen(bookCategoryProvider, (_, state) {
      state.when(
        error: (error, _) {
          if ('$error' == kNoInternetConnection) {
            context.showNetworkErrorModalBottomSheet(
              onPressedPrimaryButton: () {
                ref.invalidate(bookCategoryProvider);
                navigatorKey.currentState!.pop();
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

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(96),
        child: HeaderContainer(
          title: 'Kategori Buku',
          withBackButton: true,
        ),
      ),
      body: categories.whenOrNull(
        loading: () => const LoadingIndicator(),
        data: (categories) {
          if (categories == null) return null;

          if (categories.isEmpty) {
            return const CustomInformation(
              illustrationName: 'house-searching-cuate.svg',
              title: 'Belum ada data',
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(
              vertical: 24,
              horizontal: 20,
            ),
            itemBuilder: (context, index) {
              return BookCategoryCard(category: categories[index]);
            },
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemCount: categories.length,
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
          onPressed: () => context.showSingleFormDialog(
            title: "Tambah Kategori Buku",
            name: "name",
            label: "Kategori",
            hintText: "Masukkan nama kategori",
            primaryButtonText: 'Tambah',
            onSubmitted: (value) {
              ref
                  .read(bookCategoryProvider.notifier)
                  .createBookCategory(name: value['name']);

              navigatorKey.currentState!.pop();
            },
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
}
