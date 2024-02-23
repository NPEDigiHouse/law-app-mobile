import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/dummies_data.dart';
import 'package:law_app/features/shared/widgets/custom_filter_chip.dart';
import 'package:law_app/features/shared/widgets/custom_information.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';
import 'package:law_app/features/shared/widgets/text_field/search_field.dart';

class MasterDataHomePage extends ConsumerStatefulWidget {
  const MasterDataHomePage({super.key});

  @override
  ConsumerState<MasterDataHomePage> createState() => _MasterDataHomePageState();
}

class _MasterDataHomePageState extends ConsumerState<MasterDataHomePage> {
  late List<User> users;
  late final List<String> roles;
  late final ValueNotifier<String> selectedRole;
  late final ValueNotifier<String> query;

  @override
  void initState() {
    super.initState();

    users = [
      ...List<User>.generate(4, (index) => user),
      ...List<User>.generate(3, (index) => teacher),
      ...List<User>.generate(3, (index) => admin),
    ];

    roles = [
      'Semua',
      'Student',
      'Teacher',
      'Admin',
    ];

    selectedRole = ValueNotifier(roles.first);
    query = ValueNotifier('');
  }

  @override
  void dispose() {
    super.dispose();

    selectedRole.dispose();
    query.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                          title: 'Urutkan Item',
                          onSubmitted: (value) {},
                          items: [
                            'Nama',
                            'Username',
                            'Email',
                            'No. HP',
                            'Tanggal Lahir',
                          ],
                        ),
                        icon: SvgAsset(
                          assetPath:
                              AssetPath.getIcon('sort-by-line-right.svg'),
                          color: primaryColor,
                          width: 24,
                        ),
                        tooltip: 'Urutkan',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ValueListenableBuilder(
                  valueListenable: query,
                  builder: (context, query, child) {
                    return SearchField(
                      text: query,
                      hintText: 'Cari pengguna',
                      onChanged: searchUser,
                    );
                  },
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
                  return ValueListenableBuilder(
                    valueListenable: selectedRole,
                    builder: (context, role, child) {
                      return CustomFilterChip(
                        label: roles[index],
                        selected: role == roles[index],
                        onSelected: (_) {
                          selectedRole.value = roles[index];
                        },
                      );
                    },
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(width: 8);
                },
                itemCount: roles.length,
              ),
            ),
          ),
          Builder(
            builder: (context) {
              if (users.isEmpty) {
                return const SliverFillRemaining(
                  child: CustomInformation(
                    illustrationName: 'house-searching-cuate.svg',
                    title: 'Pengguna Tidak Ditemukan',
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
                        // child: DiscussionCard(
                        //   question: items[index],
                        //   roleId: widget.roleId,
                        //   isDetail: true,
                        //   withProfile: true,
                        // ),
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
    );
  }

  void searchUser(String query) {
    this.query.value = query;

    EasyDebounce.debounce(
      'search-debouncer',
      const Duration(milliseconds: 800),
      () {},
    );

    if (query.isEmpty) {
      EasyDebounce.fire('search-debouncer');
    }
  }
}
