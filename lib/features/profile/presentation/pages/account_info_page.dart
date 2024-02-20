import 'package:flutter/material.dart';
import 'package:law_app/core/extensions/button_extension.dart';
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/dummies_data.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';

class AccountInfoPage extends StatelessWidget {
  final User user;

  const AccountInfoPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final accountInfo = [
      {
        "title": "Nama Lengkap",
        "value": user.fullName,
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
        "value": user.phone,
      },
    ];

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(96),
        child: HeaderContainer(
          title: 'Informasi Akun',
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
                "Foto Profil",
                style: textTheme.headlineSmall!.copyWith(
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  CircleAvatar(
                    radius: 56,
                    backgroundColor: accentColor,
                    child: CircleAvatar(
                      radius: 54,
                      foregroundImage: AssetImage(
                        AssetPath.getImage(user.profilePict),
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {},
                      style: FilledButton.styleFrom(
                        backgroundColor: secondaryColor,
                        foregroundColor: primaryColor,
                      ),
                      child: const Text("Ubah Foto Profil"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
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
              const SizedBox(height: 8),
              FilledButton(
                onPressed: () => context.showChangePasswordDialog(),
                style: FilledButton.styleFrom(
                  backgroundColor: secondaryColor,
                  foregroundColor: primaryColor,
                ),
                child: const Text("Ubah Password"),
              ).fullWidth(),
              FilledButton(
                onPressed: () => context.showEditProfileDialog(),
                child: const Text("Ubah Data"),
              ).fullWidth(),
            ],
          ),
        ),
      ),
    );
  }
}
