import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../bloc/register_bloc.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                  content: Text("Erreur lors de l'authentification")),
            );
        }
      },
      child: Align(
        alignment: const Alignment(0, -1 / 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 30, 0, 16),
              child: _FirstNameInput(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
              child: _LastNameInput(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
              child: _EmailInput(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
              child: _PasswordInput(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 30, 0, 16),
              child: _LoginButton(),
            ),
          ],
        ),
      ),
    );
  }
}

class _FirstNameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
        buildWhen: (previous, current) => previous.firstName != current.firstName,
    builder: (context, state) {
      return TextField(
        key: const Key('loginForm_firstNameInput_textField'),
        onChanged: (firstName) =>
            context.read<RegisterBloc>().add(RegisterFirstNameChanged(firstName)),
        decoration: InputDecoration(
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Color(0x00ffffff), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Color(0x00ffffff), width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Color(0x00ffffff), width: 1),
          ),
          hintText: "Prénom",
          hintStyle: const TextStyle(
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
            fontSize: 14,
            color: Color(0xff9f9d9d),
          ),
          filled: true,
          fillColor: const Color(0xffe8e8e8),
          isDense: false,
          contentPadding:
          const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          errorText: state.firstName.displayError != null
              ? "Champs Prénom invalide"
              : null,
        ),
      );
    });
  }
}

class _LastNameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
        buildWhen: (previous, current) => previous.lastName != current.lastName,
        builder: (context, state) {
          return TextField(
            key: const Key('loginForm_firstNameInput_textField'),
            onChanged: (lastName) =>
                context.read<RegisterBloc>().add(RegisterLastNameChanged(lastName)),
            decoration: InputDecoration(
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: const BorderSide(color: Color(0x00ffffff), width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: const BorderSide(color: Color(0x00ffffff), width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: const BorderSide(color: Color(0x00ffffff), width: 1),
              ),
              hintText: "Nom",
              hintStyle: const TextStyle(
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
                fontSize: 14,
                color: Color(0xff9f9d9d),
              ),
              filled: true,
              fillColor: const Color(0xffe8e8e8),
              isDense: false,
              contentPadding:
              const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              errorText: state.lastName.displayError != null
                  ? "Champs Nom invalide"
                  : null,
            ),
          );
        });
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_emailInput_textField'),
          onChanged: (email) =>
              context.read<RegisterBloc>().add(RegisterEmailChanged(email)),
          decoration: InputDecoration(
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(color: Color(0x00ffffff), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(color: Color(0x00ffffff), width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(color: Color(0x00ffffff), width: 1),
            ),
            hintText: "Adresse e-mail",
            hintStyle: const TextStyle(
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
              fontSize: 14,
              color: Color(0xff9f9d9d),
            ),
            filled: true,
            fillColor: const Color(0xffe8e8e8),
            isDense: false,
            contentPadding:
            const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            errorText: state.email.displayError != null
                ? "Adresse e-mail invalide"
                : null,
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_passwordInput_textField'),
          onChanged: (password) =>
              context.read<RegisterBloc>().add(RegisterPasswordChanged(password)),
          obscureText: true,
          decoration: InputDecoration(
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(color: Color(0x00ffffff), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(color: Color(0x00ffffff), width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(color: Color(0x00ffffff), width: 1),
            ),
            hintText: "Mot de passe",
            hintStyle: const TextStyle(
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
              fontSize: 14,
              color: Color(0xff9f9d9d),
            ),
            filled: true,
            fillColor: const Color(0xffe8e8e8),
            isDense: false,
            contentPadding:
            const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            errorText: state.password.displayError != null
                ? 'Mot de passe invalide'
                : null,
          ),
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, state) {
        return state.status.isInProgress
            ? const CircularProgressIndicator()
            : MaterialButton(
            key: const Key('loginForm_continue_raisedButton'),
            onPressed: state.isValid
                ? () {
              context.read<RegisterBloc>().add(const RegisterSubmitted());
            }
                : null,
            color: const Color(0xff1070b8),
            disabledColor: const Color(0xffa1a1ad),
            disabledTextColor: const Color(0xffffffff),
            textColor: const Color(0xffffffff),
            height: 40,
            minWidth: MediaQuery.of(context).size.width,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            padding: const EdgeInsets.all(16),
            child: const Text(
              "S'inscrire",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.normal,
              ),
            ));
      },
    );
  }
}
