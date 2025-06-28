import 'package:meta/meta.dart';

@immutable
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}
class ProfileLoading extends ProfileState {}
class ProfileInfoUpdated extends ProfileState {}
class PasswordChangedSuccessfully extends ProfileState {}
class ProfileError extends ProfileState {
  final String message;
  ProfileError({required this.message});
}
