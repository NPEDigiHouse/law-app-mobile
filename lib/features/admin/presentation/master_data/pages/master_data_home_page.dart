// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_debounce/easy_debounce.dart';
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
import 'package:law_app/features/admin/data/models/discussion_models/discussion_category_model.dart';
import 'package:law_app/features/admin/presentation/master_data/pages/master_data_form_page.dart';
import 'package:law_app/features/admin/presentation/master_data/providers/master_data_provider.dart';
import 'package:law_app/features/admin/presentation/master_data/widgets/user_card.dart';
import 'package:law_app/features/admin/presentation/reference/providers/discussion_category_provider.dart';
import 'package:law_app/features/shared/providers/search_provider.dart';
import 'package:law_app/features/shared/providers/user_role_filter_provider.dart';
import 'package:law_app/features/shared/widgets/custom_filter_chip.dart';
import 'package:law_app/features/shared/widgets/custom_information.dart';
import 'package:law_app/features/shared/widgets/form_field/search_field.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/loading_indicator.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class MasterDataHomePage extends ConsumerStatefulWidget {
  const MasterDataHomePage({super.key});

  @override
  ConsumerState<MasterDataHomePage> createState() => _MasterDataHomePageState();
}

class _MasterDataHomePageState extends ConsumerState<MasterDataHomePage>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final labels = userRoles.keys.toList();

    final users = ref.watch(masterDataProvider);
    final query = ref.watch(queryProvider);

    ref.listen(masterDataProvider, (_, state) {
      state.when(
        error: (error, _) {
          if ('$error' == kNoInternetConnection) {
            context.showNetworkErrorModalBottomSheet(
              onPressedPrimaryButton: () {
                navigatorKey.currentState!.pop();
                ref.invalidate(masterDataProvider);
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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(180),
        child: Container(
          color: scaffoldBackgroundColor,
          child: HeaderContainer(
            height: 180,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: secondaryColor,
                      ),
                      child: IconButton(
                        onPressed: () => context.back(),
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
                          'Master Data',
                          style: textTheme.titleLarge!.copyWith(
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
                        onPressed: () => context.showSortingDialog(
                          items: [
                            'Nama',
                            'Username',
                            'Email',
                          ],
                          values: [
                            'name',
                            'username',
                            'email',
                          ],
                          onSubmitted: sortUsers,
                        ),
                        icon: SvgAsset(
                          assetPath: AssetPath.getIcon(
                            'sort-by-line-right.svg',
                          ),
                          color: primaryColor,
                          width: 24,
                        ),
                        tooltip: 'Urutkan',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SearchField(
                  text: query,
                  hintText: 'Cari pengguna',
                  onChanged: searchUsers,
                ),
              ],
            ),
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
                  final selectedRole = ref.watch(userRoleProvider);

                  return CustomFilterChip(
                    label: labels[index],
                    selected: selectedRole == userRoles[labels[index]],
                    onSelected: (_) => filterUsers(labels[index]),
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(width: 8);
                },
                itemCount: userRoles.length,
              ),
            ),
          ),
          users.when(
            loading: () => const SliverFillRemaining(
              child: LoadingIndicator(),
            ),
            error: (_, __) => const SliverFillRemaining(),
            data: (data) {
              if (data == null) return const SliverFillRemaining();

              if (query.isNotEmpty && data.isEmpty) {
                return const SliverFillRemaining(
                  child: CustomInformation(
                    illustrationName: 'house-searching-cuate.svg',
                    title: 'User tidak ditemukan',
                  ),
                );
              }

              if (data.isEmpty) {
                return const SliverFillRemaining(
                  child: CustomInformation(
                    illustrationName: 'house-searching-cuate.svg',
                    title: 'Belum ada data',
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: index == data.length - 1 ? 0 : 8,
                        ),
                        child: UserCard(
                          user: data[index],
                        ),
                      );
                    },
                    childCount: data.length,
                  ),
                ),
              );
            },
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
          onPressed: () => context.showCustomSelectorDialog(
            title: 'Pilih Role',
            items: [
              {
                'text': 'Student',
                'onTap': () {
                  navigatorKey.currentState!.pop();
                  navigatorKey.currentState!.pushNamed(
                    masterDataFormRoute,
                    arguments: const MasterDataFormPageArgs(
                      title: 'Tambah Student',
                    ),
                  );
                },
              },
              {
                'text': 'Pakar',
                'onTap': () async {
                  final categories = await getDiscussionCategories(context);

                  navigatorKey.currentState!.pop();

                  if (categories.isNotEmpty) {
                    navigatorKey.currentState!.pushNamed(
                      masterDataFormRoute,
                      arguments: MasterDataFormPageArgs(
                        title: 'Tambah Teacher',
                        discussionCategories: categories,
                      ),
                    );
                  } else {
                    if (!context.mounted) return;

                    context.showCustomAlertDialog(
                      title: 'Tidak Dapat Memilih Pakar!',
                      message: 'Saat ini, user role pakar belum dapat dibuat.',
                      onPressedPrimaryButton: () {
                        navigatorKey.currentState!.pop();
                      },
                    );
                  }
                },
              },
              {
                'text': 'Admin',
                'onTap': () {
                  navigatorKey.currentState!.pop();
                  navigatorKey.currentState!.pushNamed(
                    masterDataFormRoute,
                    arguments: const MasterDataFormPageArgs(
                      title: 'Tambah Admin',
                    ),
                  );
                },
              },
            ],
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

  void searchUsers(String query) {
    ref.read(queryProvider.notifier).state = query;

    if (query.isNotEmpty) {
      EasyDebounce.debounce(
        'search-debouncer',
        const Duration(milliseconds: 800),
        () => ref.read(masterDataProvider.notifier).searchUsers(query: query),
      );
    } else {
      ref.invalidate(masterDataProvider);
    }
  }

  void sortUsers(Map<String, dynamic> value) {
    ref.read(queryProvider.notifier).state = '';
    ref.read(masterDataProvider.notifier).sortUsers(
          sortBy: value['sortBy'],
          sortOrder: value['sortOrder'],
        );

    navigatorKey.currentState!.pop();
  }

  void filterUsers(String role) {
    ref.read(queryProvider.notifier).state = '';
    ref.read(userRoleProvider.notifier).state = userRoles[role]!;
    ref
        .read(masterDataProvider.notifier)
        .filterUsers(role: ref.watch(userRoleProvider));
  }

  Future<List<DiscussionCategoryModel>> getDiscussionCategories(
    BuildContext context,
  ) async {
    List<DiscussionCategoryModel>? categories;

    try {
      categories = await ref.watch(discussionCategoryProvider.future);
    } catch (e) {
      debugPrint('$e');
    }

    return categories ?? [];
  }
}
