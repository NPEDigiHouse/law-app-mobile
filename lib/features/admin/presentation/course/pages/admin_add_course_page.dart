import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:image_picker/image_picker.dart';
import 'package:law_app/core/extensions/button_extension.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';
import 'package:law_app/features/shared/widgets/text_field/custom_text_field.dart';

class AdminAddCoursePage extends StatefulWidget {
  const AdminAddCoursePage({super.key});

  @override
  State<AdminAddCoursePage> createState() => _AdminAddCoursePageState();
}

class _AdminAddCoursePageState extends State<AdminAddCoursePage> {
  late final ValueNotifier<File?> selectedImage;

  Future _selectPhotoFromGallery() async {
    debugPrint("Selecting Image...");
    final value = await ImagePicker().pickImage(source: ImageSource.gallery);
    debugPrint("Image Selected");

    if (value == null) return;

    selectedImage.value = File(value.path);
  }

  @override
  void initState() {
    super.initState();
    selectedImage = ValueNotifier(null);
  }

  @override
  void dispose() {
    super.dispose();
    selectedImage.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(96),
        child: HeaderContainer(
          title: 'Tambah Course',
          withBackButton: true,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                "Sampul Course",
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
                    ValueListenableBuilder(
                      valueListenable: selectedImage,
                      builder: (context, value, child) {
                        return SizedBox(
                          width: double.infinity,
                          child: value != null
                              ? Image.file(
                                  value,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  AssetPath.getImage(
                                    "no-image.jpg",
                                  ),
                                  fit: BoxFit.cover,
                                ),
                        );
                      },
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
                              _selectPhotoFromGallery();
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
              const Divider(
                color: secondaryTextColor,
                height: 40,
              ),
              FormBuilder(
                child: Column(
                  children: [
                    CustomTextField(
                      name: "course_title",
                      label: "Judul Course",
                      hasPrefixIcon: false,
                      hasSuffixIcon: false,
                      hintText: "Masukkan judul course",
                      validators: [
                        FormBuilderValidators.required(
                          errorText: "Bagian ini harus diisi",
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    CustomTextField(
                      name: "course_description",
                      label: "Descripsi",
                      hasPrefixIcon: false,
                      hasSuffixIcon: false,
                      hintText: "Masukkan deskripsi",
                      maxLines: 4,
                      validators: [
                        FormBuilderValidators.required(
                          errorText: "Bagian ini harus diisi",
                        )
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              FilledButton(
                onPressed: () {},
                child: Text("Tambah Course"),
              ).fullWidth(),
            ],
          ),
        ),
      ),
    );
  }
}
