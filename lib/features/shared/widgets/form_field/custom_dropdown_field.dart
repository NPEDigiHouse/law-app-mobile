// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_form_builder/flutter_form_builder.dart';

// Project imports:
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';

class CustomDropdownField extends StatefulWidget {
  final String name;
  final String label;
  final List<String> items;
  final List<String> values;
  final String? initialValue;
  final ValueChanged<String?>? onChanged;
  final bool isSmall;

  const CustomDropdownField({
    super.key,
    required this.name,
    required this.label,
    required this.items,
    required this.values,
    this.initialValue,
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
          child: FormBuilderDropdown<String>(
            name: widget.name,
            onChanged: widget.onChanged,
            initialValue: widget.initialValue,
            items: List<DropdownMenuItem<String>>.generate(
              widget.items.length,
              (index) => DropdownMenuItem(
                value: widget.values[index],
                child: Text(widget.items[index]),
              ),
            ),
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
