part of 'profile_bloc.dart';

final class ProfileState extends Equatable {
  const ProfileState({
    this.status = FormzSubmissionStatus.initial,
    this.firstName = const Name.pure(),
    this.lastName = const Name.pure(),
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.isValid = false
  });

  final FormzSubmissionStatus status;
  final Name firstName;
  final Name lastName;
  final Email email;
  final Password password;
  final bool isValid;

  ProfileState copyWith({
    FormzSubmissionStatus? status,
    Name? firstName,
    Name? lastName,
    Email? email,
    Password? password,
    isValid,
  }) {
    return ProfileState(
      status: status ?? this.status,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  @override
  List<Object?> get props => [firstName, lastName, email, password];
}