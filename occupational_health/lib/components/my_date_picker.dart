import 'package:flutter/material.dart';

class MyDatePicker extends StatelessWidget {
  final String label;
  final Function(DateTime) onDateSelected;
  final TextEditingController controller;

  const MyDatePicker(
      {Key? key,
      required this.label,
      required this.onDateSelected,
      required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a date';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: const Icon(Icons.calendar_today),
        labelStyle: TextStyle(
          color: Colors.grey.shade600,
        ),
        fillColor: const Color(0xFFECEBEC),
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
      onTap: () async {
        DateTime? date = await showDatePicker(
          context: context,
          helpText: "Select Your Date of Birth",
          fieldLabelText: "Date of Birth",
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
          builder: (context, child) {
            return Theme(
              data: ThemeData.light().copyWith(
                colorScheme: const ColorScheme.light(
                  primary:  Color(0xFFE6BA5F),
                  onPrimary: Colors.black,
                  onSurface: Colors.black,
                ),
                dialogBackgroundColor: Colors.white,
              ),
              child: child!,
            );
          },
        );

        if (date != null) {
          onDateSelected(date);
        }
      },
    );
  }
}
