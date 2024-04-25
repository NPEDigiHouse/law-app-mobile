// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

// Project imports:
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class CustomTextField extends StatefulWidget {
  final String name;
  final String label;
  final String? initialValue;
  final String? hintText;
  final int maxLines;
  final TextInputType textInputType;
  final TextInputAction textInputAction;
  final TextCapitalization textCapitalization;
  final bool hasPrefixIcon;
  final String? prefixIconName;
  final bool hasSuffixIcon;
  final String? suffixIconName;
  final List<String? Function(String?)>? validators;
  final VoidCallback? onTap;
  final bool isSmall;

  const CustomTextField({
    super.key,
    required this.name,
    required this.label,
    this.initialValue,
    this.hintText,
    this.maxLines = 1,
    this.textInputType = TextInputType.name,
    this.textInputAction = TextInputAction.next,
    this.textCapitalization = TextCapitalization.sentences,
    this.hasPrefixIcon = true,
    this.prefixIconName,
    this.hasSuffixIcon = true,
    this.suffixIconName,
    this.validators,
    this.onTap,
    this.isSmall = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late final ValueNotifier<bool> isFocus;

  @override
  void initState() {
    super.initState();

    isFocus = ValueNotifier(false);
  }

  @override
  void dispose() {
    super.dispose();

    isFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: widget.isSmall
              ? textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w700)
              : textTheme.titleSmall,
        ),
        const SizedBox(height: 6),
        if (widget.hasPrefixIcon)
          Focus(
            onFocusChange: (value) => isFocus.value = value,
            child: buildCustomTextField(),
          )
        else
          buildCustomTextField()
      ],
    );
  }

  FormBuilderTextField buildCustomTextField() {
    return FormBuilderTextField(
      name: widget.name,
      initialValue: widget.initialValue,
      maxLines: widget.maxLines,
      keyboardType: widget.textInputType,
      textInputAction: widget.textInputAction,
      textCapitalization: widget.textCapitalization,
      textAlignVertical: TextAlignVertical.center,
      style: widget.isSmall ? textTheme.bodyMedium : null,
      decoration: InputDecoration(
        hintText: widget.hintText,
        prefixIcon: buildPrefixIcon(),
        suffixIcon: buildSuffixIcon(),
        hintStyle:
            widget.isSmall ? textTheme.bodyMedium!.copyWith(color: secondaryTextColor) : null,
        contentPadding:
            widget.isSmall ? const EdgeInsets.fromLTRB(16, 12, 16, 12) : const EdgeInsets.all(16),
      ),
      validator:
          widget.validators != null ? FormBuilderValidators.compose(widget.validators!) : null,
      onTap: widget.onTap,
    );
  }

  Padding? buildPrefixIcon() {
    if (widget.hasPrefixIcon) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 10, 0),
        child: ValueListenableBuilder(
          valueListenable: isFocus,
          builder: (context, isFocus, child) {
            return SvgAsset(
              assetPath: AssetPath.getIcon(widget.prefixIconName!),
              color: isFocus ? primaryColor : secondaryTextColor,
              width: widget.isSmall ? 16 : null,
            );
          },
        ),
      );
    }

    return null;
  }

  Padding? buildSuffixIcon() {
    if (widget.hasSuffixIcon) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 16, 0),
        child: SvgAsset(
          assetPath: AssetPath.getIcon(widget.suffixIconName!),
          width: widget.isSmall ? 16 : null,
        ),
      );
    }

    return null;
  }
}
