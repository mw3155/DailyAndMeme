import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

import 'Util.dart';

RiveFile? myRiveFile;

class RobotAnimation extends StatefulWidget {
  const RobotAnimation({Key? key}) : super(key: key);

  @override
  _RobotAnimationState createState() => _RobotAnimationState();
}

class _RobotAnimationState extends State<RobotAnimation> {
  // TODO use this to stop when time finished; Check sample again w button
  // TODO use this to stop when time finished; Check sample again w button
  // TODO use this to stop when time finished; Check sample again w button
  // TODO use this to stop when time finished; Check sample again w button
  // TODO use this to stop when time finished; Check sample again w button
  // TODO use this to stop when time finished; Check sample again w button
  // TODO use this to stop when time finished; Check sample again w button
  void _togglePlay() {
    if (_controller == null) {
      return;
    }
    setState(() {
      _controller!.isActive = !_controller!.isActive;
    });
  }

  void _changeAnimation(String nextAnimationName) {
    print("changing anim");
    final artboard = myRiveFile!.mainArtboard.instance();

    _controller = OneShotAnimation(
      "Animation-Success",
      autoplay: true,
      onStop: () => setState(() {
        print("wow in stop");
        _isPlaying = false;
      }),
      onStart: () => setState(() {
        print("wow in start");
        _isPlaying = true;
      }),
    );

    //artboard.addController(_controller = SimpleAnimation(nextAnimationName));
    artboard.addController(_controller!);
    setState(() {
      _riveArtboard = artboard;
      _riveArtboard!.instance().animationByName(nextAnimationName)!.animation.speed =
          1.0 / durationPick.inSeconds;
    });
  }

  /// Tracks if the animation is playing by whether controller is running.
  bool get isPlaying => _controller?.isActive ?? false;

  bool _isPlaying = false;

  Artboard? _riveArtboard;
  // Todo whyn ote late?
  RiveAnimationController? _controller;
  @override
  void initState() {
    super.initState();

    // Load the animation file from the bundle, note that you could also
    // download this. The RiveFile just expects a list of bytes.
    //          RiveAnimation.asset( "animations/animation-robot1.riv",
    rootBundle.load('assets/animations/animation-dailyrobot-v3.riv').then(
      (data) async {
        // Load the RiveFile from the binary data.
        myRiveFile = RiveFile.import(data);

        // The artboard is the root of the animation and gets drawn in the Rive widget.
        final artboard = myRiveFile!.mainArtboard.instance();
        // Add a controller to play back a known animation on the main/default artboard.
        // We store a reference to it so we can toggle playback.
        String nextAnimationName = "Animation-Success";
        artboard.addController(_controller = SimpleAnimation(nextAnimationName));
        setState(() {
          _riveArtboard = artboard;
          _riveArtboard!.instance().animationByName(nextAnimationName)!.animation.speed =
              1.0 / durationPick.inSeconds;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double robotSize = MediaQuery.of(context).size.shortestSide * 0.6;
    print("rebuild robotanim");

    if (isTimePaused && isPlaying) _togglePlay();
    if (!isTimePaused && !isPlaying) _togglePlay();

    if (!isTimePaused &&
        isPlaying &&
        nSecondsPassedCurrentSpeaker % durationPick.inSeconds == 0 &&
        myRiveFile != null) {
      Random nextRandom = new Random();
      _changeAnimation(robotAnimations[nextRandom.nextInt(3)]);
    }

    return Column(
      children: [
        SizedBox(
          width: robotSize,
          height: robotSize,
          child: Center(
            child: _riveArtboard == null
                ? const SizedBox()
                : Rive(
                    artboard: _riveArtboard!,
                    fit: BoxFit.contain,
                  ),
          ),
        ),
      ],
    );
  }
}
