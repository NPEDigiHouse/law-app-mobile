// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:law_app/core/enums/banner_type.dart';
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/glossary/presentation/providers/edit_glossary_provider.dart';
import 'package:law_app/features/glossary/presentation/providers/get_glossary_detail_provider.dart';
import 'package:law_app/features/glossary/presentation/providers/glossaries_provider.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/loading_indicator.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class GlossaryDetailPage extends ConsumerWidget {
  final int id;
  final bool isAdmin;

  const GlossaryDetailPage({
    super.key,
    required this.id,
    this.isAdmin = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var glossary = ref.watch(GetGlossaryDetailProvider(id: id));

    ref.listen(GetGlossaryDetailProvider(id: id), (previous, next) {
      if (previous != next) {
        glossary = next;
      }

      next.when(
        error: (error, _) {
          if ('$error' == kNoInternetConnection) {
            context.showNetworkErrorModalBottomSheet(
              onPressedPrimaryButton: () {
                navigatorKey.currentState!.pop();
                ref.invalidate(GetGlossaryDetailProvider(id: id));
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

    if (isAdmin) {
      ref.listen(editGlossaryProvider, (_, state) {
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
              ref.invalidate(GetGlossaryDetailProvider(id: id));
              ref.invalidate(glossariesProvider);

              navigatorKey.currentState!.pop();
              navigatorKey.currentState!.pop();
            }
          },
        );
      });
    }

    return glossary.when(
      loading: () => const LoadingIndicator(withScaffold: true),
      error: (error, __) => const Scaffold(),
      data: (glossary) {
        if (glossary == null) return const Scaffold();

        return Scaffold(
          appBar: const PreferredSize(
            preferredSize: Size.fromHeight(96),
            child: HeaderContainer(
              title: 'Detail Kata',
              withBackButton: true,
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
                Text(
                  '${glossary.title}',
                  style: textTheme.headlineSmall!.copyWith(
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text('${glossary.description}'),
              ],
            ),
          ),
          floatingActionButton: isAdmin
              ? Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: const LinearGradient(
                      colors: GradientColors.redPastel,
                    ),
                  ),
                  child: IconButton(
                    onPressed: () => context.showSingleFormTextAreaDialog(
                      title: 'Edit Kosa Kata',
                      textFieldInitialValue: '${glossary.title}',
                      textFieldName: 'title',
                      textFieldLabel: 'Kata/Istilah',
                      textFieldHint: 'Masukkan kata/istilah',
                      textAreaInitialValue: '${glossary.description}',
                      textAreaName: 'description',
                      textAreaLabel: 'Pengertian/Deskripsi',
                      textAreaHint: 'Masukkan pengertian/deskripsi',
                      primaryButtonText: 'Edit',
                      onSubmitted: (value) {
                        final newGlossary = glossary.copyWith(
                          title: value['title'],
                          description: value['description'],
                        );

                        ref
                            .read(editGlossaryProvider.notifier)
                            .editGlossary(glossary: newGlossary);
                      },
                    ),
                    icon: SvgAsset(
                      assetPath: AssetPath.getIcon('pencil-solid.svg'),
                      color: scaffoldBackgroundColor,
                      width: 24,
                    ),
                    tooltip: 'Edit',
                  ),
                )
              : null,
        );
      },
    );
  }
}

class GlossaryDetailPageArgs {
  final int id;
  final bool isAdmin;

  const GlossaryDetailPageArgs({
    required this.id,
    this.isAdmin = false,
  });
}
