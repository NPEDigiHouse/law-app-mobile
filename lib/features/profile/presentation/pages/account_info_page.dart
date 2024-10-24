// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

// Project imports:
import 'package:law_app/core/enums/banner_type.dart';
import 'package:law_app/core/extensions/button_extension.dart';
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/extensions/datetime_extension.dart';
import 'package:law_app/core/services/image_service.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/core/utils/credential_saver.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/admin/data/models/user_models/user_model.dart';
import 'package:law_app/features/admin/presentation/master_data/providers/user_actions_provider.dart';
import 'package:law_app/features/auth/presentation/providers/log_out_provider.dart';
import 'package:law_app/features/auth/presentation/providers/user_credential_provider.dart';
import 'package:law_app/features/profile/presentation/providers/profile_actions_provider.dart';
import 'package:law_app/features/profile/presentation/providers/profile_detail_provider.dart';
import 'package:law_app/features/profile/presentation/widgets/change_password_dialog.dart';
import 'package:law_app/features/profile/presentation/widgets/edit_profile_dialog.dart';
import 'package:law_app/features/shared/widgets/circle_profile_avatar.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/loading_indicator.dart';

class AccountInfoPage extends ConsumerWidget {
  const AccountInfoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = CredentialSaver.user!.id!;

    final user = ref.watch(ProfileDetailProvider(id: id));

    ref.listen(ProfileDetailProvider(id: id), (_, state) {
      state.whenOrNull(
        error: (error, _) {
          if ('$error' == kNoInternetConnection) {
            context.showNetworkErrorModalBottomSheet(
              onPressedPrimaryButton: () {
                navigatorKey.currentState!.pop();
                ref.invalidate(profileDetailProvider);
              },
            );
          } else {
            context.showBanner(message: '$error', type: BannerType.error);
          }
        },
      );
    });

    ref.listen(profileActionsProvider, (_, state) {
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

            ref.invalidate(ProfileDetailProvider(id: id));
            ref.invalidate(userCredentialProvider);

            context.showBanner(message: data, type: BannerType.success);
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
            ref.read(logOutProvider.notifier).logOut();
          }
        },
      );
    });

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(96),
        child: HeaderContainer(
          title: 'Informasi Akun',
          withBackButton: true,
        ),
      ),
      body: user.whenOrNull(
        loading: () => const LoadingIndicator(),
        data: (user) {
          if (user == null) return null;

          final userData = {
            "Nama Lengkap": user.name,
            "Username": user.username,
            "Email": user.email,
            "Tanggal Lahir": user.birthDate?.toStringPattern('d MMMM yyyy') ?? '-',
            "No. Hp": user.phoneNumber ?? '-',
          };

          if (user.role == 'teacher') {
            userData["Kepakaran"] = '${user.expertises?.map((e) => e.name).toList().join(', ')}';
          }

          return SingleChildScrollView(
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
                    CircleProfileAvatar(
                      imageUrl: user.profilePicture,
                      radius: 56,
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          showActionsModalBottomSheet(context, ref, user);
                        },
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
                  itemCount: userData.length,
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
                                            color: index != 0 ? secondaryTextColor : Colors.transparent,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          width: 2,
                                          decoration: BoxDecoration(
                                            color:
                                                index != userData.length - 1 ? secondaryTextColor : Colors.transparent,
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
                                userData.keys.toList()[index],
                                style: textTheme.bodySmall!.copyWith(
                                  color: primaryColor,
                                ),
                              ),
                              Text(
                                '${userData.values.toList()[index]}',
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
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => ChangePasswordDialog(email: user.email!),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: secondaryColor,
                    foregroundColor: primaryColor,
                  ),
                  child: const Text("Ganti Password"),
                ).fullWidth(),
                FilledButton(
                  onPressed: () => showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => EditProfileDialog(user: user),
                  ),
                  child: const Text("Edit Profile"),
                ).fullWidth(),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => context.showCustomAlertDialog(
                    title: 'Hapus Akun?',
                    message:
                        'Akun anda akan dihapus secara permanen. Setelah terhapus, Anda tidak bisa lagi menggunakan akun ini untuk mengakses aplikasi kami. Aksi ini tidak dapat dibatalkan!',
                    withCheckbox: true,
                    checkboxLabel: 'Saya mengerti. Hapus sekarang.',
                    onPressedPrimaryButton: () {
                      navigatorKey.currentState!.pop();

                      ref.read(userActionsProvider.notifier).deleteUser(id: user.id!);
                    },
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Hapus Akun",
                        style: textTheme.labelLarge!.copyWith(
                          color: errorColor,
                        ),
                      ),
                      Text(
                        "(Tindakan berbahaya)",
                        style: textTheme.labelSmall!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: errorColor,
                        ),
                      ),
                    ],
                  ),
                ).fullWidth(),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> showActionsModalBottomSheet(
    BuildContext context,
    WidgetRef ref,
    UserModel user,
  ) async {
    return showModalBottomSheet(
      context: context,
      enableDrag: false,
      isScrollControlled: true,
      builder: (context) => BottomSheet(
        onClosing: () {},
        enableDrag: false,
        builder: (context) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                leading: const Icon(
                  Icons.photo_camera_outlined,
                  color: primaryColor,
                ),
                title: const Text('Ambil Gambar'),
                textColor: primaryColor,
                onTap: () async {
                  await getAndSetProfilePicture(ref, user, ImageSource.camera);
                },
                visualDensity: const VisualDensity(vertical: -2),
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                leading: const Icon(
                  Icons.photo_library_outlined,
                  color: primaryColor,
                ),
                title: const Text('Pilih File Gambar'),
                textColor: primaryColor,
                onTap: () async {
                  await getAndSetProfilePicture(ref, user, ImageSource.gallery);
                },
                visualDensity: const VisualDensity(vertical: -2),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getAndSetProfilePicture(
    WidgetRef ref,
    UserModel user,
    ImageSource source,
  ) async {
    final imagePath = await ImageService.pickImage(source);

    if (imagePath != null) {
      final compressedImagePath = await ImageService.cropImage(
        imagePath: imagePath,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      );

      if (compressedImagePath != null) {
        navigatorKey.currentState!.pop();

        ref.read(profileActionsProvider.notifier).editProfile(user: user, path: compressedImagePath);
      }
    }
  }
}
