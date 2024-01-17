import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/features/common/widgets/svg_asset.dart';

class PasswordTextField extends StatefulWidget {
  final String name;
  final String label;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final String? hintText;
  final bool hasPrefixIcon;
  final String? prefixIconName;
  final List<String? Function(String?)>? validators;
  final VoidCallback? onTap;

  const PasswordTextField({
    super.key,
    required this.name,
    required this.label,
    this.textInputType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.hintText,
    this.hasPrefixIcon = true,
    this.prefixIconName,
    this.validators,
    this.onTap,
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
      children: <Widget>[
        Text(
          widget.label,
          style: textTheme.titleSmall,
        ),
        const SizedBox(height: 6),
        Focus(
          onFocusChange: (value) => isFocus.value = value,
          child: _buildPasswordTextField(),
        )
      ],
    );
  }

  ValueListenableBuilder<bool> _buildPasswordTextField() {
    return ValueListenableBuilder(
      valueListenable: isVisible,
      builder: (context, isVisible, child) {
        return FormBuilderTextField(
          name: widget.name,
          keyboardType: widget.textInputType,
          textInputAction: widget.textInputAction,
          textCapitalization: widget.textCapitalization,
          textAlignVertical: TextAlignVertical.center,
          obscureText: !isVisible,
          decoration: InputDecoration(
            hintText: widget.hintText,
            contentPadding: const EdgeInsets.all(16),
            prefixIcon: _buildPrefixIcon(),
            suffixIcon: _buildSuffixIcon(isVisible),
          ),
          validator: widget.validators != null
              ? FormBuilderValidators.compose(widget.validators!)
              : null,
          onTap: widget.onTap,
        );
      },
    );
  }

  Padding? _buildPrefixIcon() {
    if (widget.hasPrefixIcon) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 10, 0),
        child: ValueListenableBuilder(
          valueListenable: isFocus,
          builder: (context, isFocus, child) {
            return SvgAsset(
              assetPath: AssetPath.getIcon(widget.prefixIconName!),
              color: isFocus ? primaryColor : secondaryTextColor,
            );
          },
        ),
      );
    }

    return null;
  }

  IconButton _buildSuffixIcon(bool isVisible) {
    return IconButton(
      icon: isVisible
          ? SvgAsset(
              assetPath: AssetPath.getIcon('eye-solid.svg'),
              color: primaryTextColor,
            )
          : SvgAsset(
              assetPath: AssetPath.getIcon('eye-hide-solid.svg'),
              color: primaryTextColor,
            ),
      onPressed: () => this.isVisible.value = !isVisible,
    );
  }
}
