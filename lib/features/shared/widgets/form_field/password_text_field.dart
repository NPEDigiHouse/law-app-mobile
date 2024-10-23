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

class PasswordTextField extends StatefulWidget {
  final String name;
  final String label;
  final String? hintText;
  final TextInputType textInputType;
  final TextInputAction textInputAction;
  final TextCapitalization textCapitalization;
  final bool hasPrefixIcon;
  final String? prefixIconName;
  final List<String? Function(String?)>? validators;
  final ValueChanged<String?>? onChanged;
  final bool isSmall;

  const PasswordTextField({
    super.key,
    required this.name,
    required this.label,
    this.hintText,
    this.textInputType = TextInputType.visiblePassword,
    this.textInputAction = TextInputAction.next,
    this.textCapitalization = TextCapitalization.none,
    this.hasPrefixIcon = true,
    this.prefixIconName,
    this.validators,
    this.onChanged,
    this.isSmall = false,
  });

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  late final ValueNotifier<bool> isFocus;
  late final ValueNotifier<bool> isVisible;

  @override
  void initState() {
    super.initState();

    isFocus = ValueNotifier(false);
    isVisible = ValueNotifier(false);
  }

  @override
  void dispose() {
    super.dispose();

    isFocus.dispose();
    isVisible.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: widget.isSmall ? textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w700) : textTheme.titleSmall,
        ),
        const SizedBox(height: 6),
        if (widget.hasPrefixIcon)
          Focus(
            onFocusChange: (value) => isFocus.value = value,
            child: buildPasswordTextField(),
          )
        else
          buildPasswordTextField()
      ],
    );
  }

  ValueListenableBuilder<bool> buildPasswordTextField() {
    return ValueListenableBuilder(
      valueListenable: isVisible,
      builder: (context, isVisible, child) {
        return FormBuilderTextField(
          name: widget.name,
          obscureText: !isVisible,
          keyboardType: widget.textInputType,
          textInputAction: widget.textInputAction,
          textCapitalization: widget.textCapitalization,
          textAlignVertical: TextAlignVertical.center,
          style: widget.isSmall ? textTheme.bodyMedium : null,
          decoration: InputDecoration(
            hintText: widget.hintText,
            prefixIcon: buildPrefixIcon(),
            suffixIcon: buildSuffixIcon(isVisible),
            hintStyle: widget.isSmall ? textTheme.bodyMedium!.copyWith(color: secondaryTextColor) : null,
            contentPadding: widget.isSmall ? const EdgeInsets.fromLTRB(16, 12, 16, 12) : const EdgeInsets.all(16),
          ),
          validator: widget.validators != null ? FormBuilderValidators.compose(widget.validators!) : null,
          onChanged: widget.onChanged,
        );
      },
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

  IconButton buildSuffixIcon(bool isVisible) {
    return IconButton(
      icon: isVisible
          ? SvgAsset(
              assetPath: AssetPath.getIcon('eye-solid.svg'),
              width: widget.isSmall ? 16 : null,
            )
          : SvgAsset(
              assetPath: AssetPath.getIcon('eye-hide-solid.svg'),
              width: widget.isSmall ? 16 : null,
            ),
      onPressed: () => this.isVisible.value = !isVisible,
    );
  }
}
