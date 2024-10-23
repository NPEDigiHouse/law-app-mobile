// Dart imports:
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
import 'package:law_app/core/extensions/button_extension.dart';
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/services/file_service.dart';
import 'package:law_app/core/services/image_service.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/admin/data/models/course_models/course_model.dart';
import 'package:law_app/features/admin/data/models/course_models/course_post_model.dart';
import 'package:law_app/features/shared/providers/course_providers/course_actions_provider.dart';
import 'package:law_app/features/shared/providers/course_providers/course_detail_provider.dart';
import 'package:law_app/features/shared/providers/manual_providers/image_path_provider.dart';
import 'package:law_app/features/shared/widgets/form_field/custom_text_field.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';

class AdminCourseFormPage extends ConsumerStatefulWidget {
  final String title;
  final CourseModel? course;

  const AdminCourseFormPage({
    super.key,
    required this.title,
    this.course,
  });

  @override
  ConsumerState<AdminCourseFormPage> createState() => _AdminCourseFormPageState();
}

class _AdminCourseFormPageState extends ConsumerState<AdminCourseFormPage> with AfterLayoutMixin {
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

  @override
  Future<void> afterFirstLayout(BuildContext context) async {
    if (widget.course != null) {
      context.showLoadingDialog();

      final imagePath = await FileService.downloadFile(url: widget.course!.coverImg!);

      if (imagePath != null) {
        ref.read(imagePathProvider.notifier).state = imagePath;
      }

      navigatorKey.currentState!.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final imagePath = ref.watch(imagePathProvider);

    ref.listen(courseActionsProvider, (_, state) {
      state.whenOrNull(
        data: (data) {
          if (data != null) {
            navigatorKey.currentState!.pop();

            if (widget.course != null) {
              ref.invalidate(CourseDetailProvider(id: widget.course!.id!));
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
                      aspectRatio: 3 / 2,
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
                        aspectRatio: 3 / 2,
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
                label: 'Nama Course',
                hintText: 'Masukkan nama course',
                initialValue: widget.course?.title,
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
                name: 'description',
                label: 'Deskripsi Course',
                hintText: 'Masukkan deskripsi course',
                initialValue: widget.course?.description,
                maxLines: 5,
                hasPrefixIcon: false,
                hasSuffixIcon: false,
                textInputAction: TextInputAction.newline,
                validators: [
                  FormBuilderValidators.required(
                    errorText: "Bagian ini harus diisi",
                  ),
                ],
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: widget.course != null ? () => editCourse(imagePath ?? '') : () => createCourse(imagePath),
                child: Text(widget.title),
              ).fullWidth(),
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
        aspectRatio: const CropAspectRatio(ratioX: 3, ratioY: 2),
      );

      if (compressedImagePath != null) {
        ref.read(imagePathProvider.notifier).state = compressedImagePath;
      }
    }
  }

  void editCourse(String imagePath) {
    FocusManager.instance.primaryFocus?.unfocus();

    if (formKey.currentState!.saveAndValidate()) {
      final data = formKey.currentState!.value;

      final isUpdatedImage = p.basename(widget.course!.coverImg!) != p.basename(imagePath);

      ref.read(courseActionsProvider.notifier).editCourse(
            course: CourseModel(
              id: widget.course!.id,
              title: data['title'],
              description: data['description'],
              coverImg: isUpdatedImage ? imagePath : null,
            ),
          );
    }
  }

  void createCourse(String? imagePath) {
    FocusManager.instance.primaryFocus?.unfocus();

    if (formKey.currentState!.saveAndValidate()) {
      if (imagePath == null) {
        context.showBanner(
          message: 'Anda belum memilih gambar course!',
          type: BannerType.error,
        );

        return;
      }

      final data = formKey.currentState!.value;

      ref.read(courseActionsProvider.notifier).createCourse(
            course: CoursePostModel(
              title: data['title'],
              description: data['description'],
              cover: imagePath,
            ),
          );
    }
  }
}

class AdminCourseFormPageArgs {
  final String title;
  final CourseModel? course;

  const AdminCourseFormPageArgs({
    required this.title,
    this.course,
  });
}
