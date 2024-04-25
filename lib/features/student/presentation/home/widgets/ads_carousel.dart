// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:law_app/core/routes/route_names.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/admin/presentation/ad/providers/ad_provider.dart';
import 'package:law_app/features/shared/widgets/custom_network_image.dart';

class AdsCarousel extends ConsumerStatefulWidget {
  const AdsCarousel({super.key});

  @override
  ConsumerState<AdsCarousel> createState() => _AdsCarouselState();
}

class _AdsCarouselState extends ConsumerState<AdsCarousel> {
  late final ValueNotifier<int> carouselIndex;

  @override
  void initState() {
    super.initState();

    carouselIndex = ValueNotifier(0);
  }

  @override
  void dispose() {
    super.dispose();

    carouselIndex.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ads = ref.watch(adProvider);

    return ads.when(
      loading: () => const SizedBox(),
      error: (_, __) => const SizedBox(),
      data: (ads) {
        if (ads == null || ads.isEmpty) return const SizedBox();

        return Padding(
          padding: const EdgeInsets.only(top: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CarouselSlider(
                items: List<GestureDetector>.generate(
                  ads.length,
                  (index) => GestureDetector(
                    onTap: () => navigatorKey.currentState!.pushNamed(
                      adDetailRoute,
                      arguments: ads[index].id,
                    ),
                    child: Stack(
                      children: [
                        DecoratedBox(
                          position: DecorationPosition.foreground,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFFA2355A).withOpacity(.1),
                                const Color(0xFF730034).withOpacity(.6),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                          child: CustomNetworkImage(
                            fit: BoxFit.fitWidth,
                            imageUrl: ads[index].imageName!,
                            placeHolderSize: 48,
                            aspectRatio: 18 / 9,
                          ),
                        ),
                        Positioned(
                          left: 20,
                          right: 20,
                          bottom: 16,
                          child: Text(
                            '${ads[index].title}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.titleLarge!.copyWith(
                              color: backgroundColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                options: CarouselOptions(
                  aspectRatio: 18 / 9,
                  viewportFraction: 1,
                  autoPlay: ads.length > 1,
                  enableInfiniteScroll: ads.length > 1,
                  autoPlayInterval: const Duration(seconds: 10),
                  onPageChanged: (index, reason) => carouselIndex.value = index,
                ),
              ),
              if (ads.length > 1) ...[
                const SizedBox(height: 8),
                ValueListenableBuilder(
                  valueListenable: carouselIndex,
                  builder: (context, carouselIndex, child) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List<Container>.generate(
                        ads.length,
                        (index) => Container(
                          width: 6,
                          height: 6,
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: carouselIndex == index ? primaryColor : secondaryTextColor,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
