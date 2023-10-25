import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:helmoliday/profile/bloc/profile_event.dart';
import 'package:profile_repository/profile_repository.dart';
import 'package:helmoliday/profile/bloc/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepository;

  ProfileBloc(this.profileRepository) : super(ProfileState());

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is UpdateProfileEvent) {
      try {
        await profileRepository.updateProfile(
          lastName: event.lastName,
          firstName: event.firstName,
          email: event.email,
          password: event.password,);
      } catch (error) {
        //  TODO : Gérer les erreurs de mise à jour du profil
      }
    }
  }
}
