part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class InitializeNoiseMeter extends HomeEvent {}

class StartRecording extends HomeEvent {
  const StartRecording({required this.noiseSubscription});

  final StreamSubscription<NoiseReading> noiseSubscription;

  @override
  List<Object?> get props => [noiseSubscription];
}

class StopRecording extends HomeEvent {}

class DisposeNoiseMeter extends HomeEvent {}

class UpdateReadings extends HomeEvent {
  const UpdateReadings({
    required this.latestReading,
    required this.isRecording,
  });

  final NoiseReading latestReading;
  final bool isRecording;

  @override
  List<Object?> get props => [latestReading, isRecording];
}
