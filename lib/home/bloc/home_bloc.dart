import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noise_meter/noise_meter.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState.initial()) {
    on<InitializeNoiseMeter>(_onInitializeNoiseMeter);
    on<StartRecording>(_onStartRecording);
    on<StopRecording>(_onStopRecording);
    on<DisposeNoiseMeter>(_onDisposeNoiseMeter);
  }

  void _onInitializeNoiseMeter(
    InitializeNoiseMeter event,
    Emitter<HomeState> emit,
  ) {
    final noiseMeter = NoiseMeter((Object error) {
      emit(state.copyWith(
        isRecording: false,
        errorMessage: error.toString(),
      ));
    });
    emit(state.copyWith(noiseMeter: noiseMeter));
  }

  void _onStartRecording(
    StartRecording event,
    Emitter<HomeState> emit,
  ) {
    try {
      final noiseSubscription = state.noiseMeter?.noise.listen(
        (NoiseReading noiseReading) {
          bool isRecording = state.isRecording;
          if (!isRecording) {
            isRecording = true;
          }
          emit(state.copyWith(
            latestReading: noiseReading,
            isRecording: isRecording,
          ));
        },
      );
      emit(state.copyWith(noiseSubscription: noiseSubscription));
    } catch (err) {
      emit(
        state.copyWith(
          status: HomeStatus.error,
          errorMessage: err.toString(),
        ),
      );
    }
  }

  void _onStopRecording(
    StopRecording event,
    Emitter<HomeState> emit,
  ) async {
    try {
      await state.noiseSubscription?.cancel();

      emit(
        state.copyWith(
          noiseSubscription: null,
          isRecording: false,
        ),
      );
    } catch (err) {
      emit(
        state.copyWith(
          status: HomeStatus.error,
          errorMessage: err.toString(),
        ),
      );
    }
  }

  void _onDisposeNoiseMeter(
    DisposeNoiseMeter event,
    Emitter<HomeState> emit,
  ) {
    state.noiseSubscription?.cancel();
    emit(state.copyWith(noiseSubscription: null));
  }
}
