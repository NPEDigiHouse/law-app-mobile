import 'package:flutter/material.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class CustomNavigationBar extends StatelessWidget {
  final int roleId;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomNavigationBar({
    super.key,
    required this.roleId,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            color: Colors.black.withOpacity(.05),
            offset: const Offset(0, -2),
            spreadRadius: 1,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          onTap: onTap,
          backgroundColor: scaffoldBackgroundColor,
          selectedLabelStyle: textTheme.bodySmall!.copyWith(
            fontWeight: FontWeight.w600,
            color: primaryColor,
          ),
          unselectedLabelStyle: textTheme.labelSmall!.copyWith(
            fontWeight: FontWeight.w300,
            color: secondaryTextColor,
          ),
          items: [
            BottomNavigationBarItem(
              icon: SvgAsset(
                assetPath: AssetPath.getIcon('home-unselected.svg'),
              ),
              activeIcon: SvgAsset(
                assetPath: AssetPath.getIcon('home-selected.svg'),
                width: 24,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: SvgAsset(
                assetPath: AssetPath.getIcon('question-unselected.svg'),
              ),
              activeIcon: SvgAsset(
                assetPath: AssetPath.getIcon('question-selected.svg'),
                width: 24,
              ),
              label: 'Discussion',
            ),
            if (roleId == 1)
              BottomNavigationBarItem(
                icon: SvgAsset(
                  assetPath: AssetPath.getIcon('course-unselected.svg'),
                ),
                activeIcon: SvgAsset(
                  assetPath: AssetPath.getIcon('course-selected.svg'),
                  width: 24,
                ),
                label: 'Course',
              ),
            BottomNavigationBarItem(
              icon: SvgAsset(
                assetPath: AssetPath.getIcon('book-unselected.svg'),
              ),
              activeIcon: SvgAsset(
                assetPath: AssetPath.getIcon('book-selected.svg'),
                width: 24,
              ),
              label: 'Library',
            ),
            BottomNavigationBarItem(
              icon: SvgAsset(
                assetPath: AssetPath.getIcon('glossary-unselected.svg'),
              ),
              activeIcon: SvgAsset(
                assetPath: AssetPath.getIcon('glossary-selected.svg'),
                width: 24,
              ),
              label: 'Glossary',
            ),
          ],
        ),
      ),
    );
  }
}
