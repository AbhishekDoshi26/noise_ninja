import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:noise_meter/noise_meter.dart';
import 'package:noise_ninja/constants/constants.dart';
import 'package:noise_ninja/home/home.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state.status == HomeStatus.error) {
          Navigator.of(context).pop();
        }
      },
      child: const _HomeBody(),
    );
  }
}

class _HomeBody extends StatefulWidget {
  const _HomeBody();

  @override
  State<_HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<_HomeBody> {
  @override
  void dispose() {
    context.read<HomeBloc>().add(DisposeNoiseMeter());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const _HomeContent();
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    final latestReading =
        context.select((HomeBloc bloc) => bloc.state.latestReading);
    final db =
        double.parse((latestReading?.meanDecibel ?? 0).toStringAsPrecision(4));

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: ColorConstants.backgroundColor(db),
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: AnimatedContainer(
          color: ColorConstants.backgroundColor(db),
          duration: const Duration(milliseconds: 400),
          height: MediaQuery.sizeOf(context).height,
          width: MediaQuery.sizeOf(context).width,
          child: Center(
            child: Container(
              margin: const EdgeInsets.all(25),
              child: Stack(
                fit: StackFit.expand,
                alignment: Alignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: Text(
                          'Noise: $db dB',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Positioned(
                    bottom: -5,
                    child: _RecordButton(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RecordButton extends StatefulWidget {
  const _RecordButton();

  @override
  State<_RecordButton> createState() => __RecordButtonState();
}

class __RecordButtonState extends State<_RecordButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<StreamSubscription<NoiseReading>> start(
      {required NoiseMeter noiseMeter, required bool isRecording}) async {
    return noiseMeter.noise.listen(
      (NoiseReading noiseReading) {
        if (!isRecording) {
          isRecording = true;
        }
        context.read<HomeBloc>().add(
              UpdateReadings(
                latestReading: noiseReading,
                isRecording: isRecording,
              ),
            );
      },
    );
  }

  void _onRecordButtonPressed({
    required bool isRecording,
    required NoiseMeter? noiseMeter,
  }) async {
    if (isRecording) {
      _controller
        ..removeListener(() {})
        ..reset()
        ..stop();
      context.read<HomeBloc>().add(StopRecording());
    } else {
      _controller.forward();
      _controller.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      });
      final noiseSubscription = await start(
        noiseMeter: noiseMeter!,
        isRecording: isRecording,
      );
      if (context.mounted) {
        context.read<HomeBloc>().add(
              StartRecording(
                noiseSubscription: noiseSubscription,
              ),
            );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRecording =
        context.select((HomeBloc bloc) => bloc.state.isRecording);
    final noiseMeter = context.select((HomeBloc bloc) => bloc.state.noiseMeter);

    return GestureDetector(
      onTap: () {
        _onRecordButtonPressed(
          isRecording: isRecording,
          noiseMeter: noiseMeter,
        );
      },
      child: Lottie.asset(
        'assets/record_button.json',
        height: 180,
        controller: _controller,
        repeat: true,
        reverse: true,
        onLoaded: (composition) {
          _controller.duration = composition.duration;
        },
      ),
    );
  }
}
