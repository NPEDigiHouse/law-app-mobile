import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:law_app/core/extensions/app_extension.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/core/utils/routes.dart';
import 'package:law_app/dummies_data.dart';
import 'package:law_app/features/shared/widgets/custom_icon_button.dart';
import 'package:law_app/features/shared/widgets/discussion_card.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class StudentDiscussionHomePage extends StatefulWidget {
  const StudentDiscussionHomePage({super.key});

  @override
  State<StudentDiscussionHomePage> createState() =>
      _StudentDiscussionHomePageState();
}

class _StudentDiscussionHomePageState extends State<StudentDiscussionHomePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController hideFabAnimation;
  late final ScrollController scrollController;

  @override
  void initState() {
    super.initState();

    hideFabAnimation = AnimationController(
      vsync: this,
      duration: kThemeAnimationDuration,
    );

    scrollController = ScrollController()
      ..addListener(() {
        if (scrollController.offset == 0) {
          hideFabAnimation.reverse();
        }
      });
  }

  @override
  void dispose() {
    super.dispose();

    hideFabAnimation.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      extendBodyBehindAppBar: true,
      body: NotificationListener(
        onNotification: handleScrollNotification,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
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
                                      'Kesempatan bertanya akan di-reset setiap minggunya.',
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
                                  showDuration: const Duration(seconds: 5),
                                  child: SvgAsset(
                                    assetPath: AssetPath.getIcon(
                                      'info-circle-line.svg',
                                    ),
                                    width: 14,
                                    color: primaryColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Flexible(
                                  child: Text('Pertanyaan Umum :'),
                                ),
                                Flexible(
                                  child: Text(
                                    '0/3',
                                    style: textTheme.titleSmall,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Flexible(
                                  child: Text('Pertanyaan Khusus :'),
                                ),
                                Flexible(
                                  child: Text(
                                    '0/1',
                                    style: textTheme.titleSmall,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            FilledButton.icon(
                              onPressed: () {},
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
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        'Pertanyaan Saya',
                        style: textTheme.titleLarge!.copyWith(
                          color: primaryColor,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => navigatorKey.currentState!.pushNamed(
                        studentQuestionListRoute,
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
                height: 125,
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 4),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return DiscussionCard(
                      width: 300,
                      question: questions[index],
                      onTap: () {},
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(width: 8);
                  },
                  itemCount: questions.length,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        'Diskusi Umum',
                        style: textTheme.titleLarge!.copyWith(
                          color: primaryColor,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
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
                questions.length,
                (index) => Padding(
                  padding: EdgeInsets.fromLTRB(
                    20,
                    0,
                    20,
                    questions[index] == questions.last ? 24 : 8,
                  ),
                  child: DiscussionCard(
                    question: questions[index],
                    isDetail: true,
                    withProfile: true,
                    onTap: () {},
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: ScaleTransition(
        scale: hideFabAnimation,
        alignment: Alignment.bottomCenter,
        child: FloatingActionButton.small(
          onPressed: () => scrollController.jumpTo(0),
          elevation: 2,
          backgroundColor: secondaryColor,
          child: SvgAsset(
            assetPath: AssetPath.getIcon('caret-line-up.svg'),
            width: 20,
            color: primaryColor,
          ),
        ),
      ),
    );
  }

  bool handleScrollNotification(UserScrollNotification notification) {
    if (notification.depth == 0) {
      switch (notification.direction) {
        case ScrollDirection.forward:
          if (notification.metrics.maxScrollExtent !=
              notification.metrics.minScrollExtent) {
            if (notification.metrics.pixels != 0) {
              hideFabAnimation.forward();
            }
          }
          break;

        case ScrollDirection.reverse:
          if (notification.metrics.maxScrollExtent !=
              notification.metrics.minScrollExtent) {
            hideFabAnimation.reverse();
          }
          break;

        case ScrollDirection.idle:
          break;
      }
    }

    return false;
  }
}
