import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../authentication/bloc/authentication_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const ProfileScreen());
  }

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _lastNameController;
  late TextEditingController _firstNameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthenticationBloc>().state.user;
    _lastNameController = TextEditingController(text: user?.lastName ?? '');
    _firstNameController = TextEditingController(text: user?.firstName ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _passwordController = TextEditingController(text: '********');
  }

  @override
  void dispose() {
    _lastNameController.dispose();
    _firstNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: AppBar(
        // ... (partie de votre code d'AppBar)
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileTextField("Nom", _lastNameController),
              _buildProfileTextField("Prénom", _firstNameController),
              _buildProfileTextField("Email", _emailController),
              _buildProfileTextField("Mot de passe", _passwordController),
              const SizedBox(height: 32),
              Center(
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Logique de modification
                       //  widget.profileBloc.add(UpdateProfileEvent(updatedUser));
                      },
                      child: Text("Modifier"),
                    ),
                    const SizedBox(width: 16), // Espacement entre les boutons
                    ElevatedButton(
                      onPressed: () {
                        // Logique de suppression du compte ici
                      },
                      child: Text("Supprimer"),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Logique de déconnexion
                  context.read<AuthenticationBloc>().add(AuthenticationLogoutRequested());
                  //Navigator.of(context).pop(); // Retournez à l'écran de connexion
                },
                child: const Text("Déconnexion"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label:",
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
        TextField(
          controller: controller,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
          decoration: InputDecoration(
            hintText: 'Entrez votre $label',
            contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

