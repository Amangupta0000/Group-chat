import 'package:flutter/material.dart';



class AddMemebrsPopUp extends StatefulWidget {
  const AddMemebrsPopUp({super.key, required this.items});
  final List items;

  @override
  State<AddMemebrsPopUp> createState() => _AddMemebrsPopUpState();
}

class _AddMemebrsPopUpState extends State<AddMemebrsPopUp> {
  final List _selectedItems = [];
  void _itemChange(String itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedItems.add(itemValue);
      } else {
        _selectedItems.remove(itemValue);
      }
    });
  }

  void cancel() {
    Navigator.pop(context);
  }

  void Add() {
    Navigator.pop(context, _selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Members'),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.items
              .map((item) => CheckboxListTile(
                  value: _selectedItems.contains(item),
                  title: Text(item),
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (isChecked) => _itemChange(item, isChecked!)))
              .toList(),
        ),
      ),
      actions: [
        TextButton(onPressed: cancel, child: Text('Cancel')),
        ElevatedButton(onPressed: Add, child: Text('Add')),
      ],
    );
  }
}
