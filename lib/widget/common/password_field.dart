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
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureText,
      onChanged: widget.onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Le mot de passe ne peut pas être vide';
        } else if (value.length < 8) {
          return 'Le mot de passe doit faire au moins 8 caractères';
        } else if (!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$').hasMatch(value)) {
          return 'Le mot de passe doit contenir au moins une majuscule, \n une minuscule, un chiffre et un caractère spécial';
        }
        return null;
      },
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
