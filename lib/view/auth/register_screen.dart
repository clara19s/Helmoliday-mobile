import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:helmoliday/theme.dart';
import 'package:helmoliday/view_model/auth/register_view_model.dart';
import 'package:provider/provider.dart';

import '../../view_model/auth/login_view_model.dart';
import '../../widget/common/password_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _RegisterScreenState();
  }
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (BuildContext context) => RegisterViewModel(context),
        child: Scaffold(
          backgroundColor: const Color(0xfff8f1f1),
          body: Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
              child: SingleChildScrollView(
                child : Form(
                  key: _formKey,

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const Text(
                      "Inscription",
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                        fontSize: 24,
                        color: HelmolidayTheme.primaryColor,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 30, 0, 10),
                      child: TextFormField(
                        controller: _firstNameController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.badge),
                          labelText: "Prénom",
                          hintText: "John",
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Le prénom ne peut pas être vide';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: TextFormField(
                        controller: _lastNameController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.badge),
                          labelText: "Nom",
                          hintText: "Doe",
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Le nom ne peut pas être vide';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.mail),
                          labelText: "Adresse e-mail",
                          hintText: "john@doe.com",
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'L\'adresse e-mail ne peut pas être vide';
                          } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$').hasMatch(value)) {
                            return 'L\'adresse e-mail n\'est pas valide';
                          }
                          return null;
                        },
                      ),
                    ),
                    PasswordField(
                      controller: _passwordController,
                      onChanged: (value) {},
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 30, 0, 16),
                      child: Consumer<RegisterViewModel>(
                        builder: (context, model, child) {
                          return model.isLoading
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                          :Column(
                            children: [
                              if (model.errorMessage != null) ...[
                                const SizedBox(height: 10),
                                Text(
                                  model.errorMessage!,
                                  style: const TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                              ElevatedButton(
                                  onPressed: () async {
    if (_formKey.currentState!.validate()) {
      model.register(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );
    }
                                  },
                                  child: const Text(
                                    "Se connecter",
                                  ),
                                ),

                            ],
                          );
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Vous avez déjà un compte ?",
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              fontSize: 14,
                              color: Color(0xff000000),
                            ),
                          ),
                          MaterialButton(
                            onPressed: () {
                              context.go("/login");
                            },
                            textColor: HelmolidayTheme.primaryColor,
                            child: const Text("Se connecter"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        ));
  }
}
