// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:law_app/core/helpers/function_helper.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/admin/data/models/course_models/course_model.dart';
import 'package:law_app/features/shared/providers/course_providers/user_course_actions_provider.dart';
import 'package:law_app/features/shared/widgets/dialog/custom_dialog.dart';

class EnrollCourseDialog extends ConsumerWidget {
  final CourseModel course;

  const EnrollCourseDialog({super.key, required this.course});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomDialog(
      title: 'Daftar Course',
      primaryButtonText: 'Daftar',
      onPressedPrimaryButton: () {
        navigatorKey.currentState!.pop();

        ref
            .read(userCourseActionsProvider.notifier)
            .createUserCourse(courseId: course.id!);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  'Nama Course',
                  style: textTheme.bodySmall,
                ),
              ),
              Expanded(
                flex: 4,
                child: Text(
                  '${course.title}',
                  style: textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  'Jam Belajar',
                  style: textTheme.bodySmall,
                ),
              ),
              Expanded(
                flex: 4,
                child: Text(
                  '±${FunctionHelper.minutesToHours(course.courseDuration!)} jam',
                  style: textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Deskripsi Kelas',
            style: textTheme.titleMedium,
          ),
          Divider(
            color: Theme.of(context).dividerColor,
            height: 10,
          ),
          Text(
            '${course.description}',
            style: textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
