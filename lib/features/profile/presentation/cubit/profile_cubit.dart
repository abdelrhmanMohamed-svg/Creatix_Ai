import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_profile.dart';
import '../../domain/usecases/update_profile.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfile _getProfile;
  final UpdateProfile _updateProfile;
  String? _currentUserId;

  ProfileCubit({
    required GetProfile getProfile,
    required UpdateProfile updateProfile,
  })  : _getProfile = getProfile,
        _updateProfile = updateProfile,
        super(const ProfileInitial());

  Future<void> loadProfile(String userId) async {
    _currentUserId = userId;
    emit(const ProfileLoading());
    final result = await _getProfile.call(userId);
    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (profile) => emit(ProfileLoaded(profile)),
    );
  }

  Future<void> updateProfile({
    String? fullName,
    String? avatarUrl,
  }) async {
    if (_currentUserId == null) return;
    emit(const ProfileUpdating());
    final result = await _updateProfile.call(
      userId: _currentUserId!,
      fullName: fullName,
      avatarUrl: avatarUrl,
    );
    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (profile) => emit(ProfileLoaded(profile)),
    );
  }
}
