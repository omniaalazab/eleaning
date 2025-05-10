import 'package:flutter/widgets.dart';

class ProfileState {}

class InitialProfileState extends ProfileState {}

class LoadingProfileState extends ProfileState {}

class SucessProfileState extends ProfileState {
  final ImageProvider<Object> imageProvider;
  SucessProfileState({required this.imageProvider});
}

class FailureProfileState extends ProfileState {
  final String error;
  FailureProfileState({required this.error});
}
