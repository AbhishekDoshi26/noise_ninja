import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    final isRecording =
        context.select((HomeBloc bloc) => bloc.state.isRecording);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: isRecording ? Colors.red : Colors.green,
        onPressed: isRecording
            ? () {
                context.read<HomeBloc>().add(StopRecording());
              }
            : () {
                context.read<HomeBloc>().add(StartRecording());
              },
        child: isRecording ? const Icon(Icons.stop) : const Icon(Icons.mic),
      ),
      body: const _HomeContent(),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    final latestReading =
        context.select((HomeBloc bloc) => bloc.state.latestReading);
    final isRecording =
        context.select((HomeBloc bloc) => bloc.state.isRecording);

    return Center(
      child: Container(
        margin: const EdgeInsets.all(25),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: Text(isRecording ? "Mic: ON" : "Mic: OFF",
                  style: const TextStyle(fontSize: 25, color: Colors.blue)),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: Text(
                'Noise: ${latestReading?.meanDecibel} dB',
              ),
            ),
            Text(
              'Max: ${latestReading?.maxDecibel} dB',
            )
          ],
        ),
      ),
    );
  }
}
