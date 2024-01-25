// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/features/shared/notification/notification_page.dart';

class AdsDetail extends StatelessWidget {
  final Map adsItem;
  const AdsDetail({
    Key? key,
    required this.adsItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(AssetPath.getImage("sample_carousel_image1.jpg")),
          ],
        ),
      ),
    );
  }
}
