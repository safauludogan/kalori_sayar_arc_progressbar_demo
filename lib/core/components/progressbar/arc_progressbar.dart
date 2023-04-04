import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'arc_progress_painter.dart';

class ProgressBarView extends StatefulWidget {
  const ProgressBarView({Key? key, required this.lottieIconPath})
      : super(key: key);
  final String lottieIconPath;
  @override
  State<ProgressBarView> createState() => _ProgressBarViewState();
}

class _ProgressBarViewState extends State<ProgressBarView>
    with TickerProviderStateMixin {
  AnimationController? progressAnimationController;
  Animation<int>? progressAnimation;
  int progress = 0;
  int minutes = 150;
  final double _iconWidth = 72, _iconHeight = 72;
  late final GradiendArcProgressController controller;

  @override
  void initState() {
    super.initState();
    controller = GradiendArcProgressController(
        iconHeight: _iconHeight, iconWidth: _iconWidth);

    startTimer(Duration(minutes: minutes), ((p0) {
      progress += 1;
    }));

    progressAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    progressAnimation = IntTween(
      begin: 0,
      end: 0,
    ).animate(CurvedAnimation(
        parent: progressAnimationController!, curve: Curves.easeInOut));
    progressAnimationController?.forward();
  }

  @override
  void dispose() {
    super.dispose();
    progressAnimationController?.dispose();
  }

  void startTimer(Duration duration, Function(Duration) callback) {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (duration.inSeconds == 0) {
        timer.cancel();
      } else {
        callback(duration);
        duration = duration - const Duration(seconds: 1);
        progressAnimationController = AnimationController(
            vsync: this, duration: const Duration(milliseconds: 1000));
        progressAnimation = IntTween(
          begin: progressAnimation?.value,
          end: progress,
        ).animate(CurvedAnimation(
            parent: progressAnimationController!, curve: Curves.easeInOut))
          ..addListener(() {
            setState(() {});
          });
        progressAnimationController?.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
        body: Center(
      child: Card(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Stack(
            children: [
              CustomPaint(
                painter: GradiendArcProgress(
                    progress: progressAnimation!.value,
                    startColor: const Color(0xff2b3bad),
                    endColor: const Color(0xff2c65d8),
                    width: 25.0,
                    minutes: minutes,
                    controller: controller),
                child: SizedBox(
                  width: width * .8,
                  height: height * .8,
                ),
              ),
              Transform.translate(
                offset: Offset(controller.left, controller.top),
                child: Lottie.asset(
                  widget.lottieIconPath,
                  width: _iconWidth,
                  height: _iconHeight,
                  fit: BoxFit.fill,
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
