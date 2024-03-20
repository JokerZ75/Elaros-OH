import "package:flutter/material.dart";

class MyTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final bool readOnly;

  const MyTextFormField({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.keyboardType,
    required this.obscureText,
    required this.validator,
    this.readOnly = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      cursorColor: Colors.black,
      cursorWidth: 1.0,
      cursorHeight: 20.0,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          color: Colors.grey.shade600,
        ),
        fillColor:  readOnly ?  Colors.grey.shade400: const Color(0xFFECEBEC),
        filled: true,
        contentPadding: const EdgeInsetsDirectional.fromSTEB(10, 3, 10, 10),
        border: UnderlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFE6BA5F), width: 4),
          borderRadius: BorderRadius.circular(10),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 4),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 4),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
