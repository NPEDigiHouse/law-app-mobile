// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/routes/route_names.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/library/presentation/providers/book_provider.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class BookManagementListPage extends ConsumerWidget {
  const BookManagementListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final books = ref.watch(BookProvider());

    return Scaffold(
      backgroundColor: backgroundColor,
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              floating: true,
              toolbarHeight: 120,
              automaticallyImplyLeading: false,
              flexibleSpace: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const HeaderContainer(
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
                          '',
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
          ];
        },
        body: const CustomScrollView(
          slivers: [],
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
