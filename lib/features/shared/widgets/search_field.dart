import 'package:flutter/material.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class SearchField extends StatefulWidget {
  final String text;
  final bool readOnly;
  final bool autoFocus;
  final bool canRequestFocus;
  final String? hintText;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final TextInputAction? textInputAction;

  const SearchField({
    super.key,
    required this.text,
    this.readOnly = false,
    this.autoFocus = false,
    this.canRequestFocus = true,
    this.hintText,
    this.onTap,
    this.onChanged,
    this.textInputAction,
  });

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();

    controller = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();

    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: TextField(
        readOnly: widget.readOnly,
        autofocus: widget.autoFocus,
        canRequestFocus: widget.canRequestFocus,
        controller: controller,
        textAlignVertical: TextAlignVertical.center,
        textInputAction: widget.textInputAction,
        decoration: InputDecoration(
          hintText: widget.hintText,
          filled: true,
          fillColor: scaffoldBackgroundColor,
          contentPadding: EdgeInsets.zero,
          prefixIcon: buildPrefixIcon(),
          suffixIcon: buildSuffixIcon(),
        ),
        onChanged: widget.onChanged,
        onTap: widget.onTap,
      ),
    );
  }

  Padding buildPrefixIcon() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 12,
        right: 10,
      ),
      child: SvgAsset(
        assetPath: AssetPath.getIcon('search-line.svg'),
        color: widget.autoFocus ? primaryColor : secondaryTextColor,
      ),
    );
  }

  Widget buildSuffixIcon() {
    if (widget.text.isEmpty) return const SizedBox();

    return IconButton(
      onPressed: resetQuery,
      icon: SvgAsset(
        assetPath: AssetPath.getIcon('close-line.svg'),
      ),
    );
  }

  void resetQuery() {
    controller.clear();

    if (widget.onChanged != null) {
      widget.onChanged!('');
    }
  }
}
