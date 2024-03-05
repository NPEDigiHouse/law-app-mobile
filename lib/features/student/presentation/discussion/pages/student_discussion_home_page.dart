// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:law_app/core/enums/banner_type.dart';
import 'package:law_app/core/extensions/button_extension.dart';
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/helpers/function_helper.dart';
import 'package:law_app/core/routes/route_names.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/shared/providers/discussion_providers/create_discussion_provider.dart';
import 'package:law_app/features/shared/providers/discussion_providers/student_discussions_provider.dart';
import 'package:law_app/features/shared/widgets/animated_fab.dart';
import 'package:law_app/features/shared/widgets/custom_icon_button.dart';
import 'package:law_app/features/shared/widgets/empty_content_text.dart';
import 'package:law_app/features/shared/widgets/feature/discussion_card.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/loading_indicator.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';
import 'package:law_app/features/student/presentation/discussion/widgets/create_question_dialog.dart';

class StudentDiscussionHomePage extends ConsumerStatefulWidget {
  const StudentDiscussionHomePage({super.key});

  @override
  ConsumerState<StudentDiscussionHomePage> createState() =>
      _StudentDiscussionHomePageState();
}

class _StudentDiscussionHomePageState
    extends ConsumerState<StudentDiscussionHomePage>
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
    final discussions = ref.watch(studentDiscussionsProvider);

    ref.listen(studentDiscussionsProvider, (_, state) {
      state.when(
        error: (error, _) {
          if ('$error' == kNoInternetConnection) {
            context.showNetworkErrorModalBottomSheet(
              onPressedPrimaryButton: () {
                navigatorKey.currentState!.pop();
                ref.invalidate(studentDiscussionsProvider);
              },
            );
          } else {
            context.showBanner(message: '$error', type: BannerType.error);
          }
        },
        loading: () {},
        data: (_) {},
      );
    });

    ref.listen(createDiscussionProvider, (_, state) {
      state.when(
        error: (error, _) {
          navigatorKey.currentState!.pop();
          navigatorKey.currentState!.pop();

          if ('$error' == kNoInternetConnection) {
            context.showNetworkErrorModalBottomSheet();
          } else {
            context.showBanner(message: '$error', type: BannerType.error);
          }
        },
        loading: () => context.showLoadingDialog(),
        data: (data) {
          if (data != null) {
            navigatorKey.currentState!.pop();
            navigatorKey.currentState!.pop();

            ref.invalidate(studentDiscussionsProvider);

            context.showBanner(
              message: 'Berhasil membuat pertanyaan!',
              type: BannerType.success,
            );
          }
        },
      );
    });

    return discussions.when(
      loading: () => const LoadingIndicator(withScaffold: true),
      error: (_, __) => const Scaffold(),
      data: (discussions) {
        final userCredential = discussions.userCredential;
        final userDiscussions = discussions.userDiscussions;
        final publicDiscussions = discussions.publicDiscussions;

        if (userCredential == null ||
            userDiscussions == null ||
            publicDiscussions == null) {
          return const Scaffold();
        }

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
                    height: 310,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        HeaderContainer(
                          height: 230,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Tanya Masalahmu',
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
                                'Buat pertanyaan dan dapatkan jawaban dari para ahli secara langsung!',
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
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        'Kesempatan Pertanyaan Mingguan',
                                        style: textTheme.titleMedium!.copyWith(
                                          color: primaryColor,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Tooltip(
                                      message:
                                          'Kesempatan bertanya akan di-reset setiap minggu.',
                                      textStyle: textTheme.bodySmall!.copyWith(
                                        color: scaffoldBackgroundColor,
                                      ),
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 40,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8,
                                        horizontal: 16,
                                      ),
                                      verticalOffset: 12,
                                      triggerMode: TooltipTriggerMode.tap,
                                      showDuration: const Duration(seconds: 4),
                                      child: SvgAsset(
                                        assetPath: AssetPath.getIcon(
                                          'info-circle-line.svg',
                                        ),
                                        color: primaryColor,
                                        width: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Expanded(
                                      child: Text('Pertanyaan Umum'),
                                    ),
                                    Text(
                                      '${userCredential.totalWeeklyGeneralQuestionsQuota}/3',
                                      style: textTheme.titleSmall,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Expanded(
                                      child: Text('Pertanyaan Khusus'),
                                    ),
                                    Text(
                                      '${userCredential.totalWeeklySpecificQuestionsQuota}/1',
                                      style: textTheme.titleSmall,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                FilledButton.icon(
                                  onPressed: () async {
                                    final categories = await FunctionHelper
                                        .getDiscussionCategories(context, ref);

                                    if (categories.isNotEmpty) {
                                      if (!context.mounted) return;

                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (context) {
                                          return CreateQuestionDialog(
                                            categories: categories,
                                          );
                                        },
                                      );
                                    } else {
                                      if (!context.mounted) return;

                                      context.showCustomAlertDialog(
                                        title: 'Anda belum dapat bertanya!',
                                        message:
                                            'Saat ini kamu belum bisa bertanya, Silahkan mencoba lain kali.',
                                        onPressedPrimaryButton: () {
                                          navigatorKey.currentState!.pop();
                                        },
                                      );
                                    }
                                  },
                                  icon: const Icon(Icons.add_rounded),
                                  label: const Text('Buat Pertanyaan'),
                                  style: FilledButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ).fullWidth(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Pertanyaan Saya',
                            style: textTheme.titleLarge!.copyWith(
                              color: primaryColor,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => navigatorKey.currentState!.pushNamed(
                            studentDiscussionListRoute,
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
                  if (userDiscussions.isEmpty)
                    const EmptyContentText(
                      'Pertanyaan kamu belum ada. Mulailah bertanya dengan menekan tombol "Buat Pertanyaan".',
                    )
                  else
                    SizedBox(
                      height: 175,
                      child: ListView.separated(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 4),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return DiscussionCard(
                            discussion: userDiscussions[index],
                            isDetail: true,
                            width: 300,
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(width: 8);
                        },
                        itemCount: userDiscussions.length,
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
                      'Belum terdapat diskusi umum. Pertanyaan umum dari siswa lain akan muncul di sini.',
                    )
                  else
                    ...List<Padding>.generate(
                      publicDiscussions.length,
                      (index) => Padding(
                        padding: EdgeInsets.fromLTRB(
                          20,
                          0,
                          20,
                          index == publicDiscussions.length - 1 ? 24 : 8,
                        ),
                        child: DiscussionCard(
                          discussion: publicDiscussions[index],
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
      },
    );
  }
}
