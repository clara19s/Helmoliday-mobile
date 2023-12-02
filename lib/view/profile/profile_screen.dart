import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:helmoliday/widget/common/avatar_picker.dart';
import 'package:provider/provider.dart';

import '../../view_model/profile/profile_view_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _preFillTextFields(ProfileViewModel model) {
    _emailController.text = model.email;
    _firstNameController.text = model.firstName;
    _lastNameController.text = model.lastName;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (nContext) =>
          ProfileViewModel(nContext),
      child: Consumer<ProfileViewModel>(
        builder: (context, model, child) {
          _preFillTextFields(model);
          return Scaffold(
            appBar: AppBar(
              title: const Text("Mon profil"),
              actions: [
                IconButton(
                  onPressed: () async {
                    model.logOut();
                  },
                  icon: const Icon(Icons.logout),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Form(
                key: _formKey,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: model.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                        children: [
                          const AvatarPicker(),
                          const SizedBox(height: 16),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez entrer votre email';
                              }
                              return null;
                            },
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: "Email",
                              hintText: "john@doe.com",
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez entrer votre prénom';
                              }
                              return null;
                            },
                            controller: _firstNameController,
                            decoration: const InputDecoration(
                              labelText: "Prénom",
                              hintText: "John",
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez entrer votre nom';
                              }
                              return null;
                            },
                            controller: _lastNameController,
                            decoration: const InputDecoration(
                              labelText: "Nom",
                              hintText: "Doe",
                            ),
                          ),
                          const SizedBox(height: 16),
                          model.isLoading
                              ? const CircularProgressIndicator()
                          :Column(
                            children: [
                              if (model.errorMessage != null)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 20.0),
                                  child: Text(
                                    model.errorMessage!,
                                    style: const TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                               ElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      SystemChannels.textInput
                                          .invokeMethod('TextInput.hide');
                                      model.updateProfile(
                                          firstName: _firstNameController.text,
                                          lastName: _lastNameController.text,
                                          email: _emailController.text);
                                    }
                                  },
                                  child: const Text(
                                    "Enregistrer",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                                ),
                        ],
                      ),
                        ],
                      ),
              ),
            ),
          ),
          );

        },
      ),
    );
  }
}
