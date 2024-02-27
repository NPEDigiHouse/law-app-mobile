// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

// Project imports:
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/shared/widgets/dialog/custom_dialog.dart';
import 'package:law_app/features/shared/widgets/form_field/custom_dropdown_field.dart';
import 'package:law_app/features/shared/widgets/form_field/custom_text_field.dart';

class CreateQuestionDialog extends StatelessWidget {
  final List<String> categories;

  const CreateQuestionDialog({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormBuilderState>();

    return CustomDialog(
      title: 'Buat Pertanyaan',
      primaryButtonText: 'Submit',
      onPressedPrimaryButton: () => createQuestion(formKey),
      child: FormBuilder(
        key: formKey,
        child: Column(
          children: [
            CustomDropdownField(
              isSmall: true,
              name: 'category',
              label: 'Kategori',
              items: categories,
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
              textInputAction: TextInputAction.next,
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

  void createQuestion(GlobalKey<FormBuilderState> formKey) {
    FocusManager.instance.primaryFocus?.unfocus();

    if (formKey.currentState!.saveAndValidate()) {
      final data = formKey.currentState!.value;

      debugPrint(data.toString());

      navigatorKey.currentState!.pop(true);
    }
  }
}
