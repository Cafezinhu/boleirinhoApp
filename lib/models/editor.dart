import 'package:flutter/material.dart';

class Editor extends StatelessWidget {
  final String label, hint;
  final Icon icon;
  final TextEditingController controller;
  final TextInputType keyboardType;

  Editor({this.label, this.hint, this.icon, this.controller, this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        icon: icon,
        labelText: label,
        hintText: hint
      ),
      style: TextStyle(
        fontSize: 24.0
      ),
      keyboardType: keyboardType,
    );
  }
}