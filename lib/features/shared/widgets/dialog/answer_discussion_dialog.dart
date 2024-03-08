// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

// Project imports:
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/credential_saver.dart';
import 'package:law_app/features/admin/data/models/discussion_models/discussion_detail_model.dart';
import 'package:law_app/features/shared/providers/discussion_providers/create_discussion_comment_provider.dart';
import 'package:law_app/features/shared/providers/discussion_providers/edit_discussion_provider.dart';
import 'package:law_app/features/shared/widgets/dialog/custom_dialog.dart';
import 'package:law_app/features/shared/widgets/form_field/custom_text_field.dart';

class AnswerDiscussionDialog extends ConsumerWidget {
  final DiscussionDetailModel discussion;

  const AnswerDiscussionDialog({super.key, required this.discussion});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormBuilderState>();

    return CustomDialog(
      title: 'Jawab Pertanyaan',
      primaryButtonText: 'Jawab',
      onPressedPrimaryButton: () => answerQuestion(formKey, ref),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${discussion.title}',
            style: textTheme.titleMedium!.copyWith(
              color: primaryColor,
              height: 0,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${discussion.description}',
            style: textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          FormBuilder(
            key: formKey,
            child: CustomTextField(
              isSmall: true,
              name: 'text',
              label: 'Jawaban Anda',
              hintText: 'Masukkan jawaban Anda',
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
          ),
        ],
      ),
    );
  }

  void answerQuestion(GlobalKey<FormBuilderState> formKey, WidgetRef ref) {
    FocusManager.instance.primaryFocus?.unfocus();

    if (formKey.currentState!.saveAndValidate()) {
      final data = formKey.currentState!.value;

      ref
          .read(createDiscussionCommentProvider.notifier)
          .createDiscussionComment(
            discussionId: discussion.id!,
            userId: CredentialSaver.user!.id!,
            text: data['text'],
          );

      ref.read(editDiscussionProvider.notifier).editDiscussion(
            discussionId: discussion.id!,
            handlerId: CredentialSaver.user!.id,
            status: 'onDiscussion',
          );
    }
  }
}
