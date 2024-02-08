import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:law_app/core/extensions/app_extension.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';

class CustomDropdownField extends StatefulWidget {
  final String name;
  final String label;
  final List<String> items;
  final List<String>? values;
  final ValueChanged<String?>? onChanged;
  final bool isSmall;

  const CustomDropdownField({
    super.key,
    required this.name,
    required this.label,
    required this.items,
    this.values,
    this.onChanged,
    this.isSmall = false,
  });

  @override
  State<CustomDropdownField> createState() => _CustomDropdownFieldState();
}

class _CustomDropdownFieldState extends State<CustomDropdownField> {
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
        Focus(
          onFocusChange: (value) => isFocus.value = value,
          child: FormBuilderDropdown(
            name: widget.name,
            initialValue: widget.values != null
                ? widget.values!.first
                : widget.items.first.toCamelCase(),
            items: List<DropdownMenuItem<String>>.generate(
              widget.items.length,
              (index) => DropdownMenuItem(
                value: widget.values != null
                    ? widget.values![index]
                    : widget.items[index].toCamelCase(),
                child: Text(widget.items[index]),
              ),
            ),
            onChanged: widget.onChanged,
            icon: ValueListenableBuilder(
              valueListenable: isFocus,
              builder: (context, isFocus, child) {
                return Icon(
                  Icons.expand_more_rounded,
                  color: isFocus ? primaryColor : secondaryTextColor,
                  size: 22,
                );
              },
            ),
            elevation: 1,
            isDense: true,
            dropdownColor: scaffoldBackgroundColor,
            style: widget.isSmall ? textTheme.bodyMedium : textTheme.bodyLarge,
            decoration: InputDecoration(
              contentPadding: widget.isSmall
                  ? const EdgeInsets.fromLTRB(16, 12, 12, 12)
                  : const EdgeInsets.fromLTRB(16, 16, 12, 16),
            ),
          ),
        ),
      ],
    );
  }
}
