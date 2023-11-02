import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const PasswordField({
    Key? key,
    required this.controller,
    required this.onChanged,
  }) : super(key: key);

  @override
  PasswordFieldState createState() => PasswordFieldState();
}

class PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: _obscureText,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        labelText: "Mot de passe",
        hintText: "••••••••••••",
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
          ),
          splashColor: Colors.transparent,
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
        fillColor: const Color(0xffe8e8e8),
      ),
    );
  }
}
