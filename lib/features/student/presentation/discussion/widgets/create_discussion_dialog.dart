// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

// Project imports:
import 'package:law_app/features/admin/data/models/discussion_models/discussion_category_model.dart';
import 'package:law_app/features/admin/data/models/discussion_models/discussion_post_model.dart';
import 'package:law_app/features/shared/providers/discussion_providers/create_discussion_provider.dart';
import 'package:law_app/features/shared/widgets/dialog/custom_dialog.dart';
import 'package:law_app/features/shared/widgets/form_field/custom_dropdown_field.dart';
import 'package:law_app/features/shared/widgets/form_field/custom_text_field.dart';

class CreateDiscussionDialog extends ConsumerWidget {
  final List<DiscussionCategoryModel> categories;

  const CreateDiscussionDialog({super.key, required this.categories});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormBuilderState>();

    return CustomDialog(
      title: 'Buat Pertanyaan',
      primaryButtonText: 'Submit',
      onPressedPrimaryButton: () => createQuestion(formKey, ref),
      child: FormBuilder(
        key: formKey,
        child: Column(
          children: [
            CustomDropdownField(
              isSmall: true,
              name: 'categoryId',
              label: 'Kategori',
              items: categories.map((e) => e.name!).toList(),
              values: categories.map((e) => e.id!.toString()).toList(),
              initialValue: categories.first.id.toString(),
              onChanged: (_) {},
            ),
            const SizedBox(height: 10),
            CustomTextField(
              isSmall: true,
              name: 'title',
              label: 'Judul',
              hintText: 'Masukkan judul pertanyaan',
              hasPrefixIcon: false,
              hasSuffixIcon: false,
              validators: [
                FormBuilderValidators.required(
                  errorText: "Bagian ini harus diisi",
                ),
              ],
            ),
            const SizedBox(height: 10),
            CustomTextField(
              isSmall: true,
              name: 'description',
              label: 'Deskripsi',
              hintText: 'Masukkan deskripsi pertanyaan',
              maxLines: 4,
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
    );
  }

  void createQuestion(GlobalKey<FormBuilderState> formKey, WidgetRef ref) {
    FocusManager.instance.primaryFocus?.unfocus();

    if (formKey.currentState!.saveAndValidate()) {
      final data = formKey.currentState!.value;

      ref.read(createDiscussionProvider.notifier).createDiscussion(
            discussion: DiscussionPostModel(
              title: data['title'],
              description: data['description'],
              categoryId: int.parse(data['categoryId']),
            ),
          );
    }
  }
}
