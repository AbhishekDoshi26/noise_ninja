part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class InitializeNoiseMeter extends HomeEvent {}

class StartRecording extends HomeEvent {}

class StopRecording extends HomeEvent {}

class DisposeNoiseMeter extends HomeEvent {}
