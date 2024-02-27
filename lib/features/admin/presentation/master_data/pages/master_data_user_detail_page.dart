// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:law_app/core/enums/banner_type.dart';
import 'package:law_app/core/extensions/button_extension.dart';
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/extensions/string_extension.dart';
import 'package:law_app/core/routes/route_names.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/core/utils/credential_saver.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/admin/presentation/master_data/pages/master_data_form_page.dart';
import 'package:law_app/features/admin/presentation/master_data/providers/get_user_detail_provider.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/loading_indicator.dart';

class MasterDataUserDetailPage extends ConsumerWidget {
  const MasterDataUserDetailPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = CredentialSaver.user!.id!;
    final sections = [
      "Nama Lengkap",
      "Username",
      "Email",
      "Tanggal Lahir",
      "No. Hp",
    ];

    var user = ref.watch(GetUserDetailProvider(id: id));

    ref.listen(GetUserDetailProvider(id: id), (previous, next) {
      if (previous != next) {
        user = next;
      }

      next.when(
        error: (error, _) {
          if ('$error' == kNoInternetConnection) {
            context.showNetworkErrorModalBottomSheet(
              onPressedPrimaryButton: () {
                navigatorKey.currentState!.pop();
                ref.invalidate(GetUserDetailProvider(id: id));
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

    return user.when(
      loading: () => const LoadingIndicator(withScaffold: true),
      error: (error, __) => const Scaffold(),
      data: (user) {
        if (user == null) return const Scaffold();

        final userValues = user.toMap().values.toList();

        return Scaffold(
          appBar: const PreferredSize(
            preferredSize: Size.fromHeight(96),
            child: HeaderContainer(
              title: 'Detail Pengguna',
              withBackButton: true,
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 24,
                horizontal: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Data Diri",
                    style: textTheme.headlineSmall!.copyWith(
                      color: primaryColor,
                    ),
                  ),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: sections.length,
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          SizedBox(
                            height: 64,
                            child: Stack(
                              children: [
                                Positioned(
                                  top: 0,
                                  left: 0,
                                  right: 0,
                                  bottom: 0,
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            width: 2,
                                            decoration: BoxDecoration(
                                              color: index != 0
                                                  ? secondaryTextColor
                                                  : Colors.transparent,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            width: 2,
                                            decoration: BoxDecoration(
                                              color:
                                                  index != sections.length - 1
                                                      ? secondaryTextColor
                                                      : Colors.transparent,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  child: Center(
                                    child: Container(
                                      width: 12,
                                      height: 12,
                                      decoration: const BoxDecoration(
                                        color: secondaryTextColor,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  sections[index],
                                  style: textTheme.bodySmall!.copyWith(
                                    color: primaryColor,
                                  ),
                                ),
                                Text(
                                  '${userValues[index + 2]}',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: textTheme.titleMedium!.copyWith(
                                    color: primaryTextColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: FilledButton(
              onPressed: () => navigatorKey.currentState!.pushNamed(
                masterDataFormRoute,
                arguments: MasterDataFormPageArgs(
                  title: 'Edit ${user.role?.toCapitalize()}',
                  user: user,
                ),
              ),
              child: const Text("Ubah Data"),
            ).fullWidth(),
          ),
        );
      },
    );
  }
}
