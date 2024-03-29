// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:law_app/core/enums/banner_type.dart';
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/routes/route_names.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/admin/presentation/course/pages/admin_course_article_form_page.dart';
import 'package:law_app/features/shared/providers/course_providers/article_detail_provider.dart';
import 'package:law_app/features/shared/providers/manual_providers/material_provider.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/loading_indicator.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class AdminCourseArticlePage extends ConsumerWidget {
  final int id;

  const AdminCourseArticlePage({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final articles = ref.watch(articlesProvider);
    final ids = articles.map((e) => e.id!).toList();
    final indexId = ids.indexOf(id);

    final article = ref.watch(ArticleDetailProvider(id: id));

    ref.listen(ArticleDetailProvider(id: id), (_, state) {
      state.whenOrNull(
        error: (error, _) {
          if ('$error' == kNoInternetConnection) {
            context.showNetworkErrorModalBottomSheet(
              onPressedPrimaryButton: () {
                navigatorKey.currentState!.pop();
                ref.invalidate(articleDetailProvider);
              },
            );
          } else {
            context.showBanner(message: '$error', type: BannerType.error);
          }
        },
      );
    });

    return article.when(
      loading: () => const LoadingIndicator(withScaffold: true),
      error: (_, __) => const Scaffold(),
      data: (article) {
        if (article == null) return const Scaffold();

        return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(96),
            child: HeaderContainer(
              title: 'Detail Artikel',
              withBackButton: true,
              withTrailingButton: true,
              trailingButtonIconName: 'pencil-solid.svg',
              trailingButtonTooltip: 'Edit',
              onPressedTrailingButton: () {
                navigatorKey.currentState!.pushNamed(
                  adminCourseArticleFormRoute,
                  arguments: AdminCourseArticleFormPageArgs(
                    title: 'Edit Artikel',
                    article: article,
                  ),
                );
              },
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              vertical: 24,
              horizontal: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgAsset(
                  assetPath: AssetPath.getIcon('read-outlined.svg'),
                  color: primaryColor,
                  width: 50,
                ),
                const SizedBox(height: 8),
                Text(
                  '${article.title}',
                  style: textTheme.headlineSmall!.copyWith(
                    color: primaryColor,
                    height: 0,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    SvgAsset(
                      assetPath: AssetPath.getIcon('clock-solid.svg'),
                      color: secondaryTextColor,
                      width: 18,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        '${article.duration} menit',
                        style: textTheme.bodyMedium!.copyWith(
                          color: secondaryTextColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                MarkdownBody(
                  data: article.material!,
                  selectable: true,
                  onTapLink: (text, href, title) async {
                    if (href != null) {
                      final url = Uri.parse(href);

                      if (await canLaunchUrl(url)) await launchUrl(url);
                    }
                  },
                ),
              ],
            ),
          ),
          bottomNavigationBar: ids.length > 1
              ? Container(
                  color: scaffoldBackgroundColor,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Divider(
                        color: Theme.of(context).dividerColor,
                        height: 1,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (indexId != 0)
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: secondaryColor,
                                      ),
                                      child: IconButton(
                                        onPressed: () {
                                          navigate(context, ids[indexId - 1]);
                                        },
                                        icon: SvgAsset(
                                          assetPath: AssetPath.getIcon(
                                            'caret-line-left.svg',
                                          ),
                                          color: primaryColor,
                                          width: 18,
                                        ),
                                        tooltip: 'Sebelumnya',
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${articles[indexId - 1].title}',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: textTheme.labelSmall,
                                    ),
                                  ],
                                ),
                              )
                            else
                              const Expanded(
                                child: SizedBox(),
                              ),
                            const SizedBox(width: 10),
                            if (indexId != ids.length - 1)
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: secondaryColor,
                                      ),
                                      child: IconButton(
                                        onPressed: () {
                                          navigate(context, ids[indexId + 1]);
                                        },
                                        icon: SvgAsset(
                                          assetPath: AssetPath.getIcon(
                                            'caret-line-right.svg',
                                          ),
                                          color: primaryColor,
                                          width: 18,
                                        ),
                                        tooltip: 'Selanjutnya',
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${articles[indexId + 1].title}',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.end,
                                      style: textTheme.labelSmall,
                                    ),
                                  ],
                                ),
                              )
                            else
                              const Expanded(
                                child: SizedBox(),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : null,
        );
      },
    );
  }

  void navigate(BuildContext context, int id) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => AdminCourseArticlePage(id: id),
        transitionDuration: Duration.zero,
      ),
    );
  }
}
