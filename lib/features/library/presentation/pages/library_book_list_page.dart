// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:after_layout/after_layout.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:law_app/core/enums/banner_type.dart';
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/helpers/category_helper.dart';
import 'package:law_app/core/routes/route_names.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/library/presentation/providers/book_provider.dart';
import 'package:law_app/features/shared/widgets/custom_filter_chip.dart';
import 'package:law_app/features/shared/widgets/custom_information.dart';
import 'package:law_app/features/shared/widgets/feature/book_item.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/loading_indicator.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

final bookCategoryIdProvider = StateProvider.autoDispose<int?>((ref) => null);

class LibraryBookListPage extends ConsumerStatefulWidget {
  const LibraryBookListPage({super.key});

  @override
  ConsumerState<LibraryBookListPage> createState() =>
      _LibraryBookListPageState();
}

class _LibraryBookListPageState extends ConsumerState<LibraryBookListPage>
    with AfterLayoutMixin {
  Map<String, int?> categories = {'Semua': null};

  @override
  Future<void> afterFirstLayout(BuildContext context) async {
    context.showLoadingDialog();

    final result = await CategoryHelper.getBookCategories(ref);

    for (var e in result) {
      categories[e.name!] = e.id!;
    }

    navigatorKey.currentState!.pop();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final labels = categories.keys.toList();
    final categoryId = ref.watch(bookCategoryIdProvider);
    final books = ref.watch(BookProvider(categoryId: categoryId));

    ref.listen(BookProvider(categoryId: categoryId), (_, state) {
      state.whenOrNull(
        error: (error, _) {
          if ('$error' == kNoInternetConnection) {
            context.showNetworkErrorModalBottomSheet(
              onPressedPrimaryButton: () {
                navigatorKey.currentState!.pop();
                ref.invalidate(BookProvider(categoryId: categoryId));
              },
            );
          } else {
            context.showBanner(message: '$error', type: BannerType.error);
          }
        },
      );
    });

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(96),
        child: HeaderContainer(
          title: 'Daftar Buku',
          withBackButton: true,
          withTrailingButton: true,
          trailingButtonIconName: 'search-line.svg',
          trailingButtonTooltip: 'Cari',
          onPressedTrailingButton: () => navigatorKey.currentState!.pushNamed(
            librarySearchRoute,
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            toolbarHeight: 64,
            automaticallyImplyLeading: false,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                color: scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.1),
                    offset: const Offset(0, 2),
                    blurRadius: 4,
                    spreadRadius: -1,
                  ),
                ],
              ),
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return CustomFilterChip(
                    label: labels[index],
                    selected: categoryId == categories[labels[index]],
                    onSelected: (_) {
                      ref.read(bookCategoryIdProvider.notifier).state =
                          categories[labels[index]];
                    },
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(width: 8);
                },
                itemCount: categories.length,
              ),
            ),
          ),
          books.when(
            loading: () => const SliverFillRemaining(
              child: LoadingIndicator(),
            ),
            error: (_, __) => const SliverFillRemaining(),
            data: (data) {
              final books = data.books;
              final hasMore = data.hasMore;

              if (books == null || hasMore == null) {
                return const SliverFillRemaining();
              }

              if (books.isEmpty) {
                return const SliverFillRemaining(
                  child: CustomInformation(
                    illustrationName: 'house-searching-cuate.svg',
                    title: 'Belum ada data',
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                sliver: SliverGrid.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 2 / 3,
                    crossAxisCount: 2,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    if (index >= books.length) {
                      return buildFetchMoreContainer(categoryId, books.length);
                    }

                    return BookItem(book: books[index]);
                  },
                  itemCount: hasMore ? books.length + 1 : books.length,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  GestureDetector buildFetchMoreContainer(int? categoryId, int currentLength) {
    return GestureDetector(
      onTap: () {
        ref
            .read(BookProvider(
              categoryId: categoryId,
            ).notifier)
            .fetchMoreBooks(
              categoryId: categoryId,
              offset: currentLength,
            );
      },
      child: DottedBorder(
        borderType: BorderType.RRect,
        strokeCap: StrokeCap.round,
        radius: const Radius.circular(8),
        dashPattern: const [4, 4],
        color: primaryColor,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Lihat lebih lengkap',
                  textAlign: TextAlign.center,
                  style: textTheme.titleMedium!.copyWith(
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                SvgAsset(
                  assetPath: AssetPath.getIcon('caret-line-right.svg'),
                  color: primaryColor,
                  width: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
