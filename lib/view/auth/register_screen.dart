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
                      child: TextField(
                        controller: _firstNameController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.badge),
                          labelText: "Prénom",
                          hintText: "John",
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: TextField(
                        controller: _lastNameController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.badge),
                          labelText: "Nom",
                          hintText: "Doe",
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.mail),
                          labelText: "Adresse e-mail",
                          hintText: "john@doe.com",
                        ),
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
                              : ElevatedButton(
                                  onPressed: () async {
                                    model.register(
                                      firstName: _firstNameController.text,
                                      lastName: _lastNameController.text,
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                    );
                                  },
                                  child: const Text(
                                    "Se connecter",
                                  ),
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
        ));
  }
}
