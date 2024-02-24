// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:law_app/core/extensions/button_extension.dart';
import 'package:law_app/core/helpers/function_helper.dart';
import 'package:law_app/core/routes/route_names.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/dummies_data.dart';
import 'package:law_app/features/shared/widgets/animated_fab.dart';
import 'package:law_app/features/shared/widgets/circle_profile_avatar.dart';
import 'package:law_app/features/shared/widgets/custom_icon_button.dart';
import 'package:law_app/features/shared/widgets/feature/discussion_card.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';

class TeacherDiscussionHomePage extends StatefulWidget {
  const TeacherDiscussionHomePage({super.key});

  @override
  State<TeacherDiscussionHomePage> createState() =>
      _TeacherDiscussionHomePageState();
}

class _TeacherDiscussionHomePageState extends State<TeacherDiscussionHomePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController fabAnimationController;
  late final ScrollController scrollController;

  @override
  void initState() {
    super.initState();

    fabAnimationController = AnimationController(
      vsync: this,
      duration: kThemeAnimationDuration,
    );

    scrollController = ScrollController()
      ..addListener(() {
        if (scrollController.offset == 0) {
          fabAnimationController.reverse();
        }
      });
  }

  @override
  void dispose() {
    super.dispose();

    fabAnimationController.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          return FunctionHelper.handleFabVisibilityOnScroll(
            notification,
            fabAnimationController,
          );
        },
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: [
              SizedBox(
                height: 240,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    HeaderContainer(
                      height: 170,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Jawab Masalah',
                                  style: textTheme.headlineMedium!.copyWith(
                                    color: accentTextColor,
                                  ),
                                ),
                              ),
                              CustomIconButton(
                                iconName: 'notification-solid.svg',
                                color: scaffoldBackgroundColor,
                                size: 28,
                                tooltip: 'Notifikasi',
                                onPressed: () {
                                  navigatorKey.currentState!.pushNamed(
                                    notificationRoute,
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Jawab pertanyaan-pertanyaan khusus dari siswa.',
                            style: textTheme.bodySmall!.copyWith(
                              color: scaffoldBackgroundColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 20,
                      right: 20,
                      bottom: 0,
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 24,
                            ),
                            decoration: BoxDecoration(
                              color: scaffoldBackgroundColor,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(.1),
                                  offset: const Offset(2, 2),
                                  blurRadius: 4,
                                  spreadRadius: -1,
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        teacher.name,
                                        style: textTheme.titleLarge!.copyWith(
                                          color: primaryColor,
                                          fontSize: 18,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Pakar Hukum Tata Negara',
                                        style: textTheme.bodySmall!.copyWith(
                                          color: secondaryTextColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                CircleProfileAvatar(
                                  image: teacher.profilePict,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 16,
                            ),
                            decoration: BoxDecoration(
                              color: secondaryColor,
                              borderRadius: const BorderRadius.vertical(
                                bottom: Radius.circular(10),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(.1),
                                  offset: const Offset(2, 2),
                                  blurRadius: 4,
                                  spreadRadius: -1,
                                )
                              ],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Total Pertanyaan',
                                    style: textTheme.bodyMedium!.copyWith(
                                      color: primaryColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '40',
                                  style: textTheme.titleSmall!.copyWith(
                                    color: primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    color: scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.1),
                        offset: const Offset(2, 2),
                        blurRadius: 4,
                        spreadRadius: -1,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Informasi Keseluruhan Pertanyaan',
                        style: textTheme.titleMedium!.copyWith(
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Expanded(
                            child: Text('Belum Dijawab'),
                          ),
                          Text(
                            '6',
                            style: textTheme.titleSmall,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Expanded(
                            child: Text('Telah Dijawab'),
                          ),
                          Text(
                            '10',
                            style: textTheme.titleSmall,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Expanded(
                            child: Text('Diselesaikan'),
                          ),
                          Text(
                            '24',
                            style: textTheme.titleSmall,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      FilledButton(
                        onPressed: () => navigatorKey.currentState!.pushNamed(
                          teacherQuestionHistoryRoute,
                        ),
                        style: FilledButton.styleFrom(
                          foregroundColor: primaryColor,
                          backgroundColor: secondaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Lihat Riwayat Pertanyaan'),
                      ).fullWidth(),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Diskusi Umum',
                        style: textTheme.titleLarge!.copyWith(
                          color: primaryColor,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => navigatorKey.currentState!.pushNamed(
                        publicDiscussionRoute,
                        arguments: 2,
                      ),
                      child: Text(
                        'Lihat Selengkapnya >',
                        style: textTheme.bodySmall!.copyWith(
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 135,
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 4),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return DiscussionCard(
                      question: dummyQuestions[index],
                      role: 'teacher',
                      width: 300,
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(width: 8);
                  },
                  itemCount: dummyQuestions.length,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Perlu Dijawab',
                        style: textTheme.titleLarge!.copyWith(
                          color: primaryColor,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => navigatorKey.currentState!.pushNamed(
                        teacherQuestionListRoute,
                      ),
                      child: Text(
                        'Lihat Selengkapnya >',
                        style: textTheme.bodySmall!.copyWith(
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ...List<Padding>.generate(
                dummyQuestions.length,
                (index) => Padding(
                  padding: EdgeInsets.fromLTRB(
                    20,
                    0,
                    20,
                    index == dummyQuestions.length - 1 ? 24 : 8,
                  ),
                  child: DiscussionCard(
                    question: dummyQuestions[index],
                    role: 'teacher',
                    isDetail: true,
                    withProfile: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: AnimatedFloatingActionButton(
        fabAnimationController: fabAnimationController,
        scrollController: scrollController,
      ),
    );
  }
}
