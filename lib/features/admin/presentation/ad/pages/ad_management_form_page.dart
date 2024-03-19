// Dart imports:
import 'dart:async';
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:after_layout/after_layout.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;

// Project imports:
import 'package:law_app/core/enums/banner_type.dart';
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/services/file_service.dart';
import 'package:law_app/core/services/image_service.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/admin/data/models/ad_models/ad_detail_model.dart';
import 'package:law_app/features/admin/data/models/ad_models/ad_post_model.dart';
import 'package:law_app/features/admin/presentation/ad/providers/ad_actions_provider.dart';
import 'package:law_app/features/admin/presentation/ad/providers/ad_detail_provider.dart';
import 'package:law_app/features/shared/widgets/form_field/custom_text_field.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';

final imagePathProvider = StateProvider.autoDispose<String?>((ref) => null);

class AdManagementFormPage extends ConsumerStatefulWidget {
  final String title;
  final AdDetailModel? ad;

  const AdManagementFormPage({super.key, required this.title, this.ad});

  @override
  ConsumerState<AdManagementFormPage> createState() => _AdmiAdFormPageState();
}

class _AdmiAdFormPageState extends ConsumerState<AdManagementFormPage>
    with AfterLayoutMixin {
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) async {
    context.showLoadingDialog();

    if (widget.ad != null) {
      final imagePath =
          await FileService.downloadFile(url: widget.ad!.imageName!);

      if (imagePath != null) {
        ref.read(imagePathProvider.notifier).state = imagePath;
      }
    }

    navigatorKey.currentState!.pop();
  }

  @override
  Widget build(BuildContext context) {
    final imagePath = ref.watch(imagePathProvider);

    ref.listen(adActionsProvider, (_, state) {
      state.whenOrNull(
        data: (data) {
          if (data != null) {
            navigatorKey.currentState!.pop();

            if (widget.ad != null) {
              ref.invalidate(AdDetailProvider(id: widget.ad!.id!));
            }
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
          onPressedTrailingButton: widget.ad != null
              ? () => editAd(imagePath ?? '')
              : () => createAd(imagePath),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          vertical: 24,
          horizontal: 20,
        ),
        child: FormBuilder(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  if (imagePath != null)
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: FileImage(File(imagePath)),
                          ),
                        ),
                      ),
                    )
                  else
                    DottedBorder(
                      borderType: BorderType.RRect,
                      strokeCap: StrokeCap.round,
                      radius: const Radius.circular(12),
                      dashPattern: const [4, 4],
                      color: secondaryTextColor,
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Center(
                            child: Text(
                              'Ekstensi file yang diizinkan: .jpg, .jpeg, atau .png',
                              textAlign: TextAlign.center,
                              style: textTheme.bodyMedium!.copyWith(
                                color: secondaryTextColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    bottom: 16,
                    child: FilledButton.icon(
                      onPressed: pickImageFile,
                      icon: const Icon(
                        Icons.photo_library_rounded,
                        size: 20,
                      ),
                      label: Text(
                        imagePath != null ? 'Ganti Gambar' : 'Pilih Gambar',
                      ),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        backgroundColor: secondaryColor,
                        foregroundColor: primaryColor,
                        textStyle: textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              CustomTextField(
                name: 'title',
                label: 'Judul',
                hintText: 'Masukkan judul iklan',
                initialValue: widget.ad?.title,
                hasPrefixIcon: false,
                hasSuffixIcon: false,
                textCapitalization: TextCapitalization.words,
                validators: [
                  FormBuilderValidators.required(
                    errorText: "Bagian ini harus diisi",
                  ),
                ],
              ),
              const SizedBox(height: 20),
              CustomTextField(
                name: 'content',
                label: 'Deskripsi',
                hintText: 'Masukkan deskripsi iklan',
                initialValue: widget.ad?.content,
                maxLines: 6,
                hasPrefixIcon: false,
                hasSuffixIcon: false,
                textInputAction: TextInputAction.newline,
                validators: [
                  FormBuilderValidators.required(
                    errorText: "Bagian ini harus diisi",
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> pickImageFile() async {
    final path = await ImageService.pickImage(ImageSource.gallery);

    if (path != null) {
      final compressedImagePath = await ImageService.cropImage(
        imagePath: path,
        aspectRatio: const CropAspectRatio(ratioX: 16, ratioY: 9),
      );

      if (compressedImagePath != null) {
        ref.read(imagePathProvider.notifier).state = compressedImagePath;
      }
    }
  }

  void editAd(String imagePath) {
    FocusManager.instance.primaryFocus?.unfocus();

    if (formKey.currentState!.saveAndValidate()) {
      final data = formKey.currentState!.value;

      final isUpdatedImage =
          p.basename(widget.ad!.imageName!) != p.basename(imagePath);

      ref.read(adActionsProvider.notifier).editAd(
            ad: AdDetailModel(
              id: widget.ad!.id,
              title: data['title'],
              content: data['content'],
              imageName: isUpdatedImage ? imagePath : null,
            ),
          );
    }
  }

  void createAd(String? imagePath) {
    FocusManager.instance.primaryFocus?.unfocus();

    if (formKey.currentState!.saveAndValidate()) {
      if (imagePath == null) {
        context.showBanner(
          message: 'Anda belum memilih gambar iklan!',
          type: BannerType.error,
        );

        return;
      }

      final data = formKey.currentState!.value;

      ref.read(adActionsProvider.notifier).createAd(
            ad: AdPostModel(
              title: data['title'],
              content: data['content'],
              file: imagePath,
            ),
          );
    }
  }
}

class AdManagementFormPageArgs {
  final String title;
  final AdDetailModel? ad;

  const AdManagementFormPageArgs({
    required this.title,
    this.ad,
  });
}
