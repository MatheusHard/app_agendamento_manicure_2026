import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDatePickerField extends StatefulWidget {
  final String label;
  final Function(DateTime) onDateTimeSelected;
  final DateTime? initialDateTime;

  const CustomDatePickerField({
    Key? key,
    required this.label,
    required this.onDateTimeSelected,
    this.initialDateTime,
  }) : super(key: key);

  @override
  State<CustomDatePickerField> createState() => _CustomDatePickerFieldState();
}

class _CustomDatePickerFieldState extends State<CustomDatePickerField> {
  late TextEditingController _dateController;
  late TextEditingController _horaController;
  late TextEditingController _minutoController;

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController(
      text: widget.initialDateTime != null
          ? DateFormat('dd/MM/yyyy').format(widget.initialDateTime!)
          : '',
    );
    _horaController = TextEditingController(
      text: widget.initialDateTime != null
          ? widget.initialDateTime!.hour.toString().padLeft(2, '0')
          : '',
    );
    _minutoController = TextEditingController(
      text: widget.initialDateTime != null
          ? widget.initialDateTime!.minute.toString().padLeft(2, '0')
          : '',
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.initialDateTime ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      locale: const Locale('pt', 'BR'),
    );

    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
      _notifyChange();
    }
  }

  void _notifyChange() {
    if (_dateController.text.isEmpty) return;

    try {
      final date = DateFormat('dd/MM/yyyy').parse(_dateController.text);
      final hora = int.tryParse(_horaController.text) ?? 0;
      final minuto = int.tryParse(_minutoController.text) ?? 0;

      final dateTime = DateTime(
        date.year,
        date.month,
        date.day,
        hora,
        minuto,
      );

      widget.onDateTimeSelected(dateTime);
    } catch (_) {
      // ignora se não conseguir parsear
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: TextField(
            controller: _dateController,
            readOnly: true,
            decoration: InputDecoration(
              hintText: widget.label,
              prefixIcon: const Icon(Icons.calendar_today, color: Colors.black),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
            onTap: () => _selectDate(context),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            controller: _horaController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Hora',
              border: OutlineInputBorder(),
            ),
            onChanged: (_) => _notifyChange(),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            controller: _minutoController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Min',
              border: OutlineInputBorder(),
            ),
            onChanged: (_) => _notifyChange(),
          ),
        ),
      ],
    );
  }
}