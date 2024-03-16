// Dart imports:
import 'dart:async';
import 'dart:io';

// Flutter imports:
import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

// Project imports:
import 'package:law_app/core/enums/banner_type.dart';
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/services/file_service.dart';
import 'package:law_app/core/services/image_service.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/admin/data/models/ad_models/ad_model.dart';
import 'package:law_app/features/admin/presentation/ad/providers/ad_detail_provider.dart';
import 'package:law_app/features/admin/presentation/ad/providers/ad_provider.dart';
import 'package:law_app/features/admin/presentation/ad/providers/create_ad_provider.dart';
import 'package:law_app/features/admin/presentation/ad/providers/edit_ad_provider.dart';
import 'package:law_app/features/shared/widgets/form_field/custom_text_field.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

final selectedImageProvider = StateProvider.autoDispose<String?>((ref) => null);

class AdminAdFormPage extends ConsumerStatefulWidget {
  final String title;
  final AdModel? ad;
  const AdminAdFormPage({
    super.key,
    required this.title,
    this.ad,
  });

  @override
  ConsumerState<AdminAdFormPage> createState() => _AdmiAdFormPageState();
}

class _AdmiAdFormPageState extends ConsumerState<AdminAdFormPage>
    with AfterLayoutMixin {
  late final GlobalKey<FormBuilderState> formKey;

  @override
  void initState() {
    formKey = GlobalKey<FormBuilderState>();
    super.initState();
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) async {
    context.showLoadingDialog();

    if (widget.ad != null) {
      final initImage =
          await FileService.downloadFile(url: widget.ad!.imageName!);

      if (initImage != null) {
        ref.read(selectedImageProvider.notifier).state = initImage;
      }
    }
    navigatorKey.currentState!.pop();
  }

  @override
  Widget build(BuildContext context) {
    final selectedImage = ref.watch(selectedImageProvider);

    ref.listen(createAdProvider, (_, state) {
      state.when(
        loading: () => context.showLoadingDialog(),
        error: (error, _) {
          navigatorKey.currentState!.pop();
          if ('$error' == kNoInternetConnection) {
            context.showNetworkErrorModalBottomSheet();
          } else {
            context.showBanner(message: '$error', type: BannerType.error);
          }
        },
        data: (data) {
          if (data != null) {
            navigatorKey.currentState!.pop();
            navigatorKey.currentState!.pop();

            ref.invalidate(adProvider);

            context.showBanner(
              message: 'Berhasil menambahkan Ad!',
              type: BannerType.success,
            );
          }
        },
      );
    });

    ref.listen(editAdProvider, (_, state) {
      state.when(
        loading: () => context.showLoadingDialog(),
        error: (error, _) {
          navigatorKey.currentState!.pop();
          if ('$error' == kNoInternetConnection) {
            context.showNetworkErrorModalBottomSheet();
          } else {
            context.showBanner(message: '$error', type: BannerType.error);
          }
        },
        data: (data) {
          if (data != null) {
            navigatorKey.currentState!.pop();
            navigatorKey.currentState!.pop();

            ref.invalidate(adProvider);
            ref.invalidate(adDetailProvider);

            context.showBanner(
              message: 'Berhasil mengedit Ad!',
              type: BannerType.success,
            );
          }
        },
      );
    });

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(96),
        child: HeaderContainer(
          title: widget.title,
          withBackButton: true,
          withTrailingButton: true,
          trailingButtonIconName: "check-line.svg",
          trailingButtonTooltip: "Tambah",
          onPressedTrailingButton: widget.ad == null ? createAd : editAd,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: FormBuilder(
            key: formKey,
            child: Column(
              children: [
                Text(
                  "Foto Ad",
                  textAlign: TextAlign.center,
                  style: textTheme.titleLarge!.copyWith(
                    color: primaryColor,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Container(
                  clipBehavior: Clip.antiAlias,
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Stack(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: selectedImage != null
                            ? Image.file(
                                File(selectedImage),
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                AssetPath.getImage('no-image.jpg'),
                                fit: BoxFit.cover,
                              ),
                      ),
                      Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(37, 244, 133, 125),
                              Color.fromARGB(75, 228, 77, 66),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            FilledButton.icon(
                              onPressed: () {
                                showActionsModalBottomSheet(
                                  context,
                                  ref,
                                );
                              },
                              style: FilledButton.styleFrom(
                                  foregroundColor: primaryColor,
                                  backgroundColor: secondaryColor),
                              icon: SvgAsset(
                                color: primaryColor,
                                assetPath: AssetPath.getIcon(
                                  "camera-solid.svg",
                                ),
                              ),
                              label: const Text("Unggah Sampul"),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                CustomTextField(
                  name: "title",
                  label: "Judul",
                  hasPrefixIcon: false,
                  hasSuffixIcon: false,
                  initialValue: widget.ad?.title,
                  hintText: "Masukkan judul",
                  validators: [
                    FormBuilderValidators.required(
                        errorText: "Bagian ini harus diisi")
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomTextField(
                  name: "content",
                  label: "Deskripsi",
                  maxLines: 4,
                  hintText: "Masukkan deskripsi",
                  hasPrefixIcon: false,
                  hasSuffixIcon: false,
                  initialValue: widget.ad?.content,
                  textInputAction: TextInputAction.done,
                  validators: [
                    FormBuilderValidators.required(
                        errorText: "Bagian ini harus diisi")
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void createAd() {
    FocusManager.instance.primaryFocus?.unfocus();

    if (formKey.currentState!.saveAndValidate()) {
      if (ref.read(selectedImageProvider.notifier).state == null) {
        context.showBanner(
            message: "Pilih Gambar Ad", type: BannerType.warning);
        return;
      }
      final data = formKey.currentState!.value;
      ref.read(createAdProvider.notifier).createAd(
            title: data['title'],
            content: data['content'],
            imageName: ref.read(selectedImageProvider.notifier).state!,
          );
    }
  }

  void editAd() {
    FocusManager.instance.primaryFocus?.unfocus();

    if (formKey.currentState!.saveAndValidate()) {
      if (ref.read(selectedImageProvider.notifier).state == null) {
        context.showBanner(
            message: "Pilih Gambar Ad", type: BannerType.warning);
        return;
      }
      final data = formKey.currentState!.value;
      final editedAd = widget.ad!.copyWith(
        title: data['title'],
        content: data['content'],
      );

      ref.read(editAdProvider.notifier).editAd(ad: editedAd);
    }
  }

  Future<void> showActionsModalBottomSheet(
    BuildContext context,
    WidgetRef ref,
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
                  await getAdImage(ref, ImageSource.camera);
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
                  await getAdImage(ref, ImageSource.gallery);
                },
                visualDensity: const VisualDensity(vertical: -2),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getAdImage(
    WidgetRef ref,
    ImageSource source,
  ) async {
    final imagePath = await ImageService.pickImage(source);

    if (imagePath != null) {
      final compressedImagePath = await ImageService.cropImage(
        imagePath: imagePath,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      );

      if (compressedImagePath != null) {
        ref.read(selectedImageProvider.notifier).state = compressedImagePath;
        navigatorKey.currentState!.pop();
      }
    }
  }
}

class AdminAdFormPageArgs {
  String title;
  AdModel? ad;
  AdminAdFormPageArgs({
    required this.title,
    this.ad,
  });
}
