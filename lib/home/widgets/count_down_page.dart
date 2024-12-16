import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wedding_invitation/app_colors.dart';
import 'package:wedding_invitation/l10n/l10n.dart';

class CountDownPage extends StatelessWidget {
  const CountDownPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 176,
          child: Image.asset(
            'assets/images/divider.png',
            height: 100,
            width: MediaQuery.sizeOf(context).width,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const Gap(40),
              SizedBox(
                width: 400,
                child: Text(
                  context.l10n.afterAllThisTime,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: ButtonColors.button1TextColor,
                  ),
                ),
              ),
              const Gap(40),
              const Text(
                'TOMI & EMI',
                style: TextStyle(
                  fontSize: 32,
                  color: ButtonColors.button1TextColor,
                ),
              ),
              const Gap(120),
              AutoSizeText(
                context.l10n.almostThere,
                maxLines: 1,
                style: const TextStyle(
                  fontSize: 24,
                  color: ButtonColors.button1TextColor,
                ),
              ),
              const Gap(40),
              const CountdownTimer(),
            ],
          ),
        ),
      ],
    );
  }
}

class CountdownTimer extends StatefulWidget {
  const CountdownTimer({super.key});

  @override
  CountdownTimerState createState() => CountdownTimerState();
}

class CountdownTimerState extends State<CountdownTimer> {
  late Timer _timer;
  late Duration _remainingTime;
  final targetDate = DateTime(2025, 03, 15, 19);

  @override
  void initState() {
    super.initState();
    _remainingTime = targetDate.difference(DateTime.now());
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _remainingTime = targetDate.difference(DateTime.now());
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final days = _remainingTime.inDays;
    final hours = _remainingTime.inHours % 24;
    final minutes = _remainingTime.inMinutes % 60;
    final seconds = _remainingTime.inSeconds % 60;

    return Center(
      child: SizedBox(
        width: 800,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TimeIndicator(time: days, title: context.l10n.days),
            TimeIndicator(time: hours, title: context.l10n.hours),
            TimeIndicator(time: minutes, title: context.l10n.minutes),
            TimeIndicator(time: seconds, title: context.l10n.seconds),
          ],
        ),
      ),
    );
  }
}

class TimeIndicator extends StatelessWidget {
  const TimeIndicator({
    required this.time,
    required this.title,
    super.key,
  });

  final num time;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(3),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFa17a2d),
                Color(0xFFf5e687),
                Color(0xFFa17a2d),
                Color(0xFFf5e687),
              ],
              tileMode: TileMode.repeated,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
          ),
          child: Container(
            height: 56,
            width: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ButtonColors.button2FillColor,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Center(
              child: Text(
                time.toString(),
                style: const TextStyle(
                  fontSize: 16,
                  color: ButtonColors.button2TextColor,
                ),
              ),
            ),
          ),
        ),
        const Gap(8),
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontSize: 8,
            color: ButtonColors.button1TextColor,
          ),
        ),
      ],
    );
  }
}
