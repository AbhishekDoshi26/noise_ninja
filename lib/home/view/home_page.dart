import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noise_ninja/home/home.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Route<void> createRoute() {
    return MaterialPageRoute(
      builder: (context) {
        return const HomePage();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeBloc()..add(InitializeNoiseMeter()),
      child: const HomeView(),
    );
  }
}
