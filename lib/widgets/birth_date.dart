import 'package:flutter/material.dart';
import 'package:visa_nova_flutter/visa_nova_flutter.dart';

class BirthDateField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String? errorText;
  final bool hasError;
  final ValueChanged<String> onChanged;

  const BirthDateField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.errorText,
    required this.hasError,
    required this.onChanged,
  });

  @override
  State<BirthDateField> createState() => _BirthDateFieldState();
}

class _BirthDateFieldState extends State<BirthDateField> {
  String _dateFieldText = '';

  Future<void> _showCalendar() async {
    DateTime date = DateTime(1997, 4, 2);
    // Parse the entered date if it's valid
    try {
      if (widget.controller.text.isNotEmpty) {
        _dateFieldText = widget.controller.text;
        if (_dateFieldText.length == 10) {
          // If the date is valid, update the selected date
          try {
            final parts = _dateFieldText.split('-');
            if (parts.length == 3) {
              final month = int.parse(parts[0]);
              final day = int.parse(parts[1]);
              final year = int.parse(parts[2]);
              date = DateTime(year, month, day);
            }
          } catch (e) {
            // If parsing fails, keep default date
          }
        }
      }
    } catch (e) {
      // Do nothing as the default date is already set
    }

    final picked = await showModalBottomSheet<DateTime>(
      context: context,
      builder:
          (ctx) => SizedBox(
            height: 300,
            child: CalendarDatePicker(
              initialDate: date,
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
              onDateChanged: (date) {
                Navigator.of(ctx).pop(date);
              },
            ),
          ),
    );
    if (picked != null) {
      setState(() {
        date = picked;
        final formatted =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
        widget.controller.text = formatted;
      });
      widget.onChanged(widget.controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return VInput(
      myLocalController: widget.controller,
      inputFocusNode: widget.focusNode,
      topLabelText: 'Birth Date',
      hasError: widget.hasError,
      errorText: widget.errorText ?? '',
      tapped: _showCalendar,
      hintText: 'MM-DD-YYYY',
      maxLengthEnforced: true,
      textLength: 10,
      keyboardType: TextInputType.datetime,
      changed: (value) {
        // Remove any non-numeric characters
        final numericValue = value?.replaceAll(RegExp(r'\D'), '');
        // If the input is empty, return
        if (numericValue == null || numericValue.isEmpty) {
          widget.controller.text = '';
          widget.onChanged('');
          return;
        }
        // Format as date (MM-DD-YYYY) if possible
        final buffer = StringBuffer();
        for (int i = 0; i < numericValue.length; i++) {
          if (i == 2 || i == 4) {
            buffer.write('-');
          }
          buffer.write(numericValue[i]);
        }

        final formattedDate = buffer.toString();
        widget.controller.text = formattedDate;
        widget.onChanged(formattedDate);
      },
    );
  }
}
