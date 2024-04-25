// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:law_app/core/enums/banner_type.dart';
import 'package:law_app/core/extensions/button_extension.dart';
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/extensions/string_extension.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/helpers/function_helper.dart';
import 'package:law_app/core/routes/route_names.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/shared/widgets/animated_fab.dart';
import 'package:law_app/features/shared/widgets/circle_profile_avatar.dart';
import 'package:law_app/features/shared/widgets/empty_content_text.dart';
import 'package:law_app/features/shared/widgets/feature/discussion_card.dart';
import 'package:law_app/features/shared/widgets/loading_indicator.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';
import 'package:law_app/features/teacher/presentation/discussion/providers/teacher_discussions_provider.dart';

class TeacherDiscussionHomePage extends ConsumerStatefulWidget {
  const TeacherDiscussionHomePage({super.key});

  @override
  ConsumerState<TeacherDiscussionHomePage> createState() => _TeacherDiscussionHomePageState();
}

class _TeacherDiscussionHomePageState extends ConsumerState<TeacherDiscussionHomePage>
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
    final discussions = ref.watch(teacherDiscussionsProvider);

    ref.listen(teacherDiscussionsProvider, (_, state) {
      state.whenOrNull(
        error: (error, _) {
          if ('$error' == kNoInternetConnection) {
            context.showNetworkErrorModalBottomSheet(
              onPressedPrimaryButton: () {
                navigatorKey.currentState!.pop();
                ref.invalidate(teacherDiscussionsProvider);
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
      body: discussions.whenOrNull(
        loading: () => const LoadingIndicator(),
        data: (data) {
          final userCredential = data.userCredential;
          final userDiscussions = data.userDiscussions;
          final publicDiscussions = data.publicDiscussions;
          final specificDiscussions = data.specificDiscussions;

          if (userCredential == null ||
              userDiscussions == null ||
              publicDiscussions == null ||
              specificDiscussions == null) {
            return null;
          }

          return NotificationListener<UserScrollNotification>(
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
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        height: 190,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(20),
                          ),
                          gradient: LinearGradient(
                            colors: GradientColors.redPastel,
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      ),
                      Positioned(
                        top: -20,
                        right: 20,
                        child: SvgAsset(
                          assetPath: AssetPath.getVector('app_logo_white.svg'),
                          color: tertiaryColor.withOpacity(.5),
                          width: 160,
                        ),
                      ),
                      SafeArea(
                        bottom: false,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Jawab Masalah',
                                style: textTheme.headlineMedium!.copyWith(
                                  color: accentTextColor,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Jawab pertanyaan-pertanyaan khusus dari siswa!',
                                style: textTheme.bodySmall!.copyWith(
                                  color: scaffoldBackgroundColor,
                                ),
                              ),
                              const SizedBox(height: 16),
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
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            userCredential.name!,
                                            style: textTheme.titleLarge!.copyWith(
                                              color: primaryColor,
                                              fontSize: 18,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            userCredential.role!.toCapitalize(),
                                            style: textTheme.bodySmall!.copyWith(
                                              color: secondaryTextColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    CircleProfileAvatar(
                                      imageUrl: userCredential.profilePicture,
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
                                      '${userDiscussions.length + specificDiscussions.length}',
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
                      ),
                    ],
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
                                '${specificDiscussions.length}',
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
                                '${userDiscussions.where((e) => e.status == 'onDiscussion').length}',
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
                                '${userDiscussions.where((e) => e.status == 'solved').length}',
                                style: textTheme.titleSmall,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          FilledButton(
                            onPressed: () {
                              navigatorKey.currentState!.pushNamed(
                                teacherDiscussionHistoryRoute,
                              );
                            },
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
                  if (publicDiscussions.isEmpty)
                    const EmptyContentText(
                      'Belum terdapat diskusi umum. Pertanyaan umum dari seluruh siswa akan muncul di sini.',
                    )
                  else
                    SizedBox(
                      height: 206,
                      child: ListView.separated(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 4),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return DiscussionCard(
                            discussion: publicDiscussions[index],
                            isDetail: true,
                            withProfile: true,
                            width: 309,
                            height: 206,
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(width: 8);
                        },
                        itemCount: publicDiscussions.length,
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
                            teacherDiscussionListRoute,
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
                  if (specificDiscussions.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(bottom: 24),
                      child: EmptyContentText(
                        'Pertanyaan khusus yang dialihkan dan belum dijawab akan muncul di sini.',
                      ),
                    )
                  else
                    ...List<Padding>.generate(
                      specificDiscussions.length,
                      (index) => Padding(
                        padding: EdgeInsets.fromLTRB(
                          20,
                          0,
                          20,
                          index == specificDiscussions.length - 1 ? 24 : 8,
                        ),
                        child: DiscussionCard(
                          discussion: specificDiscussions[index],
                          isDetail: true,
                          withProfile: true,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: AnimatedFloatingActionButton(
        fabAnimationController: fabAnimationController,
        scrollController: scrollController,
      ),
    );
  }
}
