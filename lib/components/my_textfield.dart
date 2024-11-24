import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  final Widget labelText;
  final TextEditingController? controller;
  final bool isPassword;
  final bool isAmount;
  final TextInputType? textInputType;
  final Function(String text)? onChanged;
  final maxLength;
  final String? Function(String?) validator;

  // FormFieldValidator<String>? validator;
  // final String? Function(String?)?
  MyTextField({
    super.key,
    required this.labelText,
    required this.controller,
    this.textInputType,
    this.isPassword = false,
    this.isAmount = false,
    this.onChanged,
    this.maxLength,
    required this.validator,
  });

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool _obscureText = true;
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: TextFormField(
        controller: widget.controller,
        maxLength: widget.maxLength,
        obscureText: widget.isPassword ? _obscureText : false,
        onChanged: widget.onChanged,
        validator: widget.validator!,
        keyboardType: widget.isAmount
            ? TextInputType.number
            : widget.textInputType ?? TextInputType.text,
        decoration: InputDecoration(
          label: widget.labelText,
          suffixIcon: widget.isPassword
              ? GestureDetector(
                  onTap: _toggle,
                  child: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility))
              : const SizedBox.shrink(),
          labelStyle: TextStyle(color: Colors.grey.shade700),
          enabled: true,
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(8)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade700),
              borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
