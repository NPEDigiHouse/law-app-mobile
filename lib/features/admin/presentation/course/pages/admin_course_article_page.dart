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
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/loading_indicator.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class AdminCourseArticlePage extends ConsumerWidget {
  final int id;

  const AdminCourseArticlePage({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              title: 'Detail Materi',
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
                  width: 48,
                ),
                const SizedBox(height: 8),
                Text(
                  '${article.title}',
                  style: textTheme.headlineSmall!.copyWith(
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
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
                const SizedBox(height: 16),
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
        );
      },
    );
  }
}
