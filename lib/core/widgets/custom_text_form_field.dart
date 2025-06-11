import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField(
      {super.key,
      this.label,
      this.prefixIcon,
      this.suffixIcon,
      this.isSecure = false,
      this.onPress,
        this.controller,
      this.keyboardType = TextInputType.text,
      this.hint,
      this.maxLines = 1, this.validation});

  final String? label;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool isSecure;
  final VoidCallback? onPress;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final String? hint;
  final int maxLines;
  final String? Function (String?)? validation;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator:validation ,
      controller:controller,
      maxLines: maxLines,
      style: Theme.of(context).textTheme.displayMedium,
      keyboardType: keyboardType,
      obscureText: isSecure,
      decoration: InputDecoration(
          alignLabelWithHint: true,
          hintText: hint,
          labelText: label,
          prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
          suffixIcon: suffixIcon != null
              ? IconButton(onPressed: onPress, icon: Icon(suffixIcon))
              : null),
    );
  }
}
