import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TextFormFieldDatePicker extends StatefulWidget {
  final ValueChanged<DateTime> onSaved;
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final DateFormat dateFormat;
  final FocusNode focusNode;
  final String labelText;

  TextFormFieldDatePicker({
    Key key,
    this.labelText,
    this.focusNode,
    this.dateFormat,
    @required this.lastDate,
    @required this.firstDate,
    @required this.initialDate,
    @required this.onSaved,
  })  : assert(initialDate != null),
        assert(firstDate != null),
        assert(lastDate != null),
        assert(!initialDate.isBefore(firstDate),
            'initialDate must be on or after firstDate'),
        assert(!initialDate.isAfter(lastDate),
            'initialDate must be on or before lastDate'),
        assert(!firstDate.isAfter(lastDate),
            'lastDate must be on or after firstDate'),
        assert(onSaved != null, 'onSaved must not be null'),
        super(key: key);

  @override
  _TextFieldFormDatePicker createState() => _TextFieldFormDatePicker();
}

class _TextFieldFormDatePicker extends State<TextFormFieldDatePicker> {
  TextEditingController _controllerDate;
  DateFormat _dateFormat;
  DateTime _selectedDate;

  @override
  void initState() {
    super.initState();

    if (widget.dateFormat != null) {
      _dateFormat = widget.dateFormat;
    } else {
      _dateFormat = DateFormat.yMMMd();
    }

    _selectedDate = widget.initialDate;

    _controllerDate = TextEditingController();
    _controllerDate.text = _dateFormat.format(_selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: TextFormField(
            focusNode: widget.focusNode,
            controller: _controllerDate,
            keyboardType: TextInputType.datetime,
            decoration: InputDecoration(
              labelText: widget.labelText,
            ),
            validator: (value) {
              try {
                final date = widget.dateFormat.parseLoose(value);
                return null;
              } catch (err) {
                return 'Invalid date!';
              }
            },
            onSaved: (value) {
              final date = widget.dateFormat.parseLoose(value);
              widget.onSaved(date);
            },
          ),
        ),
        IconButton(
          icon: Icon(Icons.calendar_today),
          onPressed: () async {
            DateTime date;
            try {
              date = widget.dateFormat.parseLoose(_controllerDate.text);
              _selectedDate = date;
            } catch (err) {}
            date = await _selectDate(context);
            if (date != null) {
              setState(() {
                _selectedDate = date;
                _controllerDate.text = widget.dateFormat.format(_selectedDate);
              });
            }
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controllerDate.dispose();
    super.dispose();
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      _selectedDate = pickedDate;
      _controllerDate.text = _dateFormat.format(_selectedDate);
    }

    if (widget.focusNode != null) {
      widget.focusNode.nextFocus();
    }
  }
}