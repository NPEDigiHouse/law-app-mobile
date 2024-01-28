import 'package:flutter/material.dart';
import 'package:law_app/core/extensions/app_extension.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/dummies_data.dart';
import 'package:law_app/features/shared/widgets/custom_app_bar.dart';

class AccountInformationPage extends StatelessWidget {
  const AccountInformationPage({super.key});

  @override
  Widget build(BuildContext context) {
    List accountInformations = [
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
      appBar: const CustomAppBar(
        title: "Informasi Akun",
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Foto Profil",
                style: textTheme.headlineSmall!.copyWith(
                  color: primaryColor,
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: secondaryTextColor,
                        ),
                      ),
                      const SizedBox(
                        width: 8.0,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: scaffoldBackgroundColor,
                          border: Border.all(
                            color: accentColor,
                            width: 1.0,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 56,
                          foregroundImage: AssetImage(
                            AssetPath.getImage("no-profile.jpg"),
                          ),
                        ),
                      ),
                    ],
                  ),
                  FilledButton(
                    onPressed: () {},
                    style: FilledButton.styleFrom(
                        backgroundColor: secondaryColor,
                        foregroundColor: primaryColor),
                    child: const Text("Ubah Foto Profil"),
                  ),
                ],
              ),
              const SizedBox(
                height: 32.0,
              ),
              Text(
                "Data Diri",
                style: textTheme.headlineSmall!.copyWith(
                  color: primaryColor,
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: accountInformations.length,
                itemBuilder: (context, index) {
                  int lastIndex = accountInformations.length - 1;
                  return Row(
                    children: [
                      SizedBox(
                        height: 88.0,
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
                                        width: 4.0,
                                        decoration: BoxDecoration(
                                          color: (index != 0)
                                              ? secondaryTextColor
                                              : Colors.transparent,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        width: 4.0,
                                        decoration: BoxDecoration(
                                          color: (index != lastIndex)
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
                                  alignment: Alignment.center,
                                  width: 12.0,
                                  height: 12.0,
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
                      const SizedBox(
                        width: 16.0,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              accountInformations[index]["title"],
                              style: textTheme.bodyLarge!.copyWith(
                                color: primaryColor,
                              ),
                            ),
                            Text(
                              accountInformations[index]["value"],
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: textTheme.titleLarge!.copyWith(
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
              const SizedBox(
                height: 12.0,
              ),
              FilledButton(
                onPressed: () {},
                style: FilledButton.styleFrom(
                    backgroundColor: secondaryColor,
                    foregroundColor: primaryColor),
                child: const Text("Ubah Kata Sandi"),
              ).fullWidth(),
              FilledButton(
                onPressed: () {},
                child: const Text("Ubah Data"),
              ).fullWidth(),
            ],
          ),
        ),
      ),
    );
  }
}
