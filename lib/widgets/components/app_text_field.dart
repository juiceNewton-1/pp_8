import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final String placeholder;
  final void Function(String)? onChanged;
  final TextEditingController controller;
  final TextAlignVertical? textAlignVertical;
  final EdgeInsets? padding;
  final bool enabled;
  final Color? backgroundColor;
  final Widget? prefix;
  const AppTextField({
    super.key,
    required this.placeholder,
    required this.controller,
    this.textAlignVertical,
    this.padding,
    this.onChanged,
    this.enabled = true,
    this.backgroundColor,
    this.prefix,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoTextField(
      
      enabled: enabled,
      padding: padding ?? EdgeInsets.symmetric(horizontal: 16),
      textAlignVertical: textAlignVertical,
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      onChanged: onChanged,
      prefix: prefix,
      placeholder: placeholder,
      controller: controller,
    );
  }
}
