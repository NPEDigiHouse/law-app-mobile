// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:law_app/core/extensions/button_extension.dart';
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/extensions/string_extension.dart';
import 'package:law_app/core/routes/route_names.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/dummies_data.dart';
import 'package:law_app/features/admin/presentation/master_data/pages/master_data_form_page.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';

class MasterDataUserDetailPage extends StatelessWidget {
  final User user;

  const MasterDataUserDetailPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final accountInfo = [
      {
        "title": "Nama Lengkap",
        "value": user.name,
      },
      {
        "title": "Username",
        "value": user.username,
      },
      {
        "title": "Email",
        "value": user.email,
      },
      {
        "title": "Tanggal Lahir",
        "value": user.dateOfBirth,
      },
      {
        "title": "No. Hp",
        "value": user.phoneNumber,
      },
    ];

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(96),
        child: HeaderContainer(
          title: 'Detail Pengguna',
          withBackButton: true,
          withTrailingButton: true,
          trailingButtonIconName: 'trash-line.svg',
          trailingButtonTooltip: 'Hapus',
          onPressedTrailingButton: () => context.showConfirmDialog(
            title: 'Hapus User',
            message: 'Anda yakin ingin menghapus seluruh data user ini?',
            primaryButtonText: 'Hapus',
            onPressedPrimaryButton: () {},
          ),
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
                itemCount: accountInfo.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      SizedBox(
                        height: 70,
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
                                          color: index != accountInfo.length - 1
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
                              accountInfo[index]["title"]!,
                              style: textTheme.bodySmall!.copyWith(
                                color: primaryColor,
                              ),
                            ),
                            Text(
                              accountInfo[index]["value"]!,
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
            arguments: MasterDataFormArgs(
              title: 'Edit ${user.role.toCapitalize()}',
              user: user,
            ),
          ),
          child: const Text("Ubah Data"),
        ).fullWidth(),
      ),
    );
  }
}
