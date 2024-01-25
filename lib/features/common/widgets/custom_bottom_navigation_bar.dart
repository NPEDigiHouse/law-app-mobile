import 'package:flutter/material.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/features/common/widgets/svg_asset.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final List<Widget> pages;
  final int selectedIndex;
  final void Function(int) onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.pages,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onTap,
      items: [
        BottomNavigationBarItem(
          icon: SvgAsset(
            assetPath: AssetPath.getIcon('glossary-unselected.svg'),
          ),
          activeIcon: SvgAsset(
            assetPath: AssetPath.getIcon('glossary-selected.svg'),
          ),
          label: 'Glossary',
        ),
        BottomNavigationBarItem(
          icon: SvgAsset(
            assetPath: AssetPath.getIcon('book-unselected.svg'),
          ),
          activeIcon: SvgAsset(
            assetPath: AssetPath.getIcon('book-selected.svg'),
          ),
          label: 'Library',
        ),
        BottomNavigationBarItem(
          icon: SvgAsset(
            assetPath: AssetPath.getIcon('home-unselected.svg'),
          ),
          activeIcon: SvgAsset(
            assetPath: AssetPath.getIcon('home-selected.svg'),
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: SvgAsset(
            assetPath: AssetPath.getIcon('question-unselected.svg'),
          ),
          activeIcon: SvgAsset(
            assetPath: AssetPath.getIcon('question-selected.svg'),
          ),
          label: 'Discussion',
        ),
        BottomNavigationBarItem(
          icon: SvgAsset(
            assetPath: AssetPath.getIcon('course-unselected.svg'),
          ),
          activeIcon: SvgAsset(
            assetPath: AssetPath.getIcon('course-selected.svg'),
          ),
          label: 'Course',
        ),
      ],
    );
  }
}
