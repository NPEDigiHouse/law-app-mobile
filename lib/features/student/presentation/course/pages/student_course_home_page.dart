// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:law_app/core/enums/banner_type.dart';
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/helpers/function_helper.dart';
import 'package:law_app/core/routes/route_names.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/shared/providers/course_providers/course_provider.dart';
import 'package:law_app/features/shared/widgets/animated_fab.dart';
import 'package:law_app/features/shared/widgets/custom_icon_button.dart';
import 'package:law_app/features/shared/widgets/custom_information.dart';
import 'package:law_app/features/shared/widgets/feature/course_card.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/loading_indicator.dart';
import 'package:law_app/features/student/presentation/course/widgets/course_list_bottom_sheet.dart';

class StudentCourseHomePage extends ConsumerStatefulWidget {
  const StudentCourseHomePage({super.key});

  @override
  ConsumerState<StudentCourseHomePage> createState() =>
      _StudentCourseHomePageState();
}

class _StudentCourseHomePageState extends ConsumerState<StudentCourseHomePage>
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
    final courses = ref.watch(CourseProvider());

    ref.listen(CourseProvider(), (_, state) {
      state.whenOrNull(
        error: (error, _) {
          if ('$error' == kNoInternetConnection) {
            context.showNetworkErrorModalBottomSheet(
              onPressedPrimaryButton: () {
                navigatorKey.currentState!.pop();
                ref.invalidate(courseProvider);
              },
            );
          } else {
            context.showBanner(message: '$error', type: BannerType.error);
          }
        },
      );
    });

    return Scaffold(
      backgroundColor: backgroundColor,
      body: NestedScrollView(
        physics: const NeverScrollableScrollPhysics(),
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: true,
              toolbarHeight: 116,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              flexibleSpace: HeaderContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Course',
                            style: textTheme.headlineMedium!.copyWith(
                              color: accentTextColor,
                            ),
                          ),
                        ),
                        CustomIconButton(
                          iconName: 'search-fill.svg',
                          color: scaffoldBackgroundColor,
                          size: 28,
                          tooltip: 'Cari',
                          onPressed: () => navigatorKey.currentState!.pushNamed(
                            studentCourseSearchRoute,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Ikuti berbagai course yang ada untuk meningkatkan pengetahuanmu tentang hukum!',
                      style: textTheme.bodySmall!.copyWith(
                        color: scaffoldBackgroundColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: NotificationListener<UserScrollNotification>(
          onNotification: (notification) {
            return FunctionHelper.handleFabVisibilityOnScroll(
              notification,
              fabAnimationController,
            );
          },
          child: CustomScrollView(
            controller: scrollController,
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 40,
                        ),
                        decoration: BoxDecoration(
                          color: scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(16),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: secondaryColor,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: CustomIconButton(
                                      iconName: 'book-bold.svg',
                                      color: primaryColor,
                                      size: 40,
                                      splashRadius: 8,
                                      onPressed: () {
                                        showCourseListModalBottomSheet(
                                          title: 'Course Aktif',
                                          status: 'active',
                                          emptyTitle:
                                              'Course aktif masih kosong',
                                          emptySubtitle:
                                              'Tidak ada course yang sedang diikuti.',
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Course Aktif',
                                    style: textTheme.bodyMedium!.copyWith(
                                      color: primaryColor,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Flexible(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: secondaryColor,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: CustomIconButton(
                                      iconName: 'history-line.svg',
                                      color: primaryColor,
                                      size: 40,
                                      splashRadius: 8,
                                      onPressed: () {
                                        showCourseListModalBottomSheet(
                                          title: 'Riwayat Course',
                                          status: 'complete',
                                          emptyTitle:
                                              'Riwayat course masih kosong',
                                          emptySubtitle:
                                              'Kamu belum pernah menyelesaikan course.',
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Riwayat Course',
                                    style: textTheme.bodyMedium!.copyWith(
                                      color: primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Daftar Course',
                        style: textTheme.titleLarge,
                      ),
                    ],
                  ),
                ),
              ),
              courses.when(
                loading: () => const SliverFillRemaining(
                  child: LoadingIndicator(),
                ),
                error: (_, __) => const SliverFillRemaining(),
                data: (data) {
                  final courses = data.courses;
                  final hasMore = data.hasMore;

                  if (courses == null || hasMore == null) {
                    return const SliverFillRemaining();
                  }

                  if (courses.isEmpty) {
                    return const SliverFillRemaining(
                      child: CustomInformation(
                        illustrationName: 'house-searching-cuate.svg',
                        title: 'Daftar course masih kosong',
                      ),
                    );
                  }

                  return SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (index >= courses.length) {
                            return buildFetchMoreButton(ref, courses.length);
                          }

                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: index == courses.length - 1 ? 0 : 8,
                            ),
                            child: CourseCard(course: courses[index]),
                          );
                        },
                        childCount:
                            hasMore ? courses.length + 1 : courses.length,
                      ),
                    ),
                  );
                },
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

  TextButton buildFetchMoreButton(WidgetRef ref, int currentLength) {
    return TextButton(
      onPressed: () {
        ref
            .read(CourseProvider().notifier)
            .fetchMoreCourses(offset: currentLength);
      },
      child: const Text('Lihat lebih banyak'),
    );
  }

  Future<void> showCourseListModalBottomSheet({
    required String title,
    required String status,
    required String emptyTitle,
    required String emptySubtitle,
  }) async {
    return showModalBottomSheet(
      context: context,
      enableDrag: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CourseListBottomSheet(
        title: title,
        status: status,
        emptyTitle: emptyTitle,
        emptySubtitle: emptySubtitle,
      ),
    );
  }
}
