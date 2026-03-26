import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hintText;
  final IconData icon;
  final String? Function(String?)? validator;
  final bool enabled;
  final TextInputType keyboardType;
  final bool obscureText;
  final List<TextInputFormatter>? inputFormatters; // novo
  final void Function(String)? onChanged; // novo

  const CustomField({
    Key? key,
    required this.controller,
    required this.focusNode,
    required this.hintText,
    required this.icon,
    this.validator,
    this.enabled = true,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.inputFormatters, // novo
    this.onChanged, // novo
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled,
      keyboardType: keyboardType,
      obscureText: obscureText,
      controller: controller,
      focusNode: focusNode,
      inputFormatters: inputFormatters, // aplica se não for null
      onChanged: onChanged, // aplica se não for null
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon, color: Colors.black),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
      style: const TextStyle(color: Colors.black),
      validator: validator ??
              (value) {
            if (value == null || value.isEmpty) {
              return 'Campo obrigatório';
            }
            return null;
          },
    );
  }
}