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
import 'package:law_app/features/admin/presentation/master_data/pages/master_data_form_page.dart';
import 'package:law_app/features/admin/presentation/master_data/providers/master_data_provider.dart';
import 'package:law_app/features/admin/presentation/master_data/providers/user_actions_provider.dart';
import 'package:law_app/features/admin/presentation/master_data/widgets/user_card.dart';
import 'package:law_app/features/shared/providers/manual_providers/search_provider.dart';
import 'package:law_app/features/shared/widgets/custom_filter_chip.dart';
import 'package:law_app/features/shared/widgets/custom_information.dart';
import 'package:law_app/features/shared/widgets/dialog/sorting_dialog.dart';
import 'package:law_app/features/shared/widgets/form_field/search_field.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/loading_indicator.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

final userRoleProvider = StateProvider.autoDispose<String>((ref) => '');

class MasterDataHomePage extends ConsumerStatefulWidget {
  const MasterDataHomePage({super.key});

  @override
  ConsumerState<MasterDataHomePage> createState() => _MasterDataHomePageState();
}

class _MasterDataHomePageState extends ConsumerState<MasterDataHomePage> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    const userRoles = {
      'Semua': '',
      'Student': 'student',
      'Teacher': 'teacher',
      'Admin': 'admin',
    };

    final labels = userRoles.keys.toList();
    final users = ref.watch(masterDataProvider);
    final query = ref.watch(queryProvider);
    final selectedRole = ref.watch(userRoleProvider);

    ref.listen(masterDataProvider, (_, state) {
      state.whenOrNull(
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
      );
    });

    ref.listen(userActionsProvider, (_, state) {
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
            ref.invalidate(masterDataProvider);

            context.showBanner(message: data, type: BannerType.success);
          }
        },
      );
    });

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(180),
        child: Container(
          color: scaffoldBackgroundColor,
          child: HeaderContainer(
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
                        onPressed: () => showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => SortingDialog(
                            items: const [
                              'Nama',
                              'Username',
                              'Email',
                            ],
                            values: const [
                              'name',
                              'username',
                              'email',
                            ],
                            onSubmitted: sortUsers,
                          ),
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
                  onChanged: searchUser,
                ),
                const SizedBox(height: 20),
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
                  return CustomFilterChip(
                    label: labels[index],
                    selected: selectedRole == userRoles[labels[index]],
                    onSelected: (_) => filterUsers(userRoles[labels[index]]!),
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
            data: (users) {
              if (users == null) return const SliverFillRemaining();

              if (users.isEmpty && query.trim().isNotEmpty) {
                return const SliverFillRemaining(
                  child: CustomInformation(
                    illustrationName: 'house-searching-cuate.svg',
                    title: 'User tidak ditemukan',
                    subtitle: 'Data pengguna tersebut tidak ditemukan',
                  ),
                );
              }

              if (users.isEmpty) {
                return const SliverFillRemaining(
                  child: CustomInformation(
                    illustrationName: 'house-searching-cuate.svg',
                    title: 'Data pengguna masih kosong',
                    subtitle: 'Tambahkan data dengan menekan tombol di bawah.',
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
                          bottom: index == users.length - 1 ? 0 : 8,
                        ),
                        child: UserCard(user: users[index]),
                      );
                    },
                    childCount: users.length,
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
                      role: 'student',
                    ),
                  );
                },
              },
              {
                'text': 'Pakar',
                'onTap': () async {
                  navigatorKey.currentState!.pop();
                  navigatorKey.currentState!.pushNamed(
                    masterDataFormRoute,
                    arguments: const MasterDataFormPageArgs(
                      title: 'Tambah Teacher',
                      role: 'teacher',
                    ),
                  );
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
                      role: 'admin',
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

  void searchUser(String query) {
    if (query.trim().isNotEmpty) {
      ref.read(masterDataProvider.notifier).searchUsers(query: query);
    } else {
      ref.invalidate(masterDataProvider);
    }

    ref.read(queryProvider.notifier).state = query;
  }

  void sortUsers(Map<String, dynamic> value) {
    navigatorKey.currentState!.pop();

    ref.read(queryProvider.notifier).state = '';
    ref.read(masterDataProvider.notifier).sortUsers(
          sortBy: value['sortBy'],
          sortOrder: value['sortOrder'],
        );
  }

  void filterUsers(String role) {
    ref.read(queryProvider.notifier).state = '';
    ref.read(userRoleProvider.notifier).state = role;
    ref.read(masterDataProvider.notifier).filterUsers(role: role);
  }
}
