import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/features/common/widgets/svg_asset.dart';

class CustomTextField extends StatefulWidget {
  final String name;
  final String label;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final String? hintText;
  final bool hasPrefixIcon;
  final String? prefixIconName;
  final bool hasSuffixIcon;
  final String? suffixIconName;
  final List<String? Function(String?)>? validators;
  final VoidCallback? onTap;

  const CustomTextField({
    super.key,
    required this.name,
    required this.label,
    this.textInputType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.hintText,
    this.hasPrefixIcon = true,
    this.prefixIconName,
    this.hasSuffixIcon = true,
    this.suffixIconName,
    this.validators,
    this.onTap,
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
          style: textTheme.titleSmall,
        ),
        const SizedBox(height: 6),
        if (widget.hasPrefixIcon)
          Focus(
            onFocusChange: (value) => isFocus.value = value,
            child: _buildCustomTextField(),
          )
        else
          _buildCustomTextField()
      ],
    );
  }

  FormBuilderTextField _buildCustomTextField() {
    return FormBuilderTextField(
      name: widget.name,
      keyboardType: widget.textInputType,
      textInputAction: widget.textInputAction,
      textCapitalization: widget.textCapitalization,
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        hintText: widget.hintText,
        contentPadding: const EdgeInsets.all(16),
        prefixIcon: _buildPrefixIcon(),
        suffixIcon: _buildSuffixIcon(),
      ),
      validator: widget.validators != null
          ? FormBuilderValidators.compose(widget.validators!)
          : null,
      onTap: widget.onTap,
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

  Padding? _buildSuffixIcon() {
    if (widget.hasSuffixIcon) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 16, 0),
        child: SvgAsset(
          assetPath: AssetPath.getIcon(widget.suffixIconName!),
          color: primaryTextColor,
        ),
      );
    }
    return null;
  }
}
