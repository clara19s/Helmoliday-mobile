part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

final class ProfileFirstNameChanged extends ProfileEvent {
  const ProfileFirstNameChanged(this.firstName);

  final String firstName;

  @override
  List<Object> get props => [firstName];
}

final class ProfileLastNameChanged extends ProfileEvent {
  const ProfileLastNameChanged(this.lastName);

  final String lastName;

  @override
  List<Object> get props => [lastName];
}

final class ProfileEmailChanged extends ProfileEvent {
  const ProfileEmailChanged(this.email);

  final String email;

  @override
  List<Object> get props => [email];
}

final class ProfilePasswordChanged extends ProfileEvent {
  const ProfilePasswordChanged(this.password);

  final String password;

  @override
  List<Object> get props => [password];
}

final class ProfileSubmitted extends ProfileEvent {
  const ProfileSubmitted();
}