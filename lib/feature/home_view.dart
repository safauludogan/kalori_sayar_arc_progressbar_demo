import 'package:flutter/material.dart';
import 'package:kalori_sayar_progresbar_demo/core/components/progressbar/arc_progressbar.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ProgressBarView(
        lottieIconPath: 'assets/lottie/lottie_calorie.json',
      ),
    );
  }
}
