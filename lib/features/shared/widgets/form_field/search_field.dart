// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
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
  final ValueChanged<bool>? onFocusChange;
  final TextInputAction textInputAction;
  final bool delayOnChanged;
  final Duration delay;

  const SearchField({
    super.key,
    required this.text,
    this.readOnly = false,
    this.autoFocus = false,
    this.canRequestFocus = true,
    this.hintText,
    this.onTap,
    this.onChanged,
    this.onFocusChange,
    this.textInputAction = TextInputAction.search,
    this.delayOnChanged = true,
    this.delay = const Duration(milliseconds: 750),
  });

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  late final TextEditingController controller;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    controller = TextEditingController(text: widget.text);
  }

  @override
  void dispose() {
    super.dispose();

    controller.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Focus(
        onFocusChange: widget.onFocusChange,
        child: TextField(
          controller: controller,
          readOnly: widget.readOnly,
          autofocus: widget.autoFocus,
          canRequestFocus: widget.canRequestFocus,
          textAlignVertical: TextAlignVertical.center,
          textInputAction: widget.textInputAction,
          decoration: InputDecoration(
            hintText: widget.hintText,
            isDense: true,
            filled: true,
            fillColor: scaffoldBackgroundColor,
            contentPadding: EdgeInsets.zero,
            prefixIcon: buildPrefixIcon(),
            suffixIcon: buildSuffixIcon(),
          ),
          onTap: widget.onTap,
          onChanged: widget.delayOnChanged
              ? (text) => debounce(() => widget.onChanged!(text))
              : widget.onChanged,
        ),
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

  void debounce(VoidCallback callback) {
    timer?.cancel();
    timer = Timer(widget.delay, callback);
  }

  void resetQuery() {
    controller.clear();
    widget.onChanged!('');
  }
}
