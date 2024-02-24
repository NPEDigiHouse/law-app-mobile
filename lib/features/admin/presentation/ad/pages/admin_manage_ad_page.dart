import 'package:flutter/material.dart';
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/routes/route_names.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/ink_well_container.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class AdminManageAdPage extends StatelessWidget {
  const AdminManageAdPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items = [
      {
        "id": "1",
        "title": "Promo Mingguan",
        "image": "sample_carousel_image1.jpg",
        "description":
            "Ut aliquam enim ac lacus sagittis, quis maximus dolor pretium. Pellentesque ac iaculis elit. In luctus nec eros quis pretium. Cras ante ipsum.",
      },
      {
        "id": "2",
        "title": "Promo Bulanan",
        "image": "sample_carousel_image4.jpg",
        "description":
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi lacinia maximus erat vel fermentum. Mauris ut aliquet justo, et consectetur lorem. Nam semper vehicula ex, ac fermentum orci elementum ac.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi lacinia maximus erat vel fermentum. Mauris ut aliquet justo, et consectetur lorem. Nam semper vehicula ex, ac fermentum orci elementum ac.",
      },
      {
        "id": "3",
        "title": "Promo Hari Hukum Sedunia",
        "image": "sample_carousel_image2.jpg",
        "description":
            "Ut aliquam enim ac lacus sagittis, quis maximus dolor pretium. Pellentesque ac iaculis elit. In luctus nec eros quis pretium. Cras ante ipsum.",
      },
      {
        "id": "4",
        "title": "Promo Pemilu",
        "image": "sample_carousel_image3.jpg",
        "description":
            "Ut aliquam enim ac lacus sagittis, quis maximus dolor pretium. Pellentesque ac iaculis elit. In luctus nec eros quis pretium. Cras ante ipsum.",
      },
      {
        "id": "5",
        "title": "Ikuti Jasa Kami",
        "image": "sample_carousel_image4.jpg",
        "description":
            " Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi lacinia maximus erat vel fermentum. Mauris ut aliquet justo, et consectetur lorem. Nam semper vehicula ex, ac fermentum orci elementum ac.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi lacinia maximus erat vel fermentum. Mauris ut aliquet justo, et consectetur lorem. Nam semper vehicula ex, ac fermentum orci elementum ac.",
      },
    ];
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(96),
        child: HeaderContainer(
          title: 'Kategori Ads',
          withBackButton: true,
        ),
      ),
      floatingActionButton: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(colors: GradientColors.redPastel),
        ),
        child: IconButton(
          onPressed: () => context.showCustomSelectorDialog(
            title: "Pilih Jenis Ads",
            items: [
              {
                "text": "Ads Sederhana",
                "onTap": () {
                  navigatorKey.currentState!.pop();
                  navigatorKey.currentState!.pushNamed(adminAddSimpleAdRoute);
                },
              },
              {
                "text": "Ads Detail",
                "onTap": () {
                  navigatorKey.currentState!.pop();
                  // TODO: make add ads detail page
                },
              }
            ],
          ),
          icon: SvgAsset(
            assetPath: AssetPath.getIcon('plus-line.svg'),
            color: secondaryColor,
            width: 32,
          ),
          tooltip: 'Kembali',
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: List.generate(
              items.length,
              (index) => InkWellContainer(
                onTap: () => navigatorKey.currentState!
                    .pushNamed(adDetailRoute, arguments: true),
                margin: const EdgeInsets.only(bottom: 8),
                color: scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.2),
                    offset: const Offset(2, 2),
                    blurRadius: 4,
                  ),
                ],
                radius: 12,
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            clipBehavior: Clip.antiAlias,
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                // TODO: change image
                                image: AssetImage(
                                  AssetPath.getImage(
                                    items[index]["image"],
                                  ),
                                ),
                              ),
                            ),
                            child: Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color.fromARGB(37, 244, 133, 125),
                                    Color.fromARGB(75, 228, 77, 66),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Flexible(
                            child: Text(
                              items[index]["title"],
                              maxLines: 2,
                              style: textTheme.titleMedium!,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: errorColor,
                      ),
                      child: IconButton(
                        onPressed: () => context.showConfirmDialog(
                          title: "Hapus FAQ",
                          message: "Apakah Anda yakin ingin menghapus FAQ ini?",
                        ),
                        icon: SvgAsset(
                          assetPath: AssetPath.getIcon('trash-solid.svg'),
                          color: secondaryColor,
                          width: 32,
                        ),
                        tooltip: 'Hapus',
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
