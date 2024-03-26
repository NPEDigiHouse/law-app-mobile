// Dart imports:
import 'dart:async';
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:after_layout/after_layout.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:law_app/core/enums/banner_type.dart';
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/extensions/datetime_extension.dart';
import 'package:law_app/core/services/file_service.dart';
import 'package:law_app/core/services/image_service.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/admin/data/models/ad_models/ad_detail_model.dart';
import 'package:law_app/features/admin/data/models/ad_models/ad_post_model.dart';
import 'package:law_app/features/admin/presentation/ad/providers/ad_actions_provider.dart';
import 'package:law_app/features/admin/presentation/ad/providers/ad_detail_provider.dart';
import 'package:law_app/features/shared/providers/manual_providers/checkbox_provider.dart';
import 'package:law_app/features/shared/providers/manual_providers/image_path_provider.dart';
import 'package:law_app/features/shared/widgets/empty_content_text.dart';
import 'package:law_app/features/shared/widgets/form_field/custom_text_field.dart';
import 'package:law_app/features/shared/widgets/form_field/markdown_field.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';

final adTitleProvider = StateProvider.autoDispose<String?>((ref) => null);
final adContentProvider = StateProvider.autoDispose<String?>((ref) => null);

class AdManagementFormPage extends ConsumerStatefulWidget {
  final String title;
  final AdDetailModel? ad;

  const AdManagementFormPage({
    super.key,
    required this.title,
    this.ad,
  });

  @override
  ConsumerState<AdManagementFormPage> createState() => _AdmiAdFormPageState();
}

class _AdmiAdFormPageState extends ConsumerState<AdManagementFormPage>
    with AfterLayoutMixin {
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

  @override
  Future<void> afterFirstLayout(BuildContext context) async {
    if (widget.ad != null) {
      context.showLoadingDialog();

      ref.read(adTitleProvider.notifier).state = widget.ad!.title!;
      ref.read(adContentProvider.notifier).state = widget.ad!.content!;

      final imagePath =
          await FileService.downloadFile(url: widget.ad!.imageName!);

      if (imagePath != null) {
        ref.read(imagePathProvider.notifier).state = imagePath;
      }

      navigatorKey.currentState!.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final showPreview = ref.watch(isCheckedProvider);
    final title = ref.watch(adTitleProvider);
    final content = ref.watch(adContentProvider);
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
      extendBodyBehindAppBar: showPreview,
      appBar: showPreview
          ? null
          : PreferredSize(
              preferredSize: const Size.fromHeight(96),
              child: HeaderContainer(
                title: widget.title,
                withBackButton: true,
                withTrailingButton: true,
                trailingButtonIconName: 'check-line.svg',
                trailingButtonTooltip: 'Submit',
                onPressedTrailingButton: () {
                  widget.ad != null
                      ? editAd(imagePath ?? '')
                      : createAd(imagePath);
                },
              ),
            ),
      body: showPreview
          ? buildAdPreview(title, content, imagePath)
          : buildAdForm(title, content, imagePath),
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
          onPressed: () {
            if (!showPreview) {
              ref.read(adTitleProvider.notifier).state =
                  formKey.currentState!.fields['title']!.value;
              ref.read(adContentProvider.notifier).state =
                  formKey.currentState!.fields['content']!.value;
            }

            ref.read(isCheckedProvider.notifier).state = !showPreview;
          },
          icon: showPreview
              ? const Icon(
                  Icons.visibility_outlined,
                  color: scaffoldBackgroundColor,
                )
              : const Icon(
                  Icons.code_outlined,
                  color: scaffoldBackgroundColor,
                ),
          tooltip: showPreview ? 'Preview' : 'Editor',
        ),
      ),
    );
  }

  SingleChildScrollView buildAdPreview(
    String? title,
    String? content,
    String? imagePath,
  ) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DecoratedBox(
            position: DecorationPosition.foreground,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFA2355A).withOpacity(.1),
                  const Color(0xFF730034).withOpacity(.6),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: imagePath != null
                  ? Image.file(File(imagePath))
                  : const EmptyContentText('Belum ada gambar!'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 24,
              horizontal: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title ?? '',
                  style: textTheme.titleLarge!.copyWith(
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Dibuat pada ${DateTime.now().toStringPattern('d MMMM yyyy')}',
                  style: textTheme.labelSmall!.copyWith(
                    color: secondaryTextColor,
                  ),
                ),
                const SizedBox(height: 12),
                MarkdownBody(
                  data: content ?? '',
                  selectable: true,
                  onTapLink: (text, href, title) async {
                    if (href != null) {
                      final url = Uri.parse(href);

                      if (await canLaunchUrl(url)) await launchUrl(url);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  SingleChildScrollView buildAdForm(
    String? title,
    String? content,
    String? imagePath,
  ) {
    return SingleChildScrollView(
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
              initialValue: title ?? widget.ad?.title,
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
            MarkdownField(
              name: 'content',
              label: 'Konten',
              hintText: 'Masukkan konten iklan',
              initialValue: content ?? widget.ad?.content,
              onChanged: (_) {},
            ),
            const SizedBox(height: 64),
          ],
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
    } else {
      context.showBanner(
        message: 'Masih terdapat form yang kosong!',
        type: BannerType.error,
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
    } else {
      context.showBanner(
        message: 'Masih terdapat form yang kosong!',
        type: BannerType.error,
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
