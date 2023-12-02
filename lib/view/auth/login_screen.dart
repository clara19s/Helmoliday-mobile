import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../view_model/auth/login_view_model.dart';
import '../../widget/common/password_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => LoginViewModel(context),
      child: _LoginScreenBody(
          emailController: _emailController,
          passwordController: _passwordController),

    );
  }
}

class _LoginScreenBody extends StatelessWidget {
   _LoginScreenBody( {
     required TextEditingController emailController,
    required TextEditingController passwordController,
  })  : _emailController = emailController,
        _passwordController = passwordController;

  final TextEditingController _emailController;
  final TextEditingController _passwordController;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff8f1f1),
      body: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
            child:
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                const Text(
                  "Connexion",
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal,
                    fontSize: 24,
                    color: Color(0xff0f70b7),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 30, 0, 10),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'L\'adresse e-mail ne peut pas être vide';
                      } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$').hasMatch(value)) {
                        return 'L\'adresse e-mail n\'est pas valide';
                      }
                      return null;
                    },
                    controller: _emailController,
                    obscureText: false,
                    textAlign: TextAlign.start,
                    maxLines: 1,
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 14,
                      color: Color(0xff000000),
                    ),
                    decoration: InputDecoration(
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(
                            color: Color(0x00ffffff), width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(
                            color: Color(0x00ffffff), width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(
                            color: Color(0x00ffffff), width: 1),
                      ),
                      prefixIcon: const Icon(Icons.mail),
                      labelText: "Adresse e-mail",
                      hintText: "john@doe.com",
                      hintStyle: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 14,
                        color: Color(0xff9f9d9d),
                      ),

                      filled: true,
                      fillColor: const Color(0xffe8e8e8),
                      isDense: false,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 12),
                    ),
                  ),
                ),
                PasswordField(
                  controller: _passwordController,
                  onChanged: (value) {},

                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 16),
                  child: Consumer<LoginViewModel>(
                    builder: (context, model, child) {
                      return model.isLoading
                          ? const Center(
                        child: CircularProgressIndicator(),
                      )
                      : Column(

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
                           MaterialButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            model.logIn(
                              email: _emailController.text,
                              password: _passwordController.text,
                            );
                          }
                        },
                        color: const Color(0xff1070b7),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        padding: const EdgeInsets.all(16),
                        textColor: const Color(0xffffffff),
                        height: 40,
                        minWidth: MediaQuery.of(context).size.width,
                        child: const Text(
                          "Se connecter",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                          ),
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
                        "Pas encore de compte ?",
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
                          context.go("/register");
                        },
                        textColor: const Color(0xff1070b7),
                        child: const Text("S'inscrire"),
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
    );
  }
}
