part of 'home_bloc.dart';

enum HomeStatus {
  initial,
  loading,
  loaded,
  error,
}

class HomeState extends Equatable {
  const HomeState({
    required this.status,
    required this.isRecording,
    required this.latestReading,
    required this.noiseMeter,
    required this.noiseSubscription,
    required this.errorMessage,
  });

  const HomeState.initial()
      : this(
          status: HomeStatus.initial,
          isRecording: false,
          latestReading: null,
          noiseMeter: null,
          noiseSubscription: null,
          errorMessage: '',
        );

  final HomeStatus status;
  final bool isRecording;
  final NoiseReading? latestReading;
  final StreamSubscription<NoiseReading>? noiseSubscription;
  final NoiseMeter? noiseMeter;
  final String errorMessage;

  HomeState copyWith({
    HomeStatus? status,
    bool? isRecording,
    NoiseReading? latestReading,
    NoiseMeter? noiseMeter,
    StreamSubscription<NoiseReading>? noiseSubscription,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      isRecording: isRecording ?? this.isRecording,
      latestReading: latestReading ?? this.latestReading,
      noiseMeter: noiseMeter ?? this.noiseMeter,
      noiseSubscription: noiseSubscription ?? this.noiseSubscription,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        isRecording,
        latestReading,
        noiseMeter,
        noiseSubscription,
        errorMessage,
      ];
}
