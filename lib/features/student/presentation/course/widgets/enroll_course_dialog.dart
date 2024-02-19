import 'package:flutter/material.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/dummies_data.dart';
import 'package:law_app/features/shared/widgets/dialog/custom_dialog.dart';

class EnrollCourseDialog extends StatelessWidget {
  final CourseDetail courseDetail;

  const EnrollCourseDialog({super.key, required this.courseDetail});

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: 'Daftar Course',
      primaryButtonText: 'Daftar',
      onPressedPrimaryButton: () {},
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
                  courseDetail.title,
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
                  '±${courseDetail.completionTime} Jam',
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
            courseDetail.description,
            style: textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
