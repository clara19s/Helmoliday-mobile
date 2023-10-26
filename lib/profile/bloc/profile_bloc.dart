import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

import '../models/Email.dart';
import '../models/Name.dart';
import '../models/Password.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(const ProfileState()) {
    on<ProfileFirstNameChanged>(_onFirstNameChanged);
    on<ProfileLastNameChanged>(_onLastNameChanged);
    on<ProfileEmailChanged>(_onEmailChanged);
    on<ProfilePasswordChanged>(_onPasswordChanged);
    on<ProfileSubmitted>(_onSubmitted);
  }

  void _onFirstNameChanged(
    ProfileFirstNameChanged event,
    Emitter<ProfileState> emit,
  ) {
    final firstName = Name.dirty(event.firstName);
    emit(
      state.copyWith(
        firstName: firstName,
        isValid: Formz.validate([state.firstName, firstName]),
      ),
    );
  }

  void _onLastNameChanged(
    ProfileLastNameChanged event,
    Emitter<ProfileState> emit,
  ) {
    final lastName = Name.dirty(event.lastName);
    emit(
      state.copyWith(
        lastName: lastName,
        isValid: Formz.validate([state.lastName, lastName]),
      ),
    );
  }

  void _onEmailChanged(
    ProfileEmailChanged event,
    Emitter<ProfileState> emit,
  ) {
    final email = Email.dirty(event.email);
    emit(
      state.copyWith(
        email: email,
        isValid: Formz.validate([state.email, email]),
      ),
    );
  }

  void _onPasswordChanged(
    ProfilePasswordChanged event,
    Emitter<ProfileState> emit,
  ) {
    final password = Password.dirty(event.password);
    emit(
      state.copyWith(
        password: password,
        isValid: Formz.validate([state.password, password]),
      ),
    );
  }

  void _onSubmitted(
    ProfileSubmitted event,
    Emitter<ProfileState> emit,
  ) {
    if (state.isValid) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    }
  }
}
