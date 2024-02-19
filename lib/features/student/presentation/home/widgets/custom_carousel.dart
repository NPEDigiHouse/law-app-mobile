import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';

class CustomCarousel extends StatefulWidget {
  final List<Map<String, dynamic>> items;

  const CustomCarousel({super.key, required this.items});

  @override
  State<CustomCarousel> createState() => _CustomCarouselState();
}

class _CustomCarouselState extends State<CustomCarousel> {
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
    return Column(
      children: [
        CarouselSlider(
          items: List<Container>.generate(
            widget.items.length,
            (index) => Container(
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    AssetPath.getImage(widget.items[index]["img"] as String),
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(18, 244, 133, 125),
                      Color.fromARGB(115, 31, 6, 4),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      widget.items[index]["text"] as String,
                      style: textTheme.titleLarge!.copyWith(
                        color: scaffoldBackgroundColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          options: CarouselOptions(
            onPageChanged: (index, reason) => carouselIndex.value = index,
            viewportFraction: 1,
            height: 160,
            autoPlay: true,
            autoPlayInterval: const Duration(milliseconds: 7000),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List<ValueListenableBuilder>.generate(
            widget.items.length,
            (index) => ValueListenableBuilder(
              valueListenable: carouselIndex,
              builder: (context, carouselIndex, child) {
                return Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: carouselIndex == index
                        ? primaryColor
                        : secondaryTextColor,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
